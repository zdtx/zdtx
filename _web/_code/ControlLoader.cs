using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using D = eTaxi.Definitions;
namespace eTaxi.Web.Controls
{
    public abstract partial class ControlLoader : BaseControl
    {
        /// <summary>
        /// 流畅配置器（配置 buttons）
        /// </summary>
        public class Configurator<T> where T : BaseControl
        {
            /// <summary>
            /// 按钮参数缓存
            /// </summary>
            public Dictionary<BaseControl.EventTypes, Button> Buttons { get { return _Buttons; } }
            private Dictionary<BaseControl.EventTypes, Button> _Buttons = new Dictionary<BaseControl.EventTypes, Button>();
            private bool _FooterLoaded = false;
            public bool FooterLoaded { get { return _FooterLoaded; } }
            private ControlLoader _Loader = null;
            private T _Control = null;
            public Configurator<T> Title(string title) { _Loader.Title = title; return this; }
            public Configurator<T> Width(Unit width) { _Loader.Width = width; return this; }
            public Configurator<T> Height(Unit height) { _Loader.Height = height; return this; }
            public Configurator(T control, ControlLoader loader)
            {
                _Loader = loader;
                _Control = control;
            }

            /// <summary>
            /// 配置页脚按钮
            /// </summary>
            /// <param name="eventType"></param>
            /// <param name="set"></param>
            /// <returns></returns>
            public Configurator<T> Button(BaseControl.EventTypes eventType, Action<Button> set = null)
            {
                if (!
                    _Buttons.ContainsKey(eventType))
                    _Buttons.Add(eventType, new Button());
                var button = _Buttons[eventType];
                button.Visible = true;
                if (set != null) set(button);
                return this;
            }

            /// <summary>
            /// 加入新的页脚
            /// </summary>
            /// <typeparam name="TFooter"></typeparam>
            /// <param name="path"></param>
            /// <param name="footer"></param>
            public void NewFooter<TFooter>(
                string path, Action<T, TFooter> execute = null) where TFooter : Loader.Footer
            {
                _FooterLoaded = true;
                _Loader.LoadFooter<TFooter>(path, f =>
                {
                    if (execute != null) execute(_Control, f);
                });
            }

        }

        /// <summary>
        /// 按键配置文件类
        /// </summary>
        [Serializable]
        public class Button
        {
            public bool Visible { get; set; }
            public string Text { get; set; }
            public bool CausesValidation { get; set; }
            public string ImageFile { get; set; }
            public string ConfirmText { get; set; }
            public string LoadingText { get; set; }

            /// <summary>
            /// 系统自动加入“()”并形成 if ({0}()) 的语句体，你可以：
            /// ConfirmJSFunc = "MyFunc" 又或者 ConfirmJSFunc = "new function(){ a; b; }" 
            /// </summary>
            public string ConfirmJSFunc { get; set; }

            /// <summary>
            /// 仅仅执行 JS 脚本
            /// </summary>
            public string JSHandle { get; set; }
        }

        public abstract string Title { set; }
        public abstract string Tips { set; }
        public abstract Unit Height { set; }
        public abstract Unit Width { set; }

        /// <summary>
        /// 对首项 KB0001 的相关补丁
        /// </summary>
        public virtual void PACK_0001() { }
        
        private object _Configurator = null;
        public void ForConfigurator<T>(Action<Configurator<T>> handle,
            Action nullHandle = null, Configurator<T> newObject = null) where T : BaseControl
        {
            if (newObject != null)
            {
                _Configurator = newObject;
                handle(newObject);
                return;
            }

            if (_Configurator == null ||
                !(_Configurator is Configurator<T>))
            {
                if (nullHandle != null) nullHandle();
                return;
            }

            handle(_Configurator.As<Configurator<T>>());
        }

        /// <summary>
        /// 事件频道（用于鉴别回调的事件发出对象）
        /// </summary>
        public string EventChannel
        {
            get { return _ViewStateEx.Get<string>("eventChannel", string.Empty); }
            set { _ViewStateEx.Set<string>(value, "eventChannel"); }
        }

        /// <summary>
        /// 上一次加载的控件（校验）
        /// </summary>
        public string LastContentPath
        {
            get { return _ViewStateEx.Get<string>("lastContentPath", string.Empty); }
            set { _ViewStateEx.Set<string>(value, "lastContentPath"); }
        }

        /// <summary>
        /// 上一次加载的页脚（校验）
        /// </summary>
        public string LastFooterPath
        {
            get { return _ViewStateEx.Get<string>("lastFooterPath", string.Empty); }
            set { _ViewStateEx.Set<string>(value, "lastFooterPath"); }
        }

        /// <summary>
        /// 执行内嵌控件的验证工作
        /// </summary>
        /// <param name="caller"></param>
        public virtual bool Validate(BaseControl caller) { return true; }
        /// <summary>
        /// 设置页脚，并且需要调整到初始的状态
        /// </summary>
        /// <typeparam name="TFooter">页脚的类型</typeparam>
        /// <param name="path">控件路径</param>
        /// <param name="execute">执行句柄（注意：一定要在 load 之后，而不是 initialize 的时候）</param>
        public virtual void LoadFooter<TFooter>(
            string path = null, Action<TFooter> execute = null) where TFooter : Loader.Footer { }

        /// <summary>
        /// 通用行为1：展示控件
        /// </summary>
        public abstract void Show();
        /// <summary>
        /// 通用行为2：控件要求关闭，或者说外部要求关闭
        /// </summary>
        public abstract void Close(string message = null);

        /// <summary>
        /// 控件的注入点
        /// </summary>
        public abstract PlaceHolder Holder { get; }
        /// <summary>
        /// 外框所在控件（也许是 popup 也许是 其他 panel）
        /// </summary>
        public abstract Control Frame { get; }

        private BaseControl _HostingControl = null;
        /// <summary>
        /// 当前放置的控件实例
        /// </summary>
        public BaseControl HostingControl { get { return _HostingControl; } }

        private Loader.Footer _FooterControl = null;
        /// <summary>
        /// 防止页脚控件实例
        /// </summary>
        public Loader.Footer FooterControl
        {
            get { return _FooterControl; }
            set { _FooterControl = value; }
        }

        /// <summary>
        /// 获取 Session 值的算法
        /// </summary>
        public string Key
        {
            get
            {
                return
                    D.Session.Keys.Loader +
                    Page.AppRelativeVirtualPath.ToLower()
                        .Replace("~", string.Empty).Replace("aspx", string.Empty).Replace('/', '.') + ClientID;
            }
        }

        /// <summary>
        /// 放置页面对象的Id取值
        /// </summary>
        public string Key_CurrentId { get { return Key + ".id"; } }

        /// <summary>
        /// 页脚对应的控件路径
        /// </summary>
        public string Key_Footer { get { return Key + ".footer"; } }

        /// <summary>
        /// 加载主控件，并利用 session 进行控件的周期存续
        /// </summary>
        /// <param name="controlPath"></param>
        protected T _LoadContent<T>(string controlPath,
            Action<T> beforeLoad = null, Action<T> afterLoad = null, bool alwaysReload = true) where T : BaseControl
        {
            // 切换一下 ID
            string id = _SessionEx.Get<string>(Key_CurrentId, "y");
            id = (id == "x") ? "y" : "x";
            _SessionEx.Set<string>(id, Key_CurrentId);

            T c = default(T);
            if (_HostingControl == null ||
                !(_HostingControl is T) || alwaysReload)
            {
                c = LoadControl(controlPath) as T;
                if (c == null) throw new
                    ArgumentException(controlPath + " 不是要求的类型： '" + typeof(T).Name + "'");

                c.ID = id;
                c.MasterLoader = this;
                Holder.Controls.Clear();
                if (beforeLoad != null) beforeLoad(c);
                Holder.Controls.Add(c);

                LastContentPath = controlPath.ToLower();
                _SessionEx.Set<string>(LastContentPath, Key);

            }
            else
            {
                c = _HostingControl as T;
            }

            if (afterLoad != null) afterLoad(c); else c.Execute();
            _HostingControl = c;
            _HostingControl.EventSinked += (s, eT, e) => { SinkEvent(s, eT, e); };
            return c;
        }

        /// <summary>
        /// 控件准备（Begin为统一的入口方法，带三个基本参数）
        /// </summary>
        /// <param name="path"></param>
        /// <param name="beforeLoad"></param>
        /// <param name="afterLoad"></param>
        public virtual void Begin(string path,
            Action<BaseControl> beforeLoad = null, Action<BaseControl> afterLoad = null, Action<Configurator<BaseControl>> config = null,
            bool alwaysReload = true)
        {
            Begin<BaseControl>(path, beforeLoad, afterLoad, config, alwaysReload);
        }
        public virtual void Begin<T>(string path,
            Action<T> beforeLoad = null, Action<T> afterLoad = null, Action<Configurator<T>> config = null,
            bool alwaysReload = true) where T : BaseControl
        {
            T control = default(T);
            bool contentLoaded = true;

            try
            {
                _ResetContent();
                control = _LoadContent<T>(path, beforeLoad, afterLoad, alwaysReload);
            }
            catch (Exception ex)
            {
                _ResetContent();
                HandleException(ex, msg => Tips = msg);
                contentLoaded = false;
            }

            try
            {
                _ResetFooter();

                // 打开配置项，允许写入配置
                if (contentLoaded && config != null)
                    ForConfigurator<T>(config, null, new Configurator<T>(control, this));

                // 重新读取配置，并决定执行方案
                ForConfigurator<T>(c =>
                {
                    if (c.FooterLoaded) return; // 已经在 configurator 中加载页脚
                    LoadFooter<Loader.Footer>(execute: f =>
                    {
                        f.SpecifyButtonSetting(c.Buttons);
                        f.Execute();
                    });

                }, () =>
                {
                    LoadFooter<Loader.Footer>(execute: f => f.Execute());
                });

            }
            catch (Exception ex)
            {
                _ResetFooter();
                HandleException(ex, msg => Tips = msg);
                throw ex;
            }

            Show();
        }

        /// <summary>
        /// 为了保持控件的互操作性进行的 Session 值缓存
        /// </summary>
        protected override void _SetInitialStates()
        {
            // 1. 初始化控件区
            _InitializeContent();

            // 2. 初始化页脚区
            _InitializeFooter();
        }

        /// <summary>
        /// 初始化主控件区
        /// </summary>
        protected virtual void _InitializeContent()
        {
            string id = _SessionEx.Get<string>(Key_CurrentId, "x");
            string content = _SessionEx.Get<string>(Key, string.Empty);
            if (content.Length > 0)
            {
                var c = LoadControl(content) as BaseControl;
                c.ID = id;
                c.MasterLoader = this;
                c.EventSinked += (s, eT, e) => { SinkEvent(s, eT, e); };
                Holder.Controls.Add(c);
                _HostingControl = c;
            }
        }

        /// <summary>
        /// 初始化页脚（有的 loader 有，有的没有，按需要重载）
        /// </summary>
        protected virtual void _InitializeFooter() { }

        /// <summary>
        /// 初始化到最初的状态
        /// </summary>
        protected override void _Execute()
        {
            _ResetContent();
            _ResetFooter();
        }

        /// <summary>
        /// 将内嵌控件容器重置到默认状态
        /// </summary>
        protected void _ResetContent()
        {
            // 会话状态
            Session.Remove(Key);
            Session.Remove(Key_CurrentId);

            // 去除控件内容
            Holder.Controls.Clear();
            Width = 400;
            Height = 300;

            // 将 viewstate 内容回复到默认状态
            LastContentPath = string.Empty;
            Tips = string.Empty;
        }

        /// <summary>
        /// 将页脚进行重置
        /// </summary>
        protected void _ResetFooter()
        {
            // 会话状态
            Session.Remove(Key_Footer);

            // 去除所有的按键配置项信息
            _Configurator = null;

            // 新加载默认的页脚
            LoadFooter<eTaxi.Web.Controls.Loader.Footer>();

            // 将 viewstate 内容回复到默认状态
            LastFooterPath = string.Empty;
        }

    }
}