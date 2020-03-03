using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

using Ext.Net;
namespace eTaxi.Web
{
    /// <summary>
    /// Ext.NET 的应用
    /// 要点：
    /// 1. Ext 页面需要 ResourceManager 句柄
    /// 2. 初启函数需要句柄定义
    /// 3. 服务器 Ext 对象需要客户端映射
    /// 4. 浮动到页面脚本使用
    /// </summary>
    public class ExtPageDecorator : PageDecorator
    {
        public string ObjectHandle = "ISEx";
        public ExtPageDecorator(Page page) : base(page) { }

        private List<Control> _Controls = new List<Control>();
        public ExtPageDecorator Register(Control control) { return Register(new Control[] { control }); }
        public ExtPageDecorator Register(Control[] controls)
        {
            _Controls.AddRange(controls);
            return this;
        }

        private string _StartupStatement = null;
        public ExtPageDecorator EnableStartup(string handle = null)
        {
            string name =
                string.IsNullOrEmpty(handle) ? _Page.ClientID : handle;
            _StartupStatement = string.Format("{0}();", name);
            return this;
        }

        private ResourceManager _ExtManager = null;
        public ExtPageDecorator Configure(Action<ResourceManager> handle)
        {
            if (_ExtManager == null)
            {
                ExtMasterPage masterPage = _Page.Master as ExtMasterPage;
                _ExtManager = masterPage.ExtManager;
            }
            handle(_ExtManager);
            return this;
        }

        public override void Go()
        {
            ExtMasterPage masterPage = _Page.Master as ExtMasterPage;
            List<string> statements = new List<string>();
            string statement = string.Empty;

            if (_Controls.Count > 0)
            {
                statement = string.Empty;
                _Controls.ForEach(c =>
                    statement += string.Format("{0}:{1}",
                    statement.Length == 0 ? c.ID : "," + c.ID, c.ClientID));
                statement = string.Format("{0}.os={{{1}}};", ObjectHandle, statement);
            }

            if (!string.IsNullOrEmpty(statement)) statements.Add(statement);
            if (!string.IsNullOrEmpty(
                _StartupStatement)) statements.Add(_StartupStatement);

            if (statements.Count > 0)
            {
                statement = string.Empty;
                statements.ForEach(s => statement += s);
                masterPage.ExtManager.Listeners.DocumentReady.Handler = statement;
            }
        }

    }
}