using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

using LinqKit;
using DevExpress.Web;
using WebUI = System.Web.UI.WebControls;

using eTaxi.L2SQL;
namespace eTaxi.Web
{
    /// <summary>
    /// 实现各种动态添加的 ITemplate 标准接口
    /// </summary>
    public class TemplateItem
    {
        public abstract class BaseItem : Control, ITemplate
        {
            public string Id { get; set; }
            public abstract void InstantiateIn(Control container);
        }
        public class BaseItem<T> : BaseItem where T : Control
        {
            protected Action<T> _Handle = null;
            protected T _Control = null;
            protected string _ControlPath = string.Empty;
            public event Action<T> Instantiated;
            public T HostingControl { get { return _Control; } }
            public override void InstantiateIn(Control container)
            {
                T c = default(T);
                if (_ControlPath.Length == 0)
                {
                    c = Activator.CreateInstance<T>();
                }
                else
                {
                    c = (new UserControl()).LoadControl(_ControlPath) as T;
                }
                if (!
                    string.IsNullOrEmpty(Id))
                    typeof(T).GetProperty("ID").SetValue(c, Id, null);
                if (_Handle != null) _Handle(c);
                container.Controls.Add(c);
                _Control = c;
                if (Instantiated != null) Instantiated(c);
            }
            public BaseItem(Action<T> handle = null) { _Handle = handle; }
            public BaseItem(string controlPath, Action<T> handle = null) : this(handle) { _ControlPath = controlPath; }
        }

        /// <summary>
        /// 将控件外包一个控件后添加，例如控件 包一层 Panel
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <typeparam name="TContainer"></typeparam>
        public class EmbededItem<T, TContainer> : BaseItem<T>
            where T : Control
            where TContainer : Control
        {
            protected Unit _Width = Unit.Empty;
            protected Unit _Height = Unit.Empty;
            protected Type _ContainerType = null;
            protected new Action<T, TContainer> _Handle = null;
            protected Func<T, TContainer, Control> _Embed = null;
            public string ContainerId { get; set; }
            public override void InstantiateIn(Control container)
            {
                TContainer c = Activator.CreateInstance<TContainer>();
                if (!string.IsNullOrEmpty(ContainerId)) c.ID = ContainerId;
                if (_Embed == null) base.InstantiateIn(c); else base.InstantiateIn(_Embed(_Control, c));
                container.Controls.Add(c);
                if (_Handle != null) _Handle(_Control, c);
            }
            public EmbededItem(
                string controlPath, Action<T, TContainer> handle = null, Func<T, TContainer, Control> embed = null)
                : base(controlPath, null)
            {
                _Embed = embed;
                _Handle = handle;
                _ControlPath = controlPath;
            }
        }

        public class PlaceHolder : BaseItem<WebUI.PlaceHolder>
        {
            public PlaceHolder(Action<WebUI.PlaceHolder> handle = null) : base(handle) { }
        }
        public class Label : BaseItem<WebUI.Label>
        {
            public Label(Action<WebUI.Label> handle = null) : base(handle) { }
        }
        public class TextBox : BaseItem<WebUI.TextBox>
        {
            public TextBox(Action<WebUI.TextBox> handle = null) : base(handle) { }
        }
        public class CheckBox : BaseItem<WebUI.CheckBox>
        {
            public CheckBox(Action<WebUI.CheckBox> handle = null) : base(handle) { }
        }
        public class DropDownList : BaseItem<WebUI.DropDownList>
        {
            public DropDownList(Action<WebUI.DropDownList> handle = null) : base(handle) { }
        }
        public class Button : BaseItem<WebUI.Button>
        {
            public Button(Action<WebUI.Button> handle = null) : base(handle) { }
        }
        public class LinkButton : BaseItem<WebUI.LinkButton>
        {
            public LinkButton(Action<WebUI.LinkButton> handle = null) : base(handle) { }
        }
        public class Image : BaseItem<WebUI.Image>
        {
            public Image(Action<WebUI.Image> handle = null) : base(handle) { }
        }
        public class Literal : BaseItem<WebUI.Literal>
        {
            public Literal(Action<WebUI.Literal> handle = null) : base(handle) { }
        }
        public class Link : BaseItem<WebUI.HyperLink>
        {
            public Link(Action<WebUI.HyperLink> handle = null) : base(handle) { }
        }

        // DX

        public class DXLabel : BaseItem<ASPxLabel>
        {
            public DXLabel(Action<ASPxLabel> handle = null) : base(handle) { }
        }
        public class DXTextBox : BaseItem<ASPxTextBox>
        {
            public DXTextBox(Action<ASPxTextBox> handle = null) : base(handle) { }
        }
        public class DXSpinEdit : BaseItem<ASPxSpinEdit>
        {
            private bool _ShowButtons = false;
            public override void InstantiateIn(Control container)
            {
                base.InstantiateIn(container);
                if (!_ShowButtons)
                {
                    _Control.SpinButtons.ShowIncrementButtons = false;
                    _Control.SpinButtons.ShowLargeIncrementButtons = false;
                }
            }
            public DXSpinEdit(Action<ASPxSpinEdit> handle = null, bool showButtons = true) : base(handle) { _ShowButtons = showButtons; }
        }
        public class DXComboBox : BaseItem<ASPxComboBox>
        {
            public DXComboBox(Action<ASPxComboBox> handle = null) : base(handle) { }
        }
        public class DXDateEdit : BaseItem<ASPxDateEdit>
        {
            public DXDateEdit(Action<ASPxDateEdit> handle = null) : base(handle) { }
        }
        public class DXTimeEdit : BaseItem<ASPxTimeEdit>
        {
            public DXTimeEdit(Action<ASPxTimeEdit> handle = null) : base(handle) { }
        }
        public class DXButton : BaseItem<ASPxButton>
        {
            public DXButton(Action<ASPxButton> handle = null) : base(handle) { }
        }
        public class DXCheckBox : BaseItem<ASPxCheckBox>
        {
            public DXCheckBox(Action<ASPxCheckBox> handle = null) : base(handle) { }
        }

        // Form

        public class DropDownField : BaseItem<Controls.DropDownField_DX>
        {
            public override void InstantiateIn(Control container)
            {
                var c = (new UserControl()).LoadControl("~/controls.form/dropdownfield_dx.ascx") as
                    Controls.DropDownField_DX;
                if (!
                    string.IsNullOrEmpty(Id)) c.ID = Id;
                if (_Handle != null) _Handle(c);
                container.Controls.Add(c);
            }
            public DropDownField(Action<Controls.DropDownField_DX> handle = null) : base(handle) { }
        }
        public class PopupField : BaseItem<Controls.PopupField_DX>
        {
            public override void InstantiateIn(Control container)
            {
                var c = (new UserControl()).LoadControl("~/controls.form/popupfield_dx.ascx") as
                    Controls.PopupField_DX;
                if (!
                    string.IsNullOrEmpty(Id)) c.ID = Id;
                if (_Handle != null) _Handle(c);
                container.Controls.Add(c);
            }
            public PopupField(Action<Controls.PopupField_DX> handle = null) : base(handle) { }
        }
    }
}