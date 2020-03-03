using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Linq;
using System.Data.Common;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Reflection;

using LinqKit;
using D = eTaxi.Definitions;
namespace eTaxi.L2SQL
{
    /// <summary>
    /// 数据服务基类
    /// </summary>
    /// <typeparam name="TContext"></typeparam>
    public abstract class DTServiceBase<TContext> : ServiceBase<TContext> where TContext : DataContextEx
    {
        public DTServiceBase(IConnectionManagerEx manager, bool trackingEnabled = true) : base(manager, trackingEnabled) { }

        /// <summary>
        /// 生成一个 X_Batch 记录，并为后期登记变化状态
        /// </summary>
        /// <param name="create">生成任务头</param>
        /// <param name="trace">加入任务执行上下文</param>
        /// <param name="transControl">是否将头创建与任务执行体做事务控制</param>
        public void NewJobTrace(
            Func<TB_sys_batch, bool> create,
            Action<TB_sys_batch, TContext> trace, bool transControlled = false)
        {
            var newId = Guid.NewGuid();
            var job = new TB_sys_batch()
            {
                Id = newId,
                Completed = false,
                Channel = (int)D.BatchChannel.Timer,
                Priority = -1
            };

            // 如果无需创建，则返回
            if (!create(job)) return;
            if (transControlled)
            {
                trace(job, Context);
            }
            else
            {
                var tb = Context.GetTable<TB_sys_batch>();
                tb.InsertOnSubmit(job);
                Context.SubmitChanges();
                trace(tb.Single(j => j.Id == newId), Context);
            }
        }

    }

}