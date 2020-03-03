using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 多次客户端请求组件
    /// </summary>
    public partial class MultiRequester : BaseControl
    {
        public class States
        {
            public const string TicketId = "ticketId";
            public const string Index = "index";
            public const string Total = "total";
            public const string BatchSize = "batchSize";
            public const string Name = "name";
        }

        /// <summary>
        /// 批处理任务名称
        /// </summary>
        public string Name
        {
            get { return _ViewStateEx.Get<string>(States.Name); }
            set { _ViewStateEx.Set<string>(value, States.Name); }
        }

        /// <summary>
        /// 执行次数计数
        /// </summary>
        public int Index
        {
            get { return _ViewStateEx.Get<int>(States.Index); }
            set { _ViewStateEx.Set<int>(value, States.Index); }
        }

        /// <summary>
        /// 所有任务总数
        /// </summary>
        public int Total
        {
            get { return _ViewStateEx.Get<int>(States.Total); }
            set { _ViewStateEx.Set<int>(value, States.Total); }
        }

        /// <summary>
        /// 票据 ID
        /// </summary>
        public Guid TicketId
        {
            get { return _ViewStateEx.Get<Guid>(States.TicketId, Guid.NewGuid()); }
            set { _ViewStateEx.Set<Guid>(value, States.TicketId); }
        }

        /// <summary>
        /// 每次发起的处理量
        /// </summary>
        public int BatchSize
        {
            get { return _ViewStateEx.Get<int>(States.BatchSize, 1); }
            set { _ViewStateEx.Set<int>(value, States.BatchSize); }
        }

        public string Header { set { p.HeaderText = value; } }
        public Unit Width { set { p.Width = value; } }
        public Unit Height { set { p.Height = value; } }

        /// <summary>
        /// 初始化配置（一定要放入 _SetInitialStates）
        /// </summary>
        public virtual void Initialize(Func<object[], bool> go,
            Func<object[], string> taskDescribe = null, Action done = null, Action abort = null) { }

        /// <summary>
        /// 开始执行
        /// </summary>
        public virtual void Execute(Action<List<object>> tasksSet, string name) { }

        /// <summary>
        /// 重置状态
        /// </summary>
        public virtual void Reset() { }


    }
}