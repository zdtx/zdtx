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
    /// 为保持客户端，执行定期向客户端报送长任务的执行进度
    /// </summary>
    public partial class ProgressReporter : BaseControl
    {
        public class States
        {
            public const string Caller = "caller";
            public const string Interval = "interval";
            public const string Text = "text";
        }

        /// <summary>
        /// Timer 回调的时间间隔
        /// </summary>
        public int Interval
        {
            get { return _ViewStateEx.Get<int>(States.Interval, 1000); }
            set { _ViewStateEx.Set<int>(value, States.Interval); }
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
        /// 展示的提示信息
        /// </summary>
        public string Text
        {
            get { return _ViewStateEx.Get<string>(States.Text); }
            set { _ViewStateEx.Set<string>(value, States.Text); }
        }

        /// <summary>
        /// (caller, parameter)
        /// </summary>
        public event Action<string, string> Callback = null;
        protected override void _SetInitialStates()
        {
            b.Click += (s, e) => { if (Callback != null) Callback(Caller, Text); };
        }

        /// <summary>
        /// 形成调用闭包（触发一个动作，然后给定一个检测操作）
        /// </summary>
        /// <param name="interval">间隔，即微秒</param>
        /// <param name="caller"></param>
        /// <param name="text"></param>
        public virtual void Go(int interval, string caller = null, string text = null) { }

        /// <summary>
        /// 展示提示信息
        /// </summary>
        public virtual void Show(string text) { }

        /// <summary>
        /// 关闭提示框
        /// </summary>
        public virtual void Close() { }

    }
}