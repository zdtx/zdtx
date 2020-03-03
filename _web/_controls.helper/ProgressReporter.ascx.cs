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
    /// Ϊ���ֿͻ��ˣ�ִ�ж�����ͻ��˱��ͳ������ִ�н���
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
        /// Timer �ص���ʱ����
        /// </summary>
        public int Interval
        {
            get { return _ViewStateEx.Get<int>(States.Interval, 1000); }
            set { _ViewStateEx.Set<int>(value, States.Interval); }
        }

        /// <summary>
        /// ��������Ϣ
        /// </summary>
        public string Caller
        {
            get { return _ViewStateEx.Get<string>(States.Caller); }
            set { _ViewStateEx.Set<string>(value, States.Caller); }
        }

        /// <summary>
        /// չʾ����ʾ��Ϣ
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
        /// �γɵ��ñհ�������һ��������Ȼ�����һ����������
        /// </summary>
        /// <param name="interval">�������΢��</param>
        /// <param name="caller"></param>
        /// <param name="text"></param>
        public virtual void Go(int interval, string caller = null, string text = null) { }

        /// <summary>
        /// չʾ��ʾ��Ϣ
        /// </summary>
        public virtual void Show(string text) { }

        /// <summary>
        /// �ر���ʾ��
        /// </summary>
        public virtual void Close() { }

    }
}