using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.Configuration;
using System.Globalization;

using D = eTaxi.Definitions;
namespace eTaxi
{
    /// <summary>
    /// 连接管理对象
    /// </summary>
    public class SystemSettings : ISystemSettings
    {
        /// <summary>
        /// 集中将 app.config 中的 AppSettings 作为设定的信息存储区
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public string Get(string key)
        {
            return ConfigurationManager.AppSettings[key];
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
            string value = ConfigurationManager.AppSettings[key];
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

        public class States
        {
            public const string Interval = "interval";
            public const string DayInfo = "day";
            public const string TimeInfo = "time";
            public const string Secret = "secret";
        }

        /// <summary>
        /// 设备扫描间隔（默认 10 分钟）
        /// </summary>
        public int Interval
        {
            get { return Get<int>(States.Interval, 10); }
            set { Set<int>(value, States.Interval); }
        }

        /// <summary>
        /// 可执行的周（日）区段
        /// </summary>
        public string DayInfo
        {
            get { return Get<string>(States.DayInfo, "1-5"); }
            set { Set<string>(value, States.DayInfo); }
        }

        /// <summary>
        /// 可执行的时区段
        /// </summary>
        public string TimeInfo
        {
            get { return Get<string>(States.TimeInfo, "0-24"); }
            set { Set<string>(value, States.TimeInfo); }
        }

        /// <summary>
        /// 应用挑战常量
        /// </summary>
        public string Secret
        {
            get { return Get<string>(States.Secret, string.Empty); }
            set { Set<string>(value, States.Secret); }
        }
   
    }
}