using System;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.IO;

using Microsoft.Practices.Unity;
using LinqKit;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 数据来源
    /// </summary>
    public enum TargetDatabase
    {
        Data
    }

    /// <summary>
    /// 为 web 的处理提供方法集合
    /// </summary>
    public static partial class Util
    {
        /// <summary>
        /// 业务数据工厂（只能给出数据库的上下文）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static T DTContext<T>(bool readOnly = false) where T : CommonContext { return _CreateContext<T>(TargetDatabase.Data, readOnly); }
        private static T _CreateContext<T>(TargetDatabase database, bool readOnly = false) where T : DataContextEx
        {
            IConnectionManagerEx manager = null;
            switch (database)
            {
                case TargetDatabase.Data:
                    manager = Host.Container.Resolve<IDataConnectionManager>();
                    break;
            }
            T result = default(T);
            if (manager.Transaction == null && readOnly)
            {
                result = Activator.CreateInstance(typeof(T), manager.Connection) as T;
                result.ObjectTrackingEnabled = false;
                manager.RegisterContext(result);
                return result;
            }
            result = Activator.CreateInstance(typeof(T), manager.Connection) as T;
            result.Transaction = manager.Transaction;
            manager.RegisterContext(result);
            return result;
        }

        /// <summary>
        /// 需要执行事务的方法闭包
        /// </summary>
        public static bool TransCall(
            Action handle, Action<Exception> exceptionHandle = null, bool requireTransaction = true)
        {
            var _DataConnectionManager = Host.Container.Resolve<IDataConnectionManager>();
            bool dataTransRequired = _DataConnectionManager.TrackingContextExists();
            DbTransaction dTrans = null;

            try
            {
                if (requireTransaction && dataTransRequired) dTrans = _DataConnectionManager.StartTransaction();
                handle();
                if (requireTransaction && dTrans != null && dTrans.Connection != null) dTrans.Commit();
                return true;
            }
            catch (Exception ex)
            {
                if (requireTransaction && dTrans != null && dTrans.Connection != null) dTrans.Rollback();
                if (exceptionHandle != null) exceptionHandle(ex);
                return false;
            }
            finally
            {
                if (requireTransaction) _DataConnectionManager.EndTransaction();
            }

        }

        /// <summary>
        /// 同步系统页面和控件，形成用于权限分配的模块表
        /// </summary>
        public static void SynModules(Action<string> msgSend = null)
        {
            string[] ascx = new string[] { "_controls", "_controls.desktop" };
            string[] aspx = new string[] { "domain", "system" };

            var context = DTContext<CommonContext>();
            var modules = context.Modules.ToList();
            var currentTime = DateTime.Now;
            var session = new AdminSession(currentTime);
            var uc = new UserControl();

            Action<string, bool> _do = (dir, isPage) => { };
            _do = (dir, isPage) =>
            {
                var pattern = isPage ? "*.aspx" : "*.ascx";
                var folder = dir.Replace(Parameters.SitePath, string.Empty).Replace('\\', '.');
                Directory.GetDirectories(dir).ForEach(d => _do(d.ToLower(), isPage));
                Directory.GetFiles(dir, pattern).ForEach(f =>
                {
                    var path = f.ToLower().Replace(Parameters.SitePath, string.Empty).Replace('\\', '/');
                    var name = f.ToLower().Replace(dir + "\\", string.Empty);
                    var shouldDo = true;
                    if (!isPage)
                    {
                        var c = uc.LoadControl("~/" + path) as Web.BaseControl;
                        shouldDo = c.AccessControlled;
                        if (shouldDo)
                        {
                            if (string.IsNullOrEmpty(c.ModuleId))
                                throw new Exception(string.Format(" {0} 未设置 ModuleId", path));
                            if (!path.EndsWith(c.ModuleId.ToLower()))
                                throw new Exception(string.Format(" {0} ModuleId 设置错误", path));
                        }
                    }

                    if (!shouldDo) return;
                    context
                        .CreateWhenNotExists<TB_sys_module>(
                            session, m => m.Folder == folder && m.Path == path && m.IsPage == isPage,
                            (m, isNew) =>
                            {
                                if (!isNew) return;
                                m.Folder = folder;
                                m.Path = path;
                                m.IsPage = isPage;
                                m.Name = name;
                            });
                });
            };

            aspx.ForEach(p => _do(Parameters.SitePath + p, true));
            ascx.ForEach(c => _do(Parameters.SitePath + c, false));
            modules.ForEach(m =>
            {
                if (!
                    File.Exists(Parameters.SitePath + m.Path)) m.Enabled = false;
            });
            context.SubmitChanges();
        }

        /// <summary>
        /// 获取所有门户控件信息
        /// </summary>
        /// <returns></returns>
        public static List<PortletInfo> GetPortlets()
        {
            var dir = Parameters.SitePath + "_controls.desktop";
            var portlets = new List<PortletInfo>();
            var uc = new UserControl();
            Directory.GetFiles(dir, "*.ascx").ForEach(f =>
            {
                var path = f.ToLower().Replace(Parameters.SitePath, string.Empty).Replace('\\', '/');
                var name = f.ToLower().Replace(dir + "\\", string.Empty);
                var c = uc.LoadControl("~/" + path) as Web.BasePortlet;
                portlets.Add(new PortletInfo()
                {
                    Id = c.ModuleId,
                    Name = name,
                    Path = path,
                    Ordinal = c.Ordinal,
                    AccessControlled = c.AccessControlled
                });
            });
            return portlets;
        }
    
    }
}