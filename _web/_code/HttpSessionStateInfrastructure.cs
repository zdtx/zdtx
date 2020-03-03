using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

using D = eTaxi.Definitions;
using E = eTaxi.Exceptions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 全局缓存对象，用于管理已经激活的 session
    /// </summary>
    public class HttpSessionStateInfrastructure
    {
        private List<HttpSessionStateWrapper> _Data = new List<HttpSessionStateWrapper>();
        private object _Locker = new object();

        /// <summary>
        /// 注册会话
        /// </summary>
        /// <param name="session"></param>
        public void Register(HttpSessionStateWrapper session)
        {
            if (_Data.Any(s => s.SessionId == session.SessionId)) return;
            lock (_Locker)
            {
                if (!
                    _Data.Any(s => s.SessionId == session.SessionId))
                    _Data.Add(session);
            }
        }

        /// <summary>
        /// 去除会话登记
        /// </summary>
        /// <param name="id"></param>
        public void Unregister(string id)
        {
            lock (_Locker)
            {
                var session = _Data.SingleOrDefault(s => s.SessionId == id);
                if (session != null) _Data.Remove(session);
                List<HttpSessionStateWrapper> list = new List<HttpSessionStateWrapper>();
                foreach (var s in _Data) if (s.HasExpired) list.Add(s);
                list.ForEach(s => _Data.Remove(s));
            }
        }

        /// <summary>
        /// 获取剪影数据
        /// </summary>
        /// <returns></returns>
        public List<T> Snapshot<T>(
            Func<HttpSessionStateWrapper, bool> where,
            Func<HttpSessionStateWrapper, T> select)
        {
            lock (_Locker)
            {
                return _Data.Where(where).Select(select).ToList();
            }
        }

        /// <summary>
        /// 设脏
        /// </summary>
        /// <param name="section"></param>
        public void SetDirty(HttpSessionStateWrapper.Types section, bool value = true)
        {
            lock (_Locker)
            {
                foreach (var s in _Data) s.SetDirty(section, value);
            }
        }

        /// <summary>
        /// 全部设脏标记
        /// </summary>
        public void SetAllDirty()
        {
            lock (_Locker)
            {
                foreach (var s in _Data) s.SetAllDirty();
            }
        }

        /// <summary>
        /// 计数
        /// </summary>
        /// <param name="where"></param>
        /// <returns></returns>
        public int Count(Func<HttpSessionStateWrapper, bool> where = null)
        {
            if (where != null) return _Data.Count(where);
            return _Data.Count();
        }

    }
}