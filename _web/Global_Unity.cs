using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Profile;
using Microsoft.Practices.Unity;

using eTaxi.L2SQL;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    public partial class Global : System.Web.HttpApplication
    {
        /// <summary>
        /// 执行主体容器的创建
        /// </summary>
        protected void ReloadContainer()
        {
            Host.Container.Dispose();
            Host.Container = new UnityContainer();

            // 注册服务块
            L2SQL.Plugger.Common.Register(Host.Container);

            // 注册连接管理对象
            Host.Container
                .RegisterType<IDataConnectionManager, DataConnectionManager>(new RequestLifetimeManager())
                ;

            // 单例注册系统设置对象（访问 web.config 文件）
            Host.Container.RegisterInstance<ISystemSettings>(new SystemSettings());

            // Ajax 注册
            ISSRego.X.ExtNET(Context);

            // Providers 注册
            RegisterProviders(Host.Container);
        }

        private void RegisterProviders(IUnityContainer container)
        {
            // 身份
            MembershipProviderCollection mProviders = new MembershipProviderCollection();
            MembershipSection mSection =
                (MembershipSection)WebConfigurationManager.GetSection("system.web/membership");
            foreach (ProviderSettings settings in mSection.Providers)
            {
                if (settings.Parameters["connectionStringName"] != null)
                    settings.Parameters["connectionStringName"] = D.NamedSection.DataConnection;
            }

            ProvidersHelper.InstantiateProviders(
                mSection.Providers, mProviders, typeof(MembershipProvider));
            MembershipProvider mProvider = mProviders[mSection.DefaultProvider];

            // 角色

            RoleProviderCollection rProviders = new RoleProviderCollection();
            RoleManagerSection rSection =
                (RoleManagerSection)WebConfigurationManager.GetSection("system.web/roleManager");
            foreach (ProviderSettings settings in rSection.Providers)
            {
                if (settings.Parameters["connectionStringName"] != null)
                    settings.Parameters["connectionStringName"] = D.NamedSection.DataConnection;
            }

            ProvidersHelper.InstantiateProviders(
                rSection.Providers, rProviders, typeof(RoleProvider));
            RoleProvider rProvider = rProviders[rSection.DefaultProvider];

            // 配置

            ProfileProviderCollection pProviders = new ProfileProviderCollection();
            ProfileSection pSection =
                (ProfileSection)WebConfigurationManager.GetSection("system.web/profile");
            foreach (ProviderSettings settings in pSection.Providers)
            {
                if (settings.Parameters["connectionStringName"] != null)
                    settings.Parameters["connectionStringName"] = D.NamedSection.DataConnection;
            }

            ProvidersHelper.InstantiateProviders(
                pSection.Providers, pProviders, typeof(ProfileProvider));
            ProfileProvider pProvider = pProviders[pSection.DefaultProvider];

            container.RegisterInstance<MembershipProvider>(mProvider);
            container.RegisterInstance<RoleProvider>(rProvider);
            container.RegisterInstance<ProfileProvider>(pProvider);
        }

    }
}