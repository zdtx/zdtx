using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data.Common;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Reflection;

using LinqKit;
using Microsoft.Practices.Unity;
using D = eTaxi.Definitions;

namespace eTaxi.L2SQL
{
    /// <summary>
    /// 实现服务调用接口返回类型
    /// </summary>
    public class CallResult
    {
        private string _Key = string.Empty;
        public string Key
        {
            get { return _Key; }
        }

        public object _ReturnValue;
        public object ReturnValue
        {
            get { return _ReturnValue; }
        }

        private List<CallResult> _Returns = new List<CallResult>();
        public List<CallResult> Returns
        {
            get { return _Returns; }
        }

        public CallResult AddResult(CallResult anotherResult)
        {
            return AddReturn(anotherResult.Key, anotherResult.ReturnValue);
        }

        public CallResult AddReturn(string key, object returnValue)
        {
            _Returns.Add(new CallResult(key, returnValue));
            return this;
        }

        public CallResult() : this(string.Empty, new object()) { }
        public CallResult(string key, object returnValue)
        {
            _Key = key;
            _ReturnValue = returnValue;
        }

        public static CallResult GetReturn(
            CallResult initReturn, string key, object returnValue)
        {
            if (initReturn != null) return initReturn.AddReturn(key, returnValue);
            return new CallResult(key, returnValue);
        }
    }

    /// <summary>
    /// 服务作为算法实现的一个Host，必定要做最广泛的上下文支持
    /// 在Linq的实现（ServiceBase），埋入一个派生服务方法
    /// </summary>
    /// <typeparam name="TContext">数据上下文</typeparam>
    /// <typeparam name="T">实体类型（接口）</typeparam>
    public abstract class ServiceBase
    {
        protected IConnectionManagerEx _Manager;
        protected DbConnection _Connection;
        protected IUserSession _CurrentSession;
        protected DateTime _CurrentTime;
        protected TypedHashtable _Cache;
        protected virtual string[] _AllowedServices { get { return new string[] { }; } }
        protected virtual bool _BanAll { get { return false; } }

        /// <summary>
        /// 派生其他服务用作算法嵌入
        /// </summary>
        public TService CreateService<TService>()
        {
            if (_BanAll) throw new Exception("本服务不允许连环创建其他服务。");
            TService service = Host.Container.Resolve<TService>();
            string name = typeof(TService).Name;
            if (service == null)
                throw new Exception("服务 '" + name + "' 找不到，请检查是否已经注册到 Plugger 。");
            if (_AllowedServices.Length > 0 && !_AllowedServices.Contains(name))
                throw new Exception("服务 '" + name + "' 可能归属不同数据库，在本服务被禁止连环创建。");
            if (service is ServiceBase)
            {
                ServiceBase baseService = service as ServiceBase;
                baseService.Initialize(_CurrentSession, _CurrentTime, _Cache);
            }
            return service;
        }

        /// <summary>
        /// 服务接口的元创建和调用
        /// </summary>
        public object CreateService(Type serviceType)
        {
            if (_BanAll) throw new Exception("本服务不允许连环创建其他服务。");
            object service = Host.Container.Resolve(serviceType);
            string name = serviceType.Name;
            if (service == null)
                throw new Exception("服务 '" + name + "' 找不到，请检查是否已经注册到 Plugger 。");
            if (_AllowedServices.Length > 0 && !_AllowedServices.Contains(name))
                throw new Exception("服务 '" + name + "' 可能归属不同数据库，在本服务被禁止连环创建。");
            if (service is ServiceBase)
            {
                ServiceBase baseService = service as ServiceBase;
                baseService.Initialize(_CurrentSession, _CurrentTime, _Cache);
            }
            return service;
        }

        /// <summary>
        /// 服务标准化的通用实现
        /// </summary>
        public void Initialize(IUserSession session, DateTime currentTime, TypedHashtable cachingStates)
        {
            _CurrentSession = session;
            _CurrentTime = currentTime;
            _Cache = cachingStates;
        }

        public DbConnection Connection { get { return _Connection; } }
        public IConnectionManagerEx GetManager() { return _Manager; }
        public abstract void Dispose();

        public ServiceBase(IConnectionManagerEx manager)
        {
            _Manager = manager;
            _Manager.TransactionOpened += new Action<DbTransaction>(manager_TransactionOpened);
            _Manager.TransactionClosed += new Action(manager_TransactionClosed);
            _Connection = _Manager.Connection;
        }

        protected abstract void manager_TransactionClosed();
        protected abstract void manager_TransactionOpened(DbTransaction trans);
    }

    public abstract class ServiceBase<TContext> : ServiceBase where TContext : DataContextEx
    {
        private TContext _Context;
        public TContext Context { get { return _Context; } }

        private Dictionary<Type, object> _Repositories = new Dictionary<Type, object>();
        public RepositoryBase<T, TContext> Store<T>() where T : TBObject, new()
        {
            if (_Repositories.ContainsKey(typeof(T)))
                return _Repositories[typeof(T)] as RepositoryBase<T, TContext>;
            RepositoryBase<T, TContext> repository =
                new RepositoryBase<T, TContext>(Context);
            _Repositories.Add(typeof(T), repository);
            return repository;
        }

        public override void Dispose() { _Context.Dispose(); }
        public virtual CallResult SynStore()
        {
            string serviceName = GetType().Name;
            CallResult result = new CallResult(serviceName, true);

#if DEBUG
            ChangeSet changes = _Context.GetChangeSet();
            result.AddReturn(serviceName + "." + D.CURD.Create, changes.Inserts);
            result.AddReturn(serviceName + "." + D.CURD.Update, changes.Updates);
            result.AddReturn(serviceName + "." + D.CURD.Delete, changes.Deletes);
#endif

            _Context.SubmitChanges();
            return result;
        }

        ~ServiceBase() { try { Dispose(); } catch { } }
        public ServiceBase(IConnectionManagerEx manager, bool trackingEnabled = true)
            : base(manager) { _Context = _CreateContext<TContext>(trackingEnabled); }

        /// <summary>
        /// 创建不同于当前 Context 其他 Context
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        protected T _CreateContext<T>(bool trackingEnabled = true) where T : DataContextEx
        {
            T context = (T)
                Activator.CreateInstance(typeof(T), _Connection);
            context.ObjectTrackingEnabled = trackingEnabled;
            _Manager.RegisterContext(context);
            return context;
        }

        protected override void manager_TransactionClosed()
        {
            if (_Context.Transaction != null) _Context.Transaction = null;
        }

        protected override void manager_TransactionOpened(DbTransaction trans)
        {
            if (_Context.Transaction == null) _Context.Transaction = trans;
        }
    
    }

}