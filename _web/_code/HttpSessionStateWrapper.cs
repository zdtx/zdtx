using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.SessionState;
using System.Threading;
using System.Linq;
using System.Globalization;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 回话状态管理器（扩充至强类型存储）
    /// 闭包两大基架：1. SessionState 和 2. Profile
    /// </summary>
    public class HttpSessionStateWrapper : IUserSession, IUserProfiles
    {
        /// <summary>
        /// 脏部分
        /// </summary>
        public enum Types
        {
            Role, Portlet
        }

        public class Keys
        {
            public const string BranchId = "branchId";
            public const string DepartmentId = "departmentId";
            public const string PositionId = "positionId";
            public const string UniqueId = "uniqueId";
            public const string UserName = "userName";
            public const string Name = "name";
            public const string Theme = "theme";
            public const string RoleIds = "roleIds";
            public const string Portlets = "portlets";

            // last visit
            public const string LVTime = "lvTime";
            public const string LVUrl = "lvUrl";
            public const string LVUrlReferrer = "lvUrlReferrer";
            public const string LVAgent = "lvAgent";
            public const string LVHostName = "lvHostName";
            public const string LVHostAddress = "lvHostAddress";
            public const string DirtyFlags = "dirtyFlags";
            public const string LastException = "lastException";
        }

        #region 由 Profile 存储
        
        private PersonalSettings _Settings = new PersonalSettings();
        public CultureInfo UICulture { get { return _Settings.UICultureInfo; } }
        public CultureInfo Culture { get { return _Settings.CultureInfo; } }
        public string Theme { get { return _Settings.UITheme; } }

        #endregion

        /// Ticket 机制开发
        /// 会话充当页面跳转之间的临时桥梁，给定一个初始值
        /// 当对应的页面获取该值后，按照过期策略执行值的消灭和释放内存
        private TicketedObjectManager _TKObjectManager;
        public TicketedObjectManager TKObjectManager { get { return _TKObjectManager; } }

        /// 为每个 Session 开办一个长任务线程管理器
        private ExtraThreadWrapper _ExtraThread;
        public ExtraThreadWrapper ExtraThread { get { return _ExtraThread; } }

        private object _Locker_Dirty = new object();
        private Dictionary<Types, bool> _Dirties
        {
            get
            {
                if (Contains(Keys.DirtyFlags)) return Get<Dictionary<Types, bool>>(Keys.DirtyFlags);
                lock (_Locker_Dirty)
                {
                    Set<Dictionary<Types, bool>>(new Dictionary<Types, bool>()
                    {
                        { Types.Role, true },
                        { Types.Portlet, true }

                    }, Keys.DirtyFlags);
                    return Get<Dictionary<Types, bool>>(Keys.DirtyFlags);
                }
            }
        }

        private TypedHashtable _Cache;
        public TypedHashtable Cache { get { return _Cache; } }
        public HttpSessionState States { get { return _SessionState; } }

        /// <summary>
        /// KB：优化代码，取出在缓存中过期的会话
        /// </summary>
        public string SessionId { get { return _SessionId; } }
        private string _SessionId = string.Empty;

        /// <summary>
        /// 判别 session 处在登录中的状态
        /// </summary>
        public bool Logined
        {
            get
            {
                return
                    !string.IsNullOrEmpty(UserName) &&
                    UniqueId != Guid.Empty;
            }
        }

        public bool HasExpired
        {
            get
            {
                bool expired = true;
                try
                {
                    if (_SessionState.SessionID != null &&
                        _SessionState.SessionID == _SessionId) expired = false;
                }
                catch { expired = true; }
                return expired;
            }
        }

        /// <summary>
        /// 可访问的控件路径
        /// </summary>
        public string[] Portlets
        {
            get
            {
                if (_Dirties[Types.Portlet] && Dirty != null) Dirty(Types.Portlet);
                return Get<string[]>(Keys.Portlets, new string[] { });
            }
        }

        /// <summary>
        /// 当前登录涵盖的 角色
        /// </summary>
        public string[] RoleIds
        {
            get
            {
                if (_Dirties[Types.Role] && Dirty != null) Dirty(Types.Role);
                return Get<string[]>(Keys.RoleIds, new string[] { });
            }
        }

        public Exception LastException
        {
            get { return Get<Exception>(Keys.LastException); }
            set { Set<Exception>(value, Keys.LastException); }
        }

        public string BranchId
        {
            get { return Get<string>(Keys.BranchId, string.Empty); }
            set { Set<string>(value, Keys.BranchId); }
        }

        public string DepartmentId
        {
            get { return Get<string>(Keys.DepartmentId, string.Empty); }
            set { Set<string>(value, Keys.DepartmentId); }
        }

        public string PositionId
        {
            get { return Get<string>(Keys.PositionId, string.Empty); }
            set { Set<string>(value, Keys.PositionId); }
        }

        public Guid UniqueId
        {
            get { return Get<Guid>(Keys.UniqueId, Guid.Empty); }
            set { Set<Guid>(value, Keys.UniqueId); }
        }

        /// <summary>
        /// 人员 Id 
        /// </summary>
        public string Id
        {
            get { return Get<string>(D.Session.Keys.Id, string.Empty); }
            set { Set<string>(value, D.Session.Keys.Id); }
        }

        /// <summary>
        /// 用户登录名
        /// </summary>
        public string UserName
        {
            get { return Get<string>(Keys.UserName, string.Empty); }
            set { Set<string>(value, Keys.UserName); }
        }

        /// <summary>
        /// 用户对应的人的真实姓名
        /// </summary>
        public string Name
        {
            get { return Get<string>(Keys.Name, string.Empty); }
            set { Set<string>(value, Keys.Name); }
        }

        private DateTime _CurrentTime = DateTime.Now;
        public DateTime CurrentTime { get { return _CurrentTime; } }

        #region 最后行为值

        public Nullable<DateTime> LastVisitTime
        {
            get { return Get<Nullable<DateTime>>(Keys.LVTime); }
            set { Set<Nullable<DateTime>>(value, Keys.LVTime); }
        }
        public string LastVisitUrl
        {
            get { return Get<string>(Keys.LVUrl, string.Empty); }
            set { Set<string>(value, Keys.LVUrl); }
        }
        public string LastVisitUrlReferrer
        {
            get { return Get<string>(Keys.LVUrlReferrer, string.Empty); }
            set { Set<string>(value, Keys.LVUrlReferrer); }
        }
        public string LastVisitUserAgent
        {
            get { return Get<string>(Keys.LVAgent, string.Empty); }
            set { Set<string>(value, Keys.LVAgent); }
        }
        public string LastVisitUserHostName
        {
            get { return Get<string>(Keys.LVHostName, string.Empty); }
            set { Set<string>(value, Keys.LVHostName); }
        }
        public string LastVisitUserHostAddress
        {
            get { return Get<string>(Keys.LVHostAddress, string.Empty); }
            set { Set<string>(value, Keys.LVHostAddress); }
        }

        #endregion

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
            if (_SessionState[k] == null) return emptyValue;
            try
            {
                return (T)_SessionState[k];
            }
            catch (Exception ex)
            {
                if (exceptionIfInvalid) throw ex;
                return emptyValue;
            }
        }

        /// <summary>
        /// 设置会话变量
        /// </summary>
        public void Set<T>(T value, string key = null)
        {
            string k = Util.GenerateTypeInfo(typeof(T));
            k = string.IsNullOrEmpty(key) ? k : key;
            _SessionState[k] = value;
        }

        /// <summary>
        /// 查找键值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public bool Contains<T>()
        {
            string k = Util.GenerateTypeInfo(typeof(T));
            return Contains(k);
        }
        public bool Contains(string key)
        {
            if (_SessionState.Keys.Count == 0) return false;
            foreach (string k in _SessionState.Keys) if (k == key) return true;
            return false;
        }

        /// <summary>
        /// 清理所有会话变量
        /// </summary>
        public void RemoveAll() { _SessionState.RemoveAll(); }

        /// <summary>
        /// 去除 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        public void Remove(string key) { _SessionState.Remove(key); }
        public void Remove<T>()
        {
            string k = Util.GenerateTypeInfo(typeof(T));
            _SessionState.Remove(k);
        }

        private HttpSessionState _SessionState = null;
        public HttpSessionStateWrapper(
            HttpSessionState sessionState, DateTime currentTime)
        {
            _SessionState = sessionState;
            _SessionId = sessionState.SessionID;
            _CurrentTime = currentTime;
            _Settings = HttpContext.Current.Profile as PersonalSettings; // 获得Profile对象

            // TicketedObjectManager

            string key = D.Session.Keys.TicketObjectManager;
            _TKObjectManager = Get<TicketedObjectManager>(key);
            if (_TKObjectManager == null)
            {
                _TKObjectManager = new TicketedObjectManager();
                Set<TicketedObjectManager>(_TKObjectManager, key);
            }
            _TKObjectManager.Pulse();

            // ExtraThread

            key = D.Session.Keys.ExtraThread;
            _ExtraThread = Get<ExtraThreadWrapper>(key);
            if (_ExtraThread == null)
            {
                _ExtraThread = new ExtraThreadWrapper();
                Set<ExtraThreadWrapper>(_ExtraThread, key);
            }

            // Cache

            key = D.Session.Keys.Cache;
            _Cache = Get<TypedHashtable>(key);
            if (_Cache == null)
            {
                _Cache = new TypedHashtable();
                Set<TypedHashtable>(_Cache, key);
            }
        }

        /// <summary>
        /// 建立事件机制，让外部执行脏的对应操作
        /// </summary>
        public event Action<Types> Dirty = null;

        /// 设脏
        /// </summary>
        /// <param name="section"></param>
        public void SetDirty(Types section, bool value = true) { _Dirties[section] = value; }

        /// <summary>
        /// 全部设脏标记
        /// </summary>
        public void SetAllDirty()
        {
            _Dirties.Select(d => d.Key)
                .ToList().ForEach(k => _Dirties[k] = true);
        }

    }
}