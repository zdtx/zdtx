using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.Web;
using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 由一个 ButtonEdit 和一个 DropDown 组成
    /// 仅仅支持 UpdatePanel 下操作
    /// </summary>
    public partial class DropDownField_DX : BaseControl
    {
        private bool _ShowEdit = false;
        public bool ShowEdit
        {
            get { return _ShowEdit; }
            set { _ShowEdit = value; }
        }

        private string _EditText = "X";
        public string EditText
        {
            get { return _EditText; }
            set { _EditText = value; }
        }

        public ASPxButtonEdit BE { get { return b; } }
        public string Text
        {
            get { return b.Text; }
            set { b.Text = value; }
        }

        public string Value
        {
            get { return v.Value; }
            set { v.Value = value; }
        }

        public void Clear()
        {
            Text = string.Empty;
            Value = string.Empty;
        }

        public Unit Width { set { b.Width = value; } }
        public Unit Height { set { b.Height = value; } }
        public bool ReadOnly { set { b.ReadOnly = value; } }
        public string NullText { set { b.NullText = value; } }
        public string HeaderText { set { p.HeaderText = value; } }
        public bool ShowFooter { set { p.ShowFooter = value; } }
        public bool Shown { set { _shown.Value = value.ToString(); } }
        public Unit DPWidth { set { p.Width = value; } }
        public Unit DPMaxWidth { set { p.MaxWidth = value; } }
        public Unit DPHeight { set { p.Height = value; } }
        public Unit DPMaxHeight { set { p.MaxHeight = value; } }

        /// <summary>
        /// 初始化下拉（应该将此方法放入 _SetInitialStates 中）
        /// </summary>
        /// <typeparam name="T">控件类型</typeparam>
        /// <param name="controlPath">控件所在路径</param>
        /// <param name="show">当要展示控件的时候使用的方法</param>
        /// <param name="set">控件中发出 OK 事件的对应处理方法（赋值）</param>
        /// <param name="clear">点击“X”按钮</param>
        /// <param name="config"></param>
        public void Initialize<T>(string controlPath,
            // 当值被选定的时候
            Func<T, ASPxButtonEdit, HiddenField, bool> set,
            // 展示下拉内容
            Action<T, ASPxButtonEdit, HiddenField> execute = null,
            // 清除值
            Action<ASPxButtonEdit> clear = null) where T : BaseControl
        {
            var c = LoadControl(controlPath) as T;
            c.ID = "c";
            pC.Controls.Add(c);

            // 事件处理
            c.EventSinked += (cc, eType, param) =>
            {
                switch (eType)
                {
                    case EventTypes.OK:
                        if (set(c, b, v)) p.ShowOnPageLoad = false;
                        break;
                }
            };

            // 观察下拉按钮
            b.ButtonClick += (s, e) =>
            {
                switch (e.ButtonIndex)
                {
                    case 0: // 下拉

                        if (!_shown.Value.ToBooleanOrDefault(false))
                        {
                            if (execute != null) execute(c, b, v); else c.Execute();
                            _shown.Value = true.ToString();
                        }
                        p.ShowOnPageLoad = true;

                        break;

                    case 1: // 点击编辑按钮

                        if (clear != null) clear(b);
                        else
                        {
                            b.Text = string.Empty; b.Value = null; v.Value = null;
                        }

                        break;
                }
            };

        }

        /// <summary>
        /// 进行纯粹的客户端 JS 控制
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="controlPath"></param>
        /// <param name="set"></param>
        /// <param name="execute"></param>
        /// <param name="clear"></param>
        public void InitializeEx<T>(string controlPath,
            /// 展示下拉内容，并且绑定客户端行为，参数说明：
            /// 1. dropdown panel instancename
            /// 2. aspedit instancename
            /// 3. hiddenfield instancename
            Action<T, string, string, string> execute = null,
            Func<string, string, string, string> clearButtonBind = null) where T : BaseControl
        {
            var c = LoadControl(controlPath) as T;
            c.ID = "c";
            pC.Controls.Add(c);

            var clearHandle = string.Empty;
            if (clearButtonBind != null)
            {
                clearHandle = clearButtonBind(
                    p.ClientInstanceName, b.ClientInstanceName, string.Format("$get('{0}')", v.ClientID));
            }
            else
            {
                clearHandle = string.Format(
                    "{0}.Clear();$get('{1}').value='';", b.ClientInstanceName, v.ClientID);
            }

            // 修改客户端行为
            b.ClientSideEvents.ButtonClick = string.Format(
                "function(s,e){{switch(e.buttonIndex){{case 0:if($get('{0}').value==='True')e.processOnServer=false;else ISEx.loadingPanel.show();{1}.Show();break;case 1:{2}e.processOnServer=false;break;}} }}",
                _shown.ClientID, p.ClientInstanceName, clearHandle);

            // 观察下拉按钮
            b.ButtonClick += (s, e) =>
            {
                switch (e.ButtonIndex)
                {
                    case 0: // 下拉

                        if (!_shown.Value.ToBooleanOrDefault(false))
                        {
                            if (execute != null)
                            {
                                execute(c, p.ClientInstanceName, b.ClientInstanceName, string.Format("$get('{0}')", v.ClientID));
                            }
                            else
                            {
                                c.Execute();
                            }
                            _shown.Value = true.ToString();
                        }
                        p.ShowOnPageLoad = true;

                        break;
                }
            };

        }

        /// <summary>
        /// 执行
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public void Execute<T>(
            Action<T, ASPxButtonEdit, HiddenField> execute = null) where T : BaseControl
        {
            var c = pC.FindControl("c") as T;
            if (execute != null) { execute(c, b, v); return; }
            c.Execute();
        }

    }
}