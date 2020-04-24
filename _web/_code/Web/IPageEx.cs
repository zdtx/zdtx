using eTaxi.L2SQL;

using System;
using System.Collections.Generic;
using System.Web.Profile;
using System.Web.Security;
using System.Web.UI;

namespace eTaxi.Web
{
    /// <summary>
    /// 作为和控件沟通的接口协议
    /// </summary>
    public interface IPageEx
    {
        BasePage HostingPage { get; }
        DateTime CurrentTime { get; }
        HttpSessionStateWrapper SessionEx { get; }
        IDataConnectionManager DataConnectionManager { get; }
        CommonService DTService { get; }
        MembershipProvider MembershipProvider { get; }
        RoleProvider RoleProvider { get; }
        ProfileProvider ProfileProvider { get; }
        bool TransCall(Action handle, Action<Exception> exceptionHandle = null, bool requireTransaction = true);
        void ExportToExcel<T>(string section, List<T> data, string[] headers);
        void ExportToExcel<T, TSource>(string section, List<TSource> data, string[] headers, Func<TSource, T> itemGet);
        void Logout();
        void HandleException(Exception ex, Action<string> msgSend = null);
        bool HandleException(Type callerType, ExceptionFilter exFilter, string step, Action<string> msgSend = null);
        bool AC(string code);
        void Alert(string message, string postScript = null, bool executeBeforeAlert = false);
        void Alert<T>(T caller, string message, string postScript = null, bool executeBeforeAlert = false) where T : Control;
        void JS(string snippet);
        void JS<T>(T caller, string snippet) where T : Control;
        string GetSitePrefix();
        string PostExternal<TObj>(TObj obj, string actionUrl, Action<string> handle = null);
        string ResolvePath(string path);
    }

}