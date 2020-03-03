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
    /// 整合客户端形成一个回调环，例如：
    /// 后台 Confirm 前台操作
    /// </summary>
    public partial class Callback : BaseControl
    {
        public class States
        {
            public const string Caller = "caller";
            public const string Parameter = "parameter";
        }

        /// <summary>
        /// 调用者信息
        /// </summary>
        public string Caller
        {
            get { return _ViewStateEx.Get<string>(States.Caller); }
            set { _ViewStateEx.Set<string>(value, States.Caller); }
        }

        /// <summary>
        /// 方法的参数缓存
        /// </summary>
        public string Parameter
        {
            get { return _ViewStateEx.Get<string>(States.Parameter); }
            set { _ViewStateEx.Set<string>(value, States.Parameter); }
        }

        /// <summary>
        /// (caller, parameter)
        /// </summary>
        public event Action<string, string> Resumed = null;
        protected override void _SetInitialStates()
        {
            b.Click += (s, e) => { if (Resumed != null) Resumed(Caller, Parameter); };
        }

        public void Break(string caller, string parameter, 
            Func<bool> wrapCall, Action<string> jsExecute = null)
        {
            Caller = caller;
            Parameter = parameter;
            string handle = Page.ClientScript.GetPostBackEventReference(b, parameter);
            if (wrapCall())
            {
                string js = Page.ClientScript.GetPostBackEventReference(b, string.Empty) + ";";
                if (jsExecute != null) jsExecute(js);
            }
        }

    }
}