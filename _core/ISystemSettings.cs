using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace eTaxi
{
    /// <summary>
    /// 系统配置源（负责为所有部件提供划一的配置值存储服务）
    /// </summary>
    public interface ISystemSettings
    {
        string Get(string key);
        T Get<T>(string key, T defaultValue = default(T));
        void Set(object value, string key);
        void Set<T>(T value, string key);
        void Save();
    }

}
