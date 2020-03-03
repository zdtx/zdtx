using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web.UI;

namespace eTaxi
{
    /// <summary>
    /// view state 管理器（扩充至强类型存储）
    /// </summary>
    public class StateBagWrapper
    {
        /// <summary>
        /// 该方法一般用于 GET，为值形成一个默认，POST 回来就直接 Get 了
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="value">值对象</param>
        /// <param name="key">键值</param>
        /// <param name="exceptionIfExists">如果已经有了，是否报错</param>
        public void Register<T>(T value, string key = null, bool exceptionIfExists = false)
        {
            string k = Util.GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            if (_ViewState[k] != null && exceptionIfExists) throw new Exception(string.Format("State [{0}] already assigned", k));
            _ViewState[k] = value;
        }

        /// <summary>
        /// 清理视图状态
        /// </summary>
        public void Clear() { _ViewState.Clear(); }

        /// <summary>
        /// 获取存储值
        /// </summary>
        /// <typeparam name="T">类型</typeparam>
        /// <param name="key">键值</param>
        /// <param name="emptyValue">如果取不出，是否用默认的</param>
        /// <returns></returns>
        public T Get<T>(string key = null, T emptyValue = default(T), bool exceptionIfInvalid = false)
        {
            string k = Util.GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            if (_ViewState[k] == null)
            {
                _ViewState[k] = emptyValue;
                return emptyValue;
            }
            try
            {
                return (T)_ViewState[k];
            }
            catch (Exception ex)
            {
                if (exceptionIfInvalid) throw ex;
                return emptyValue;
            }
        }

        /// <summary>
        /// 纯粹 ViewState 操作
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public object Get(string key) { return _ViewState[key]; }

        /// <summary>
        /// 修改 View state 值，用于 postback
        /// </summary>
        public void Set<T>(T value, string key = null)
        {
            string k = Util.GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            _ViewState[k] = value;
        }

        private StateBag _ViewState = null;
        public StateBagWrapper(StateBag viewState) { _ViewState = viewState; }
    }
}