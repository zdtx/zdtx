using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Routing;
using Microsoft.Practices.Unity;

namespace eTaxi.Web
{
    /// <summary>
    /// 扩展生存管理对象定义
    /// </summary>
    public abstract class LifetimeManagerEx : LifetimeManager, IDisposable
    {
        protected String _Key = string.Empty;

        ~LifetimeManagerEx()
        {
            this.Dispose(false);
        }

        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(Boolean disposing)
        {
            this.RemoveValue();
        }

        protected void DisposeValue(Object value)
        {
            if (value is IDisposable) (value as IDisposable).Dispose();
        }

        public LifetimeManagerEx()
        {
            _Key = Guid.NewGuid().ToISFormatted();
        }
        public LifetimeManagerEx(string key)
        {
            _Key = key;
        }
    }

    /// <summary>
    /// 用于应用程序
    /// </summary>
    public sealed class ApplicationLifetimeManager : LifetimeManagerEx
    {
        public override Object GetValue()
        {
            if (HttpContext.Current != null)
            {
                HttpContext.Current.Application.Lock();
                Object value = HttpContext.Current.Application[_Key];
                HttpContext.Current.Application.UnLock();
                return (value);
            }
            else
            {
                return (null);
            }
        }

        public override void RemoveValue()
        {
            if (HttpContext.Current != null)
            {
                HttpContext.Current.Application.Lock();
                this.DisposeValue(HttpContext.Current.Application[_Key]);
                HttpContext.Current.Application.Remove(_Key);
                HttpContext.Current.Application.UnLock();
            }
        }

        public override void SetValue(Object newValue)
        {
            if (HttpContext.Current != null)
            {
                HttpContext.Current.Application.Lock();
                HttpContext.Current.Application[_Key] = newValue;
                HttpContext.Current.Application.UnLock();
            }
        }

        public ApplicationLifetimeManager() : base() { }
        public ApplicationLifetimeManager(string key) : base(key) { }
    }

    public sealed class SessionLifetimeManager : LifetimeManagerEx
    {
        public override Object GetValue()
        {
            if ((HttpContext.Current != null) && (HttpContext.Current.Session != null))
            {
                return (HttpContext.Current.Session[_Key]);
            }
            else
            {
                return (null);
            }
        }

        public override void RemoveValue()
        {
            if ((HttpContext.Current != null) && (HttpContext.Current.Session != null))
            {
                this.DisposeValue(HttpContext.Current.Session[_Key]);
                HttpContext.Current.Session.Remove(_Key);
            }
        }

        public override void SetValue(Object newValue)
        {
            if ((HttpContext.Current != null) && (HttpContext.Current.Session != null))
            {
                HttpContext.Current.Session[_Key] = newValue;
            }
        }

        public SessionLifetimeManager() : base() { }
        public SessionLifetimeManager(string key) : base(key) { }
    }

    /// <summary>
    /// 用于请求
    /// </summary>
    public sealed class RequestLifetimeManager : LifetimeManagerEx
    {
        public override Object GetValue()
        {
            if (HttpContext.Current != null)
            {
                return (HttpContext.Current.Items[_Key]);
            }
            else
            {
                return (null);
            }
        }

        public override void RemoveValue()
        {
            if (HttpContext.Current != null)
            {
                this.DisposeValue(HttpContext.Current.Items[_Key]);
                HttpContext.Current.Items.Remove(_Key);
            }
        }

        public override void SetValue(Object newValue)
        {
            if (HttpContext.Current != null)
                HttpContext.Current.Items[_Key] = newValue;
        }

        public RequestLifetimeManager() : base() { }
        public RequestLifetimeManager(string key) : base(key) { }
    }

    /// <summary>
    /// 处理请求处理模块运作的多线程场景
    /// </summary>
    public sealed class RequestLifetimeManagerModule : IHttpModule
    {
        [ThreadStatic]
        private static List<WeakReference> requestItems = new List<WeakReference>();
        private static readonly Object syncRoot = new Object();
        public void Dispose() { }
        public void Init(HttpApplication context) { context.EndRequest += this.OnEndRequest; }
        private void OnEndRequest(Object sender, EventArgs args) { this.RemoveRequestItems(); }
        private void RemoveRequestItems()
        {
            lock (syncRoot)
            {
                foreach (WeakReference r in requestItems)
                {
                    if (r.IsAlive == true)
                    {
                        if (r.Target is IDisposable)
                        {
                            (r.Target as IDisposable).Dispose();
                        }
                    }
                }

                requestItems.Clear();
            }
        }
        internal static void AddRequestValue(Object value)
        {
            lock (syncRoot)
            {
                requestItems.Add(new WeakReference(value));
            }
        }
    }

}
