using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using DevExpress.Web;

namespace eTaxi.Web.Controls
{
    public partial class ActionToolbar : BaseControl
    {
        public class Configurator
        {
            ActionToolbar _ActionToolbar = null;
            public Configurator Button(BaseControl.EventTypes eventType, Action<ControlLoader.Button> set = null)
            {
                _ActionToolbar.Buttons[eventType].Visible = true;
                if (set != null) set(_ActionToolbar.Buttons[eventType]);
                return this;
            }
            public Configurator(ActionToolbar tb) { _ActionToolbar = tb; }
        }

        protected BaseControl _HostingControl = null;
        protected string _ValidationGroup = null;
        protected Dictionary<BaseControl.EventTypes, ControlLoader.Button> _Buttons = new Dictionary<BaseControl.EventTypes, ControlLoader.Button>();
        public Dictionary<BaseControl.EventTypes, ControlLoader.Button> Buttons { get { return _Buttons; } }

        /// <summary>
        /// 用于提示用户的校验错误提示
        /// </summary>
        public virtual string ValidationFailTips { get { return string.Empty; } }
        protected void _SetButtons()
        {
            Action<ASPxButton, ControlLoader.Button> set = (b, p) =>
            {
                if (!string.IsNullOrEmpty(_ValidationGroup)) b.ValidationGroup = _ValidationGroup;
                b.Text = p.Text;
                b.Visible = p.Visible;
                b.CausesValidation = p.CausesValidation;
                if (!string.IsNullOrEmpty(p.ImageFile)) b.ImageUrl = "~/images/" + p.ImageFile;
                if (!string.IsNullOrEmpty(p.JSHandle))
                {
                    b.ClientSideEvents.Click = string.Format("function(s,e){{{0}}}", p.JSHandle);
                    return;
                }
                if (!string.IsNullOrEmpty(p.ConfirmText))
                {
                    if (p.CausesValidation)
                    {
                        b.ClientSideEvents.Click = string.Format(
                            "function(s,e){{if({0}()){{e.processOnServer=confirm('{1}');if(e.processOnServer)ISEx.loadingPanel.show({2});}}else{{e.processOnServer=false;alert('{3}');}}}}",
                            string.IsNullOrEmpty(p.ConfirmJSFunc) ? "ASPxClientEdit.AreEditorsValid" : p.ConfirmJSFunc,
                            HttpUtility.HtmlEncode(p.ConfirmText),
                            string.IsNullOrEmpty(p.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(p.LoadingText) + "'",
                            ValidationFailTips);
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(p.ConfirmJSFunc))
                        {
                            b.ClientSideEvents.Click = string.Format(
                                "function(s,e){{e.processOnServer=confirm('{0}');if(e.processOnServer)ISEx.loadingPanel.show({1});}}",
                                HttpUtility.HtmlEncode(p.ConfirmText),
                                string.IsNullOrEmpty(p.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(p.LoadingText) + "'");
                        }
                        else
                        {
                            b.ClientSideEvents.Click = string.Format(
                                "function(s,e){{if(!{0}())e.processOnServer=false;else{{e.processOnServer=confirm('{1}');if(e.processOnServer)ISEx.loadingPanel.show({2});}}}}",
                                p.ConfirmJSFunc, HttpUtility.HtmlEncode(p.ConfirmText),
                                string.IsNullOrEmpty(p.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(p.LoadingText) + "'");
                        }
                    }
                }
                else
                {
                    if (p.CausesValidation)
                    {
                        b.ClientSideEvents.Click = string.Format(
                            "function(s,e){{e.processOnServer={0}();if(e.processOnServer)ISEx.loadingPanel.show({1});else alert('{2}');}}",
                            string.IsNullOrEmpty(p.ConfirmJSFunc) ? "ASPxClientEdit.AreEditorsValid" : p.ConfirmJSFunc,
                            string.IsNullOrEmpty(p.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(p.LoadingText) + "'",
                            ValidationFailTips);
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(p.ConfirmJSFunc))
                        {
                            b.ClientSideEvents.Click = string.Format(
                                "function(s,e){{ISEx.loadingPanel.show({0});}}",
                                string.IsNullOrEmpty(p.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(p.LoadingText) + "'");
                        }
                        else
                        {
                            b.ClientSideEvents.Click = string.Format(
                                "function(s,e){{e.processOnServer={0}();if(e.processOnServer)ISEx.loadingPanel.show({1});}}",
                                p.ConfirmJSFunc,
                                string.IsNullOrEmpty(p.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(p.LoadingText) + "'");
                        }
                    }
                }
            };

            set(bCancel, _Buttons[BaseControl.EventTypes.Cancel]);
            set(bNo, _Buttons[BaseControl.EventTypes.No]);
            set(bSubmit, _Buttons[BaseControl.EventTypes.Submit]);
            set(bYes, _Buttons[BaseControl.EventTypes.Yes]);
            set(bOK, _Buttons[BaseControl.EventTypes.OK]);
            set(bSave, _Buttons[BaseControl.EventTypes.Save]);
            set(bNext, _Buttons[BaseControl.EventTypes.Next]);
            set(bPrevious, _Buttons[BaseControl.EventTypes.Previous]);
            set(bReload, _Buttons[BaseControl.EventTypes.Reload]);
            set(bPrint, _Buttons[BaseControl.EventTypes.Print]);
            set(bExport, _Buttons[BaseControl.EventTypes.Export]);

        }

        public virtual ActionToolbar Initialize(BaseControl control, Action<ActionToolbar.Configurator> config) { return this; }
        public virtual ActionToolbar Initialize(Action<ActionToolbar.Configurator> config, string validationGroup = null) { return this; }

    }

}
