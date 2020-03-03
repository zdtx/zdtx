using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Linq.Expressions;

using LinqKit;

using eTaxi.L2SQL;
namespace eTaxi.Web.Controls.Selection.Department
{
    public partial class TreeItem : BaseControl
    {
        public enum Scope
        {
            NoLimit, OperatorSite, OperatorChildDept
        }

        public enum SourceType
        {
            Current, Ex
        }

        public virtual List<TB_department> Selection { get { return new List<TB_department>(); } }

        /// <summary>
        /// nodeClickHandle：节点被点击的时候，此上下文 function(s,e) s 和 e 有效
        /// </summary>
        /// <param name="clientBind"></param>
        public virtual void EnableJSInteractionOnly(string nodeClickHandle) { }

        public class States
        {
            public const string RootId = "rootId";
            public const string OnClickHandle = "onClickHandle";
            public const string ApplySessionFilter = "applySessionFilter";
        }

        private Scope _SearchScope = Scope.NoLimit;
        public Scope SearchScope
        {
            get { return _SearchScope; }
            set { _SearchScope = value; }
        }

        public string RootId
        {
            get { return _ViewStateEx.Get<string>(States.RootId, string.Empty); }
            set { _ViewStateEx.Set<string>(value, States.RootId); }
        }

        public string OnClickHandle
        {
            get { return _ViewStateEx.Get<string>(States.OnClickHandle, string.Empty); }
            set { _ViewStateEx.Set<string>(value, States.OnClickHandle); }
        }

        public bool ApplySessionFilter
        {
            get { return _ViewStateEx.Get<bool>(States.ApplySessionFilter, false); }
            set { _ViewStateEx.Set<bool>(value, States.ApplySessionFilter); }
        }

        protected Func<TB_department, bool> _Filter = null;
        public virtual Func<TB_department, bool> Filter
        {
            get { return _Filter; }
            set { _Filter = value; }
        }

        public DevExpress.Web.ASPxTreeView Tree { get { return tv; } }

    }
}