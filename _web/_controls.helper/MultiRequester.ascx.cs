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
    /// ��οͻ����������
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
        /// ��������������
        /// </summary>
        public string Name
        {
            get { return _ViewStateEx.Get<string>(States.Name); }
            set { _ViewStateEx.Set<string>(value, States.Name); }
        }

        /// <summary>
        /// ִ�д�������
        /// </summary>
        public int Index
        {
            get { return _ViewStateEx.Get<int>(States.Index); }
            set { _ViewStateEx.Set<int>(value, States.Index); }
        }

        /// <summary>
        /// ������������
        /// </summary>
        public int Total
        {
            get { return _ViewStateEx.Get<int>(States.Total); }
            set { _ViewStateEx.Set<int>(value, States.Total); }
        }

        /// <summary>
        /// Ʊ�� ID
        /// </summary>
        public Guid TicketId
        {
            get { return _ViewStateEx.Get<Guid>(States.TicketId, Guid.NewGuid()); }
            set { _ViewStateEx.Set<Guid>(value, States.TicketId); }
        }

        /// <summary>
        /// ÿ�η���Ĵ�����
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
        /// ��ʼ�����ã�һ��Ҫ���� _SetInitialStates��
        /// </summary>
        public virtual void Initialize(Func<object[], bool> go,
            Func<object[], string> taskDescribe = null, Action done = null, Action abort = null) { }

        /// <summary>
        /// ��ʼִ��
        /// </summary>
        public virtual void Execute(Action<List<object>> tasksSet, string name) { }

        /// <summary>
        /// ����״̬
        /// </summary>
        public virtual void Reset() { }


    }
}