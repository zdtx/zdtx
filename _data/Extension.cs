using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

//using eTaxi.L2SQL;
namespace eTaxi
{
    public static partial class L2SQLExtension
    {
        /// <summary>
        /// 处理匹配物料集合里的某个物料
        /// </summary>
        /// <param name="data"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static void Hit<T>(this List<T> data, string id, Func<T, string, bool> singleMatch, Action<T> handle)
        {
            if (data.Count == 0) return ;
            data.SingleOrDefault(d => singleMatch(d, id)).IfNN(m => handle(m));
        }

        /// <summary>
        /// 查看某个键组是否包含在列表
        /// </summary>
        /// <param name="data"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public static bool Includes<T>(this List<T> data, string[] ids, Func<T, string, bool> singleMatch)
        {
            foreach (var id in ids)
            {
                if (!
                    data.Any(d => singleMatch(d, id)))
                    return false;
            }
            return true;
        }

    }


}