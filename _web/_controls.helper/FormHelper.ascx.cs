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
    /// <summary>
    /// 形成设定区域各个填报控件的唯一验证规则设定入口
    /// </summary>
    public partial class FormHelper : BaseControl
    {
        /// <summary>
        /// 验证器
        /// </summary>
        public class Validator<T> where T : Control
        {
            private T _Control = null;
            private FormHelper _Helper = null;
            public Validator<T> IsRequired(string errorText = "值不能为空")
            {
                _Control.If<ASPxEdit>(c =>
                {
                    c.ValidationSettings.ValidationGroup = _Helper.CurrentGroup;
                    c.ValidationSettings.ErrorFrameStyle.Paddings.Padding = 0;
                    c.ValidationSettings.ErrorFrameStyle.Border.BorderStyle= BorderStyle.None;
                    c.ValidationSettings.ErrorFrameStyle.BorderBottom.BorderColor = System.Drawing.Color.Red;
                    c.ValidationSettings.ErrorFrameStyle.BorderBottom.BorderStyle = BorderStyle.Solid;
                    c.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.None;
                    c.ValidationSettings.RequiredField.IsRequired = true;
                    c.ValidationSettings.RequiredField.ErrorText = errorText;
                    c.ValidationSettings.SetFocusOnError = true;
                });
                _Control.If<DropDownField_DX>(c =>
                {
                    c.BE.ValidationSettings.ValidationGroup = _Helper.CurrentGroup;
                    c.BE.ValidationSettings.ErrorFrameStyle.Paddings.Padding = 0;
                    c.BE.ValidationSettings.ErrorFrameStyle.Border.BorderStyle = BorderStyle.None;
                    c.BE.ValidationSettings.ErrorFrameStyle.BorderBottom.BorderColor = System.Drawing.Color.Red;
                    c.BE.ValidationSettings.ErrorFrameStyle.BorderBottom.BorderStyle = BorderStyle.Solid;
                    c.BE.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.None;
                    c.BE.ValidationSettings.RequiredField.IsRequired = true;
                    c.BE.ValidationSettings.RequiredField.ErrorText = errorText;
                    c.BE.ValidationSettings.SetFocusOnError = true;
                });
                _Control.If<PopupField_DX>(c =>
                {
                    c.BE.ValidationSettings.ValidationGroup = _Helper.CurrentGroup;
                    c.BE.ValidationSettings.ErrorFrameStyle.Paddings.Padding = 0;
                    c.BE.ValidationSettings.ErrorFrameStyle.Border.BorderStyle = BorderStyle.None;
                    c.BE.ValidationSettings.ErrorFrameStyle.BorderBottom.BorderColor = System.Drawing.Color.Red;
                    c.BE.ValidationSettings.ErrorFrameStyle.BorderBottom.BorderStyle = BorderStyle.Solid;
                    c.BE.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.None;
                    c.BE.ValidationSettings.RequiredField.IsRequired = true;
                    c.BE.ValidationSettings.RequiredField.ErrorText = errorText;
                    c.BE.ValidationSettings.SetFocusOnError = true;
                });
                return this;
            }
            public Validator(FormHelper helper, T control)
            {
                _Helper = helper;
                _Control = control;
            }
        }

        /// <summary>
        /// 修饰器
        /// </summary>
        public class Decorator<T> where T : Control
        {
            private T _Control = null;
            private FormHelper _Helper = null;
            public Decorator<T> NullText(string nullText = "请填写")
            {
                _Control.If<ASPxTextBox>(c =>
                {
                    c.NullText = nullText;
                });
                _Control.If<DropDownField_DX>(c =>
                {
                    c.BE.NullText = nullText;
                });

                return this;
            }
            public Decorator(FormHelper helper, T control)
            {
                _Helper = helper;
                _Control = control;
            }
        }

        public Validator<T> Validate<T>(T control) where T : Control { return new Validator<T>(this, control); }
        public Decorator<T> Decorate<T>(T control) where T : Control { return new Decorator<T>(this, control); }

        public string CurrentGroup { get; set; }
        public FormHelper Group(string group) { CurrentGroup = group; return this; }

    }
}