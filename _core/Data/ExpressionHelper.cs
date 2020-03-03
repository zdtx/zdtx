using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Reflection;

namespace eTaxi
{
    /// <summary>
    /// Expression 应用包
    /// </summary>
    public static class Exp
    {
        /// <summary>
        /// 执行系列 Sort （带字符串输入）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="q"></param>
        /// <param name="sorts">(string, bool) 字段，是否升序 </param>
        /// <returns></returns>
        public static IQueryable<T> AppendSorts<T>(
            IQueryable<T> q, params KeyValuePair<string, bool>[] sorts)
        {
            if (sorts.Length == 0) return q;

            // 构造方法调用
            const string PARAMETER_NAME = "t";
            const string M_OrderBy = "OrderBy";
            const string M_OrderByDescending = "OrderByDescending";
            const string M_ThenBy = "ThenBy";
            const string M_ThenByDescending = "ThenByDescending";

            var result = q;
            for (int i = 0; i < sorts.Length; i++)
            {
                // 构造 lambda
                ParameterExpression expParameter = Expression.Parameter(typeof(T), PARAMETER_NAME);
                MemberExpression expMember = Expression.Property(expParameter, sorts[i].Key);
                LambdaExpression expLambda = Expression.Lambda(expMember, expParameter);

                if (i == 0)
                {
                    MethodCallExpression orderCall = Expression.Call(
                        typeof(Queryable), sorts[i].Value ? M_OrderBy : M_OrderByDescending,
                        new Type[] { result.ElementType, expLambda.Body.Type }, result.Expression, expLambda);
                    result = result.Provider.CreateQuery<T>(orderCall);
                }
                else
                {
                    MethodCallExpression orderCall = Expression.Call(
                        typeof(Queryable), sorts[i].Value ? M_ThenBy : M_ThenByDescending,
                        new Type[] { result.ElementType, expLambda.Body.Type }, result.Expression, expLambda);
                    result = result.Provider.CreateQuery<T>(orderCall);
                }
            }

            return result;
        }

        /// <summary>
        /// 对列表进行转换（匿名 => 类型）
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <param name="source"></param>
        /// <param name="itemGet"></param>
        /// <returns></returns>
        public static List<TTarget> Transform<TSource, TTarget>(List<TSource> source, Func<TSource, TTarget> itemGet)
        {
            List<TTarget> result = new List<TTarget>();
            source.ForEach(t =>
            {
                var newItem = itemGet(t);
                if (newItem != null) result.Add(itemGet(t));
            });
            return result;
        }
    }

    /// <summary>
    /// Expression 应用包
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public static class Exp<T>
    {
        /// <summary>
        /// 将表达式转化成属性字串数组
        /// </summary>
        /// <param name="fieldSelector">仅仅接受对 new{ T.Field1, T.Field2 } 的形式</param>
        /// <returns></returns>
        public static string[] Properties<TFields>(Expression<Func<T, TFields>>
            fieldSelector) { return fieldSelector.Body.Type.GetProperties().Select(p => p.Name).ToArray(); }
        public static string Property<TField>(Expression<Func<T, TField>> fieldSelector)
        {
            MemberExpression mExp = (MemberExpression)fieldSelector.Body;
            if (mExp != null) return mExp.Member.Name;
            return string.Empty;
        }

        /// <summary>
        /// 对列表进行转换（类型 => 匿名）
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <param name="source"></param>
        /// <param name="itemGet"></param>
        /// <returns></returns>
        public static List<TTarget> Transform<TTarget>(List<T> source, Func<T, TTarget> itemGet)
        {
            return Exp.Transform<T, TTarget>(source, itemGet);
        }

        /// <summary>
        /// 对列表进行转换（匿名 => 类型）
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <param name="source"></param>
        /// <param name="itemGet"></param>
        /// <returns></returns>
        public static List<T> Transform<TSource>(List<TSource> source, Func<TSource, T> itemGet)
        {
            return Exp.Transform<TSource, T>(source, itemGet);
        }

    }
}
