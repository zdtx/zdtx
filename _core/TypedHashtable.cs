using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace eTaxi
{
    /// <summary>
    /// 为页面准备分区缓存对象
    /// </summary>
    [Serializable]
    public class TypedHashtable : Hashtable
    {
        /// <summary>
        /// 生成类型标识字符串
        /// </summary>
        private string _GenerateTypeInfo(Type type)
        {
            string result = type.Name;
            if (type.IsGenericType)
            {
                Type[] arguments = type.GetGenericArguments();
                result = string.Empty;
                foreach (Type tt in arguments)
                    result += result.Length == 0 ? tt.Name : ", " + tt.Name;
                result = string.Format("{0}<{1}>", type.Name, result);
            }
            return result;
        }

        /// <summary>
        /// 加锁对象
        /// </summary>
        private object _Locker = new object();

        /// <summary>
        /// 加入强类型对象
        /// </summary>
        /// <typeparam name="T">元素类型</typeparam>
        /// <param name="key">键值</param>
        public void Resolve<T>(T value, string key = null) { Add<T>(value, key); }
        
        /// <summary>
        /// 当发现没有这个值的时候，执行创建
        /// 并添加到缓存
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <param name="createAdd"></param>
        public T Resolve<T>(Func<T> createAdd, string key = null)
        {
            string k = _GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            if (ContainsKey(k)) return Get<T>(key: key);
            T value = createAdd();
            Add<T>(value, key);
            return value;
        }

        /// <summary>
        /// 加入强类型对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <param name="key"></param>
        public void Add<T>(T value, string key = null)
        {
            string k = _GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            lock (_Locker)
            {
                if (ContainsKey(k))
                {
                    if (this[k] != null && !(this[k] is T)) throw new Exception("Item type mismatched.");
                    this[k] = value;
                    return;
                }
                Add(k, value);
            }
        }

        /// <summary>
        /// 获得强类型元素
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <returns></returns>
        public T Get<T>()
        {
            string k = _GenerateTypeInfo(typeof(T));
            if (ContainsKey(k)) return (T)this[k];
            throw new Exception(string.Format("'{0}' not found", k));
        }
        public T Get<T>(T nullValue)
        {
            string k = _GenerateTypeInfo(typeof(T));
            if (ContainsKey(k)) return (T)this[k];
            return nullValue;
        }
        public T Get<T>(string key, Func<T> nullGet = null)
        {
            string k = _GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            if (ContainsKey(k)) return (T)this[k];
            if (nullGet != null) return nullGet();
            return default(T);
        }

        /// <summary>
        /// 去除强类型的字典项
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        public void Remove<T>(string key = null)
        {
            string k = _GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            lock (_Locker)
            {
                if (!ContainsKey(k)) return;
                Remove(k);
            }
        }

        /// <summary>
        /// 检查这个键值在不在
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool Contains<T>(string key = null)
        {
            string k = _GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            return ContainsKey(k);
        }

        public bool ShareTo<T>(TypedHashtable target, string sourceKey = null, string targetKey = null)
        {
            if (!Contains<T>(sourceKey)) return false;
            target.Add<T>(Get<T>(sourceKey), targetKey);
            return true;
        }
    }
}