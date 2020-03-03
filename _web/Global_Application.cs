using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

using Microsoft.Practices.Unity;
namespace eTaxi.Web
{
    public partial class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // 初始化当前登录人数
            Application.Lock();

            // 初始化容器
            ReloadContainer();

            // 重设系统初始化标记
            _Initialized = true;
            _MethodIndex = 0;

            // 赋值全局参数
            Parameters.SitePath = Server.MapPath("~").ToLower();
            if (!
                Parameters.SitePath.EndsWith("\\"))
                Parameters.SitePath = (Parameters.SitePath + "\\");

            #region 系统关键初始化方法

            ExecuteVitalMethod(ConfigCache);        // 配置缓存
            ExecuteVitalMethod(() =>
            {
                _Workers.Resolve(new TimerEngine());
            });

            #endregion

            Application.UnLock();

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

    }
}