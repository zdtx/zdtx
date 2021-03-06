using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.SessionState;
using System.Web.Security;
using System.Web.Profile;
using System.Resources;
using System.Threading;
using System.Globalization;
using Microsoft.Practices.Unity;

using Ext.Net;

using eTaxi.L2SQL;

using WebUI = System.Web.UI.WebControls;
using P = eTaxi.Parameters;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    /// <summary>
    /// 重构及重写（2013）
    /// </summary>
    public class BaseControl : System.Web.UI.UserControl
    {
        /// <summary>
        /// 对通用外发的事件进行粗分类
        /// </summary>
        public enum EventTypes
        {
            Submit,
            Save,
            OK,
            Yes,
            No,
            Cancel,
            Reload,
            Next,
            Previous,
            FlowBizModified,
            Print,
            Export,
            Other
        }

        protected TypedHashtable _Data = new TypedHashtable(); // 数据存储包
        protected UserProfilesRelatedUtil _Util = null;
        protected StateBagWrapper _ViewStateEx = null;
        protected bool _IsPartial = false;

        protected static T _DTContext<T>(
            bool readOnly = false) where T : CommonContext { return Util.DTContext<T>(readOnly); }
        private IPageEx __Page = null;
        protected IPageEx _Page()
        {
            if (__Page != null) return __Page; 
            __Page = Page as IPageEx;
            return __Page;
        }

        /// <summary>
        /// ViewStateEx 公共接口
        /// </summary>
        public StateBagWrapper ViewStateEx { get { return _ViewStateEx; } }

        /// <summary>
        /// MasterLoader 实例
        /// </summary>
        public Controls.ControlLoader MasterLoader { get; set; }

        /// <summary>
        /// 控件内部的主要业务数据存储
        /// </summary>
        public TypedHashtable Data { get { return _Data; } }

        /// <summary>
        /// 模块命名
        /// </summary>
        public virtual string ModuleId { get { return string.Empty; } }

        private string _AccessCode = string.Empty;
        /// <summary>
        /// 模块命名
        /// </summary>
        public string AccessCode
        {
            get
            {
                if (!string.IsNullOrEmpty(_AccessCode)) return _AccessCode;
                if (!Global.Cache.AccessIds.ContainsKey(AppRelativeVirtualPath.ToLower())) return _AccessCode; 
                _AccessCode = Global.Cache.AccessIds[AppRelativeVirtualPath.ToLower()].ToISFormatted();
                return _AccessCode;
            }
        }

        /// <summary>
        /// 是否需要对模块的入口进行控制和资源分配
        /// </summary>
        public virtual bool AccessControlled { get { return false; } }

        /// <summary>
        /// 对外的通用事件发送信道
        /// </summary>
        public event Action<BaseControl, EventTypes, string> EventSinked = null;
        public virtual void SinkEvent(EventTypes eType, string param = null) { SinkEvent(this, eType, param); }
        public void SinkEvent(BaseControl sender, EventTypes eType, string param = null) { if (EventSinked != null) EventSinked(sender, eType, param); }

        #region IPageEx

        protected DateTime _CurrentTime { get { return _Page().CurrentTime; } }
        protected HttpSessionStateWrapper _SessionEx { get { return _Page().SessionEx; } }
        protected IDataConnectionManager _DataConnectionManager { get { return _Page().DataConnectionManager; } }
        protected CommonService _DTService { get { return _Page().DTService; } }
        protected MembershipProvider _MembershipProvider { get { return _Page().MembershipProvider; } }
        protected RoleProvider _RoleProvider { get { return _Page().RoleProvider; } }
        protected ProfileProvider _ProfileProvider { get { return _Page().ProfileProvider; } }
        protected void _Logout() { _Page().Logout(); }
        protected string _GetSitePrefix() { return _Page().GetSitePrefix(); }
        protected virtual void _ExportToExcel<T>(string section, List<T> data, string[] headers) { _Page().ExportToExcel<T>(section, data, headers); }
        protected virtual void _ExportToExcel<T, TSource>(string section, List<TSource> data, string[] headers, Func<TSource, T> itemGet) { _Page().ExportToExcel<T, TSource>(section, data, headers, itemGet); }
        protected bool _TransCall(
            Action handle, Action<Exception> exceptionHandle = null, bool requireTransaction = true)
        {
            return _Page().TransCall(handle, exceptionHandle, requireTransaction);
        }
        public void HandleException(Exception ex, Action<string> msgSend = null) { _Page().HandleException(ex, msgSend); }
        public bool HandleException(Type callerType, ExceptionFilter exFilter, string step) { return _Page().HandleException(callerType, exFilter, step); }
        public bool AC(string code) { return _Page().AC(code); }
        public virtual void Alert(string message, string postScript = null, bool executeBeforeAlert = false)
        {
            if (MasterLoader != null) { MasterLoader.Alert(message, postScript, executeBeforeAlert); return; }
            _Page().Alert(this, message, postScript, executeBeforeAlert);
        }
        protected virtual void Alert<T>(T caller, string message, string postScript = null, bool executeBeforeAlert = false) where T : Control
        {
            if (MasterLoader != null) { MasterLoader.Alert(caller, message, postScript, executeBeforeAlert); return; }
            _Page().Alert<T>(caller, message, postScript, executeBeforeAlert);
        }
        public virtual void JS(string snippet)
        {
            if (MasterLoader != null) { MasterLoader.JS(snippet); return; }
            _Page().JS(this, snippet);
        }
        protected virtual void JS<T>(T caller, string snippet) where T : Control
        {
            if (MasterLoader != null) { MasterLoader.JS<T>(caller, snippet); return; }
            _Page().JS<T>(caller, snippet);
        }

        #endregion

        public BaseControl()
            : base()
        {
            _ViewStateEx = new StateBagWrapper(ViewState);
        }

        protected override void OnInit(EventArgs e)
        {
            _Util = new UserProfilesRelatedUtil(_SessionEx);
            base.OnInit(e);
            try
            {
                ScriptManager sm = System.Web.UI.ScriptManager.GetCurrent(Page);
                _IsPartial = X.IsAjaxRequest || (sm != null && sm.IsInAsyncPostBack);
                _SetInitialStates(_IsPartial);
            }
            catch (Exception ex)
            {
                if (_HandleException(new ExceptionFilter(ex), BasePage.Steps.Init)) return;
                throw ex;
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            try
            {
                _ViewStateProcess(); // 处理视图状态（不管是否第一次加载）
            }
            catch (Exception ex)
            {
                if (_HandleException(new ExceptionFilter(ex), BasePage.Steps.Load)) return;
                throw ex;
            }
        }

        /// <summary>
        /// Do 之前的校验方法，例如 校验 ，因为：
        /// 控件很大程度受控于外部 Loader 的调用，PreDo 返回控件状态是否满足下一步操作的校验条件
        /// </summary>
        /// <param name="section">可以与 _Do 的 section 对应</param>
        /// <returns></returns>
        public virtual bool PreDo(string section, Action<DTException> exceptionHandle = null) { return true; }

        /// <summary>
        /// Do 和 _Do
        /// 处理 Postback 的方法调用，作为系统时间处理的唯一入口
        /// </summary>
        protected virtual void _Do(string section, string subSection = null) { throw new NotImplementedException("未定义，请先重载 _Do"); }

        /// <summary>
        /// 内部方法调用（总入口）
        /// </summary>
        /// <param name="section"></param>
        /// <param name="requireTransaction"></param>
        /// <param name="inAnotherDo">是否在另一个 _Do 范围内</param>
        /// <returns></returns>
        public bool Do(string section, bool requireTransaction, bool inAnotherDo = false) { return Do(section, null, requireTransaction, inAnotherDo); }
        public bool Do(string section, string subSection, bool requireTransaction, bool inAnotherDo = false)
        {
            if (inAnotherDo)
            {
                _Do(section, subSection);
                return true;
            }

            return Util.TransCall(() => 
                _Do(section, subSection), ex => { throw ex; }, requireTransaction);
        }

        /// <summary>
        /// 执行视图状态的计算
        /// </summary>
        protected virtual void _ViewStateProcess() { }

        /// <summary>
        /// 进行初始化
        /// </summary>
        protected virtual void _SetInitialStates() { }
        // 优化方案：protected virtual void _SetInitialStates(bool isPartial) { if (!isPartial) _SetInitialStates(); }
        protected virtual void _SetInitialStates(bool isPartial) { _SetInitialStates(); }
        /// <summary>
        /// 访问并且准备好数据
        /// </summary>
        protected virtual void _PrepareData() { Util.ForFields<D.DataSections>(s => _PrepareData(s)); }
        protected void _PrepareData(string[] sections) { foreach (string s in sections) _PrepareData(s); }
        protected virtual void _PrepareData(string section) { }

        /// <summary>
        /// 将数据绑定到控件
        /// </summary>
        protected virtual void _BindData() { Util.ForFields<D.VisualSections>(s => _BindData(s)); }
        protected virtual void _BindData(string section) { }

        /// <summary>
        /// 一次完整的“处理 + 绑定”
        /// </summary>
        protected virtual void _Execute()
        {
            _PrepareData();
            _BindData();
        }
        protected virtual void _Execute(string section) { }
        public void Execute()
        {
            try
            {
                _Execute(); // return true;
            }
            catch (Exception ex)
            {
                //if (_HandleException(new ExceptionFilter(ex), BasePage.Steps.Execute)) return false;
                throw ex;
            }
        }
        public void Execute(string section)
        {
            try
            {
                _Execute(section); // return true;
            }
            catch (Exception ex)
            {
                //if (_HandleException(new ExceptionFilter(ex), BasePage.Steps.Execute)) return false;
                throw ex;
            }
        }

        /// <summary>
        /// 处理异常，为以下顺序
        /// 1. 如果为 false，则表明没处理，让 BasePage_Error 处理
        /// 2. 如果重载为 true，则由页面处理
        /// </summary>
        /// <param name="ex">异常</param>
        /// <param name="step">哪个环节出现的</param>
        /// <param name="id">额外的 id 信息</param>
        /// <returns></returns>
        protected virtual bool _HandleException(ExceptionFilter exFilter, string step, Action<string> msgSend = null)
        {
            return _Page().HandleException(GetType(), exFilter, step, msgSend);
        }

        /// <summary>
        /// 将整个控件进行“不可用的”盖棺
        /// </summary>
        /// <param name="message"></param>
        public virtual void CompleteMask(string message = null)
        {
            ViewStateEx.Clear();
            
            //Controls.Clear();
            //WebUI.Panel p = new WebUI.Panel()
            //{
            //    CssClass = "error",
            //};
            //p.Style.Add("padding", "10px;");
            //p.Controls.Add(new Literal() { Text = message });
            //Controls.Add(p);

            JS(string.Format(
                "ISEx.loadingPanel.show('发生错误，页面失效：{0}');", HttpUtility.JavaScriptStringEncode(message)));
        }

        #region 通用数据导出接口

        /// <summary>
        /// 导出 ViewStateEx 数据
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="emptyValue"></param>
        /// <returns></returns>
        public virtual T Export<T>(string key = null, T emptyValue = default(T)) { return _ViewStateEx.Get<T>(key, emptyValue); }

        /// <summary>
        /// 由别的 控件 输入指定类型或者 key 的 ViewState 值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="c"></param>
        /// <param name="key"></param>
        public virtual BaseControl Import<T>(BaseControl c, string key = null)
        {
            ViewStateEx.Set<T>(c.ViewStateEx.Get<T>(key: key), key: key);
            return this;
        }

        /// <summary>
        /// Shortcut 功能
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <param name="key"></param>
        public virtual BaseControl Import<T>(T value, string key = null)
        {
            ViewStateEx.Set<T>(value, key);
            return this;
        }

        #endregion

    }
}