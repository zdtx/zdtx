using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Globalization;

namespace eTaxi
{
    /// <summary>
    /// 工具类，开放给扩展
    /// </summary>
    public static partial class XUtil
    {
        /// <summary>
        /// 生成类型标识字符串
        /// </summary>
        public static string GenerateTypeInfo(Type type)
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

        public class ListBuilder<T>
        {
            private List<T> _List = new List<T>();
            public List<T> List { get { return _List; } }
            public ListBuilder(T firstObject) { _List.Add(firstObject); }
            public ListBuilder<T> Add(T obj)
            {
                _List.Add(obj);
                return this;
            }
        }

        /// <summary>
        /// 建立匿名类型的 List
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public static List<T> BuildList<T>(T obj, Action<ListBuilder<T>> build = null)
        {
            var builder = new ListBuilder<T>(obj);
            if (build != null) build(builder);
            return builder.List;
        }

    }
}