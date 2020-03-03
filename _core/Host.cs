using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using Microsoft.Practices.Unity;

namespace eTaxi
{
    /// <summary>
    /// 宿主对象
    /// </summary>
    public static class Host
    {
        private static IUnityContainer _Container = new UnityContainer();
        public static IUnityContainer Container
        {
            get { return _Container; }
            set { _Container = value; }
        }

        /// <summary>
        /// 标准服务请求
        /// </summary>
        public static TService CreateService<TService>()
        {
            TService service = Host.Container.Resolve<TService>();
            return service;
        }

        private static ISystemSettings _Settings = null;
        /// <summary>
        /// 快捷方法获取 ISystemSettings 对象
        /// </summary>
        public static ISystemSettings Settings
        {
            get
            {
                if (_Settings != null) return _Settings;
                _Settings = Container.Resolve<ISystemSettings>();
                return _Settings;
            }
        }
    }
}