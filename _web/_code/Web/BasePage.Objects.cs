using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Reflection;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.SessionState;
using System.Web.Security;
using System.Web.Profile;
using System.Resources;
using System.Security.Principal;
using System.Threading;
using System.IO;
using System.IO.Compression;
using System.Globalization;
using Microsoft.Practices.Unity;

using Ext.Net;
using eTaxi.L2SQL;

using WebUI = System.Web.UI.WebControls;
using P = eTaxi.Parameters;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    public abstract partial class BasePage : System.Web.UI.Page, IPageEx
    {
        /// <summary>
        /// 标注当前事件位置
        /// </summary>
        public class Steps
        {
            public const string PreInit = "PreInit";
            public const string Init = "Init";
            public const string Load = "Load";
            public const string Do = "Do";
            public const string Execute = "Execute";
            public const string Unknown = "Unknown";
        }

        /// <summary>
        /// 私用脚本类
        /// </summary>
        public class JS
        {
            private BasePage _Page = null;
            public JS(BasePage page) { _Page = page; }

            private Control _Control = null;
            public JS At(Control c) { _Control = c; return this; }

            /// <summary>
            /// 弹出消息
            /// </summary>
            /// <param name="message"></param>
            /// <param name="postScript">后续脚本</param>
            public void Alert(
                string message, string postScript = null, bool executeBeforeAlert = false)
            {
                string pattern = "alert('{0}');{1}";
                if (executeBeforeAlert) pattern = "{1}alert('{0}');";
                string script =
                    string.Format(pattern, HttpUtility.JavaScriptStringEncode(message), postScript ?? string.Empty);
                if (_Control != null)
                {
                    ScriptManager.RegisterStartupScript(
                        _Control, _Control.GetType(), Guid.NewGuid().ToISFormatted(), script, true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(
                        _Page, _Page.GetType(), Guid.NewGuid().ToISFormatted(), script, true);
                }
            }

            /// <summary>
            /// 弹出消息（控件）
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="caller"></param>
            /// <param name="message"></param>
            /// <param name="postScript">后续脚本</param>
            public void Alert<T>(T caller,
                string message, string postScript = null, bool executeBeforeAlert = false) where T : Control
            {
                ScriptManager sm = System.Web.UI.ScriptManager.GetCurrent(_Page);
                if (sm.IsInAsyncPostBack)
                {
                    string pattern = "alert('{0}');{1}";
                    if (executeBeforeAlert) pattern = "{1}alert('{0}');";
                    ScriptManager.RegisterStartupScript(
                        caller, typeof(T), Guid.NewGuid().ToISFormatted(),
                        string.Format(pattern, HttpUtility.JavaScriptStringEncode(message), postScript ?? string.Empty), true);
                }
                else
                {
                    Alert(message, postScript, executeBeforeAlert);
                }
            }

            /// <summary>
            /// 注入脚本
            /// </summary>
            /// <param name="snippet"></param>
            public void Write(string snippet)
            {
                if (_Control != null)
                {
                    ScriptManager.RegisterStartupScript(
                        _Control, _Control.GetType(), Guid.NewGuid().ToISFormatted(), string.Format("{0}", snippet), true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(
                        _Page, _Page.GetType(), Guid.NewGuid().ToISFormatted(), string.Format("{0}", snippet), true);
                }
            }

            /// <summary>
            /// 注入脚本（控件）
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="snippet"></param>
            public void Write<T>(T caller, string snippet) where T : Control
            {
                ScriptManager sm = System.Web.UI.ScriptManager.GetCurrent(_Page);
                if (sm.IsInAsyncPostBack)
                {
                    ScriptManager.RegisterStartupScript(caller, typeof(T),
                        Guid.NewGuid().ToISFormatted(), string.Format("{0}", snippet), true);
                }
                else
                {
                    Write(snippet);
                }
            }
        }

        /// <summary>
        /// 私用 Cookie 管理类
        /// </summary>
        public class CK
        {
            private BasePage _Page = null;
            public CK(BasePage page) { _Page = page; }

            /// <summary>
            /// 清空cookie
            /// </summary>
            public void Clear()
            {
                _Page.Response.AppendCookie(new HttpCookie("eTaxi")
                    {
                        Expires = new System.DateTime(2000, 01, 01) // 设为历史时间
                    });
            }

            /// <summary>
            /// 设置 Cookie（放入保存项）
            /// </summary>
            public void Put(Action<HttpCookie> handle)
            {
                var cookie = new HttpCookie("eTaxi")
                    {
                        Expires = _Page._CurrentTime.AddMonths(3)
                    };
                handle(cookie);
                _Page.Response.AppendCookie(cookie);
            }

            /// <summary>
            /// 检查当前的Cookie设置
            /// </summary>
            public void Get(Action<HttpCookie> handle)
            {
                var cookie = _Page.Request.Cookies["eTaxi"];
                if (cookie != null) handle(cookie);
            }
        }

        /// <summary>
        /// 认证对象
        /// </summary>
        public abstract class Auth
        {
            /// <summary>
            /// 登录
            /// </summary>
            public abstract void Login(string userName, string password, Action<MembershipUser> handle, bool remember = false);
            public abstract void Logout();
            public virtual void SynThread(Action<eTaxiPrincipal> handle)
            {
                // 默认处置
                var defaultPrincipal =
                    new eTaxiPrincipal(new eTaxiIdentity(new GenericIdentity(D.Login.Guest), true))
                        {
                            Id = Guid.Parse(D.Login.GuestId),
                            IsPublic = false,
                            IsGuest = true
                        };

                HttpContext.Current.User = defaultPrincipal;
                Thread.CurrentPrincipal = defaultPrincipal;
                handle(defaultPrincipal);
            }
            protected BasePage _Page = null;
            protected string _AppName = string.Empty;
            public Auth(BasePage page, string appName = "/") { _Page = page; _AppName = appName; }
        }

        /// <summary>
        /// Forms 认证
        /// </summary>
        public class FormsAuth : Auth
        {
            public FormsAuth(BasePage page, string appName = "/") : base(page, appName) { }
            public override void Login(string userName, string password, Action<MembershipUser> handle, bool remember = false)
            {
                const string errMsg = "用户名 或者 密码错误";
                if (!
                    Membership.ValidateUser(userName, password))
                    throw new Exception(errMsg);
                var user = Membership.GetUser(userName, true);
                if (user == null) throw new Exception(errMsg);
                try { handle(user); }
                catch { throw new Exception(errMsg); }
                if (!remember) return;
                var ticket = new
                    FormsAuthenticationTicket(
                    1, userName, _Page._CurrentTime, _Page._CurrentTime.AddDays(1), true, (
                    new DictionaryEntry(_AppName, user.ProviderUserKey)).ToXml());
                var cookieStr = FormsAuthentication.Encrypt(ticket);
                var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, cookieStr);
                cookie.Expires = DateTime.Now.AddDays(1);
                cookie.Path = FormsAuthentication.FormsCookiePath;
                _Page.Response.Cookies.Add(cookie);
            }
            public override void Logout()
            {
                // 清除Seesion对象
                _Page.Session.Timeout = 1;
                _Page.Session.Abandon();

                // 在此处放置用户代码以初始化页面
                FormsAuthentication.SignOut();

                // 去除注册
                Global.Sessions.Unregister(_Page.Session.SessionID);

                // 返回注册页面
                FormsAuthentication.RedirectToLoginPage();
            }
            public override void SynThread(Action<eTaxiPrincipal> handle)
            {
                if (!_Page.User.Identity.IsAuthenticated) { base.SynThread(handle); return; }
                if (!(_Page.User.Identity is FormsIdentity)) { base.SynThread(handle); return; }
                
                var fIdentity = (FormsIdentity)_Page.User.Identity;
                if (fIdentity.Ticket.Expired) { base.SynThread(handle); return; }

                DictionaryEntry storedData = (DictionaryEntry)
                    storedData.FromXml(fIdentity.Ticket.UserData);
                Guid Id = Guid.Empty;
                if (Guid.TryParse(storedData.Value.ToString(), out Id))
                {
                    // 将票据状态中包含的用户ID获取出来（可以考虑加密）
                    var principal =
                        new eTaxiPrincipal(new eTaxiIdentity(fIdentity, true))
                        {
                            Id = Id,
                            IsPublic = (storedData.Key.ToString() != Parameters.ApplicationName),
                            IsGuest = false
                        };

                    HttpContext.Current.User = principal;
                    Thread.CurrentPrincipal = principal;
                    handle(principal);
                    return;
                }
                
                // 默认处理
                base.SynThread(handle);
            }
        }

        ///// <summary>
        ///// Windows 认证
        ///// </summary>
        //public class WindowsAuth : Auth
        //{
        //    public override void SynThread(Action<eTaxiPrincipal> handle)
        //    {
        //        //if (HttpContext.User.Identity is WindowsIdentity)
        //        //{
        //        //    WindowsIdentity wIdentity =
        //        //        (WindowsIdentity)HttpContext.User.Identity;
        //        //    ISSPrincipal principal = new ISSPrincipal(new ISSIdentity(wIdentity, true));
        //        //    HttpContext.User = principal;
        //        //    Thread.CurrentPrincipal = principal;
        //        //}
        //    }
        //}

        ///// <summary>
        ///// 一般认证
        ///// </summary>
        //public class GeneralAuth : Auth
        //{
        //    public override void SynThread(Action<eTaxiPrincipal> handle)
        //    {
        //        //if (HttpContext.User.Identity is GenericIdentity)
        //        //{
        //        //    GenericIdentity gIdentity =
        //        //        (GenericIdentity)HttpContext.User.Identity;
        //        //    ISSPrincipal principal = new ISSPrincipal(new ISSIdentity(gIdentity, true));
        //        //    HttpContext.User = principal;
        //        //    Thread.CurrentPrincipal = principal;
        //        //}
        //    }
        //}

        BasePage IPageEx.HostingPage { get { return this; } }
        DateTime IPageEx.CurrentTime { get { return _CurrentTime; } }
        IDataConnectionManager IPageEx.DataConnectionManager { get { return _DataConnectionManager; } }
        HttpSessionStateWrapper IPageEx.SessionEx { get { return _SessionEx; } }
        CommonService IPageEx.DTService { get { return _DTService; } }
        MembershipProvider IPageEx.MembershipProvider { get { return _MembershipProvider; } }
        RoleProvider IPageEx.RoleProvider { get { return _RoleProvider; } }
        ProfileProvider IPageEx.ProfileProvider { get { return _ProfileProvider; } }
        void IPageEx.Logout() { _Auth.Logout(); }
        void IPageEx.HandleException(Exception ex, Action<string> msgSend) { HandleException(ex, msgSend); }
        bool IPageEx.HandleException(Type callerType, ExceptionFilter exFilter, string step, Action<string> msgSend) { return _HandleException(callerType, exFilter, step, msgSend); }
        void IPageEx.Alert(string message, string postScript, bool executeBeforeAlert) { _JS.Alert(message, postScript, executeBeforeAlert); }
        void IPageEx.Alert<T>(T caller, string message, string postScript, bool executeBeforeAlert) { _JS.Alert<T>(caller, message, postScript, executeBeforeAlert); }
        void IPageEx.JS(string snippet) { _JS.Write(snippet); }
        void IPageEx.JS<T>(T caller, string snippet) { _JS.Write<T>(caller, snippet); }
        void IPageEx.ExportToExcel<T>(string section, List<T> data, string[] headers) { _ExportToExcel<T>(section, data, headers); }
        void IPageEx.ExportToExcel<T, TSource>(string section, List<TSource> data, string[] headers, Func<TSource, T> itemGet) { _ExportToExcel<T, TSource>(section, data, headers, itemGet); }
        bool IPageEx.TransCall(Action handle, Action<Exception> exceptionHandle, bool requireTransaction) { return _TransCall(handle, exceptionHandle, requireTransaction); }

    }

}