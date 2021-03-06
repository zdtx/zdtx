using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

using Microsoft.Practices.Unity;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi.Web
{
    public class BaseService : WebService
    {
        protected IDataConnectionManager _DataConnectionManager;
        protected CommonService _DTService = null;
        protected SystemSettings _Settings = new SystemSettings();
        protected DateTime _CurrentTime;

        protected T _DTContext<T>(bool readOnly = false) where T : DataContextEx { return _CreateContext<T, IDataConnectionManager>(true, readOnly); }
        private T _CreateContext<T, TManager>(bool isData, bool readOnly = false)
            where T : DataContextEx
            where TManager : IConnectionManagerEx
        {
            IConnectionManagerEx manager = Host.Container.Resolve<TManager>();
            T result = default(T);
            if (manager.Transaction == null && readOnly)
            {
                result = Activator.CreateInstance(typeof(T), manager.Connection) as T;
                result.ObjectTrackingEnabled = false;
                manager.RegisterContext(result);
                return result;
            }
            result = Activator.CreateInstance(typeof(T), manager.Connection) as T;
            result.Transaction = manager.Transaction;
            manager.RegisterContext(result);
            return result;
        }

        /// <summary>
        /// 需要执行事务的方法闭包
        /// </summary>
        /// <param name="dCon"></param>
        /// <param name="eCon"></param>
        /// <param name="handle"></param>
        /// <param name="exceptionHandle"></param>
        /// <returns></returns>
        protected bool _TransCall(
            Action handle, Action<Exception> exceptionHandle = null)
        {
            bool dataTransRequired = _DataConnectionManager.TrackingContextExists();
            DbTransaction dTrans = null;

            try
            {
                if (dataTransRequired) dTrans = _DataConnectionManager.StartTransaction();
                handle();
                if (dTrans != null && dTrans.Connection != null) dTrans.Commit();
                return true;
            }
            catch (Exception ex)
            {
                if (dTrans != null && dTrans.Connection != null) dTrans.Rollback();
                if (exceptionHandle != null) { exceptionHandle(ex); return false; }
                else throw ex;
            }
            finally
            {
                _DataConnectionManager.EndTransaction();
            }
        }

        public BaseService()
        {
            _DataConnectionManager = Host.Container.Resolve<IDataConnectionManager>();
            _DTService = new CommonService(_DataConnectionManager);
            _CurrentTime = DateTime.Now;
            _DTService.Initialize(null, _CurrentTime, Global.Cache);
        }

    }
}