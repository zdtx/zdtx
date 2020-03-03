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

using DevExpress.Web;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// Ϊ����������ؼ��γɻص��ջ�����������ɲ��֣�
    /// 1. JS ��� + �����߱�ʶ
    /// 2. ʱ�䴦��������������
    /// </summary>
    public partial class Callback_Generic : BaseControl
    {
        /// <summary>
        /// ע�ᴥ���ؼ�
        /// </summary>
        public class Register
        {
            private List<string> _Controls = null;
            private Button _Button = null;
            private Page _Page = null;
            private string _GetHandle(string param) { return _Page.ClientScript.GetPostBackEventReference(_Button, param); }
            public Register(List<string> controls, Button button, Page page)
            {
                _Controls = controls;
                _Button = button;
                _Page = page;
            }
            
            /// <summary>
            /// �ؼ���scriptHandle ����Ϊ
            /// </summary>
            public Register Do(Control tb, Action<string> scriptHandle = null)
            {
                _Controls.Add(tb.ClientID);
                if (scriptHandle != null) scriptHandle(_GetHandle(tb.ClientID));
                return this;
            }

        }

        /// <summary>
        /// ע������Ŀؼ���
        /// </summary>
        private List<string> _Controls = new List<string>();

        /// <summary>
        /// ��ʼ��
        /// </summary>
        /// <param name="register"></param>
        public virtual void Initialize(
            Action<Callback_Generic.Register> register = null, 
            Action<string> handle = null)
        {
            if (register != null)
            {
                Register reg = new Register(_Controls, b, Page);
                register(reg);
            }

            b.Click += (s, e) =>
            {
                string param = Request.Params["__EVENTARGUMENT"].ToString();
                if (handle != null) handle(param);
            };
        }

    }
}