using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using DevExpress.Utils;

using LinqKit;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    /// <summary>
    /// 母板页面基类
    /// </summary>
    public abstract class MasterPageEx : MasterPage
    {
        /// <summary>
        /// 分区设定
        /// </summary>
        public enum Zone
        {
            East, South, West, North, Center, CenterTop
        }

        /// <summary>
        /// 区间配置对象
        /// </summary>
        public class Config
        {
            public string CssClass = null;
            public bool AutoHeight = false;
            public bool AutoWidth = false;
            public DefaultBoolean AllowResize = DefaultBoolean.Default;
            public bool Visible = false;
            public Unit Size = Unit.Empty;
            public Unit MaxSize = Unit.Empty;
            public Unit MinSize = Unit.Empty;
            public Nullable<ScrollBars> ScrollBars = null;
            public BorderStyle BorderStyle = BorderStyle.NotSet;
        }
        public class ZoneSetter
        {
            private Dictionary<Zone, Config> _Configs = new Dictionary<Zone, Config>();
            public Dictionary<Zone, Config> Configs { get { return _Configs; } }

            private void _Set(Zone zone, bool visible, Action<Config> config = null)
            {
                var c = _Configs[zone];
                c.Visible = visible;
                if (config != null) config(c);
            }

            public ZoneSetter North(bool visible, Action<Config> config = null)
            {
                _Set(Zone.North, visible, config);
                return this;
            }

            public ZoneSetter South(bool visible, Action<Config> config = null)
            {
                _Set(Zone.South, visible, config);
                return this;
            }

            public ZoneSetter East(bool visible, Action<Config> config = null)
            {
                _Set(Zone.East, visible, config);
                return this;
            }

            public ZoneSetter West(bool visible, Action<Config> config = null)
            {
                _Set(Zone.West, visible, config);
                return this;
            }

            public ZoneSetter Center(bool visible, Action<Config> config = null)
            {
                _Set(Zone.Center, visible, config);
                return this;
            }

            public ZoneSetter CenterTop(bool visible, Action<Config> config = null)
            {
                _Set(Zone.CenterTop, visible, config);
                return this;
            }

            public ZoneSetter()
            {
                _Configs.Add(Zone.East, new Config());
                _Configs.Add(Zone.West, new Config());
                _Configs.Add(Zone.North, new Config() { AutoHeight = true });
                _Configs.Add(Zone.South, new Config() { AutoHeight = true });
                _Configs.Add(Zone.Center, new Config() { Visible = true });
                _Configs.Add(Zone.CenterTop, new Config());
            }
        }

        public abstract HtmlForm Form { get; }
        public virtual void RegisterScriptManager(ScriptManager manager)
        {
            manager.ID = "theManager";
            Form.Controls.AddAt(0, manager);
        }

        protected ZoneSetter _Setter = new ZoneSetter();
        protected virtual void _ConfigZone() { }
        public virtual void ConfigZone(Action<ZoneSetter> set) { set(_Setter); _ConfigZone(); }

        /// <summary>
        /// 设置本页 Ajax 调用的超时时间（需额外配合检查 web.config iis 等）
        /// </summary>
        /// <param name="second">秒</param>
        public virtual void SetAjaxTimeout(int second)
        {
            ScriptManager.GetCurrent(Page).AsyncPostBackTimeout = second;
        }

        /// <summary>
        /// 获取当前页面的回调句柄
        /// </summary>
        /// <returns></returns>
        public virtual string GetCBHandle(bool closeByOpener = true, string script = null)
        {
            string handle = Request[D.NamedSection.CallbackQuery];
            if (string.IsNullOrEmpty(handle)) return string.Empty;
            string statement = string.Empty;
            if (closeByOpener) statement += "if(b)window.close();";
            if (!
                string.IsNullOrEmpty(script))
                statement += script;
            return string.Format(
                "ISEx.callerEx(function(b,x){{{0}}});",
                "x.handles." + handle + "();" + statement);
        }

        /// <summary>
        /// 去除注册的带 ClientID 键的脚本
        /// </summary>
        public virtual void RemoveScriptRegistration() { }

        /// <summary>
        /// 临时设置默认的加载提示
        /// </summary>
        /// <param name="text"></param>
        public virtual void SetLoadingText(string text) { }

        /// <summary>
        /// 回设默认的加载提示
        /// </summary>
        public virtual void ResetLoadingText() { }

        /// <summary>
        /// 是否具备反调的页面打开
        /// </summary>
        /// <returns></returns>
        public virtual bool HasCBHandle()
        {
            string handle = Request[D.NamedSection.CallbackQuery];
            return !string.IsNullOrEmpty(handle);
        }

        /// <summary>
        /// 页面初始化行为
        /// </summary>
        /// <param name="e"></param>
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (string.IsNullOrEmpty(Page.Theme)) return;
            
            var styles = new HtmlLink[]
            {
                new HtmlLink(){ Href = string.Format("../content/themes/{0}/form.css", Page.Theme.ToLower())}
            };

            styles.ForEach(s =>
            {
                s.Attributes.Add("rel", "stylesheet");
                s.Attributes.Add("type", "text/css");
                Page.Header.Controls.AddAt(3, s);
            });

        }

        #region PATCH AREA

        public virtual bool _PACK_0001() { return false; }

        #endregion

    }
}