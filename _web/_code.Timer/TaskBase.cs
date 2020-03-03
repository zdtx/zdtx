using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web.UI;
using System.Web.SessionState;
using System.Linq;
using System.Linq.Expressions;
using System.Globalization;
using System.Data;
using System.Data.Linq;

using LinqKit;

using D = eTaxi.Definitions;
using E = eTaxi.Exceptions;
using eTaxi.L2SQL;
namespace eTaxi.TimerService
{
    /// <summary>
    /// 属于控件级别的执行器，用于嵌套时序事件的执行
    /// 注：此 ascx 不参与实际的 page 视区，因此仅仅 创建-执行 后丢弃
    /// </summary>
    public abstract class TaskBase : System.Web.UI.UserControl
    {
        protected T _DTContext<T>(
            bool readOnly = false) where T : CommonContext { return Util.DTContext<T>(readOnly); }
        protected CommonService _DTService = null;
        protected DateTime _CurrentTime = DateTime.Now;
        protected int _CommandExecutionTimeout = 1200; // 20 分钟

        /// <summary>
        /// 标注这个任务是否可用
        /// </summary>
        public abstract bool Enabled { get; }

        /// <summary>
        /// 任务编码
        /// </summary>
        public abstract string Code { get; }

        /// <summary>
        /// 任务名称（描述）
        /// </summary>
        public abstract string Name { get; }

        /// <summary>
        /// 找出任务执行器的归属
        /// </summary>
        public abstract int ContainerIndex { get; }

        /// <summary>
        /// 是否需要开事务
        /// </summary>
        public virtual bool RequireTransaction { get { return false; } }

        /// <summary>
        /// 当前时间
        /// </summary>
        public DateTime CurrentTime { get { return _CurrentTime; } }

        /// <summary>
        /// 初始化，形成执行上下文
        /// </summary>
        public TaskBase Initialize(CommonService dtService, DateTime currentTime)
        {
            _DTService = dtService;
            _CurrentTime = currentTime;
            return this;
        }

        /// <summary>
        /// 前置检查
        /// </summary>
        /// <param name="last"></param>
        /// <param name="current"></param>
        /// <returns></returns>
        protected virtual bool _ShouldDo(TB_sys_batch last, Action<string> tip) { return true; }

        /// <summary>
        /// 执行方法入口
        /// </summary>
        /// <param name="handle">(上次执行，当前执行)</param>
        protected virtual void _Execute(TB_sys_batch last, TB_sys_batch current, Action<string> succeeded) { }

        /// <summary>
        /// 以下为闭包方法，通过 X_Batch 执行方法的详细记录
        /// </summary>
        /// <param name="exceptionHandle"></param>
        /// <param name="succeeded"></param>
        public void Execute(
            Action<Exception> exceptionHandle, Action<string> succeeded, Action<string> tip)
        {
            try
            {
                var c = _DTContext<CommonContext>(true);
                var last = (
                    from j in c.Batches
                    where
                        j.Channel == (int)D.BatchChannel.Timer &&
                        j.Name == Code && j.Completed
                    orderby j.Time descending
                    select j
                ).FirstOrDefault();

                // 前置检查
                if (!_ShouldDo(last, tip)) return;
                Action _call = () =>
                {
                    _DTService.NewJobTrace(job =>
                    {
                        job.Name = Code;
                        job.Channel = (int)D.BatchChannel.Timer;
                        job.Time =
                        job.LastActionTime = _CurrentTime;
                        return true;

                    }, (current, context) =>
                    {
                        _Execute(last, current, succeeded);
                        current.Completed = true;
                        current.LastActionTime = DateTime.Now;
                        context.SubmitChanges();
                    });
                };

                Util.TransCall(_call, ex => { throw ex; }, RequireTransaction);

            }
            catch (Exception ex)
            {
                exceptionHandle(ex);
            }
        }

    }
}