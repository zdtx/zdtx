using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.Web.Configuration;
using System.Globalization;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 连接管理对象
    /// </summary>
    public class SystemSettings : ISystemSettings
    {
        /// <summary>
        /// 集中将 web.config 中的 AppSettings 作为设定的信息存储区
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public string Get(string key)
        {
            return WebConfigurationManager.AppSettings[key];
        }

        /// <summary>
        /// 获取类型转换值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public T Get<T>(string key, T defaultValue = default(T))
        {
            string value = WebConfigurationManager.AppSettings[key];
            if (string.IsNullOrEmpty(value)) return defaultValue;
            return DataConvert.From<T>(value, CultureInfo.InvariantCulture);
        }

        public void Save()
        {
            throw new NotImplementedException();
        }

        public void Set<T>(T value, string key)
        {
            throw new NotImplementedException();
        }

        public void Set(object value, string key)
        {
            throw new NotImplementedException();
        }
    }

}