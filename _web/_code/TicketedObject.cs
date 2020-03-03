using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace eTaxi
{
    /// <summary>
    /// 为挂到对象的类建立一个 ticket 体系，支持：
    /// 1. 取一次或多次则消亡
    /// 2. 按既定的时间消亡
    /// 3. 按程序手动去消亡
    /// </summary>
    public abstract class TicketedObject
    {
        /// <summary>
        /// 消亡策略
        /// </summary>
        public enum StrategyEnum
        {
            Single, Counter, Timer, Manual
        }

        protected DateTime _StartTime = DateTime.Now;
        protected Guid _Id = Guid.Empty;
        public Guid Id { get { return _Id; } }
        private StrategyEnum _Strategy = StrategyEnum.Counter;
        public StrategyEnum Strategy
        {
            get { return _Strategy; }
            set { _Strategy = value; }
        }

        private int _Counter = 1;
        public int Counter
        {
            get { return _Counter; }
            set { _Counter = value; }
        }

        private TimeSpan _ValidPeriod = TimeSpan.Zero;
        public TimeSpan ValidPeriod
        {
            get { return _ValidPeriod; }
            set { _ValidPeriod = value; }
        }

        public bool Removable()
        {
            switch (_Strategy)
            {
                case StrategyEnum.Counter:
                    if (_Counter <= 0) return true;
                    break;
                case StrategyEnum.Timer:
                    if (_StartTime.Add(_ValidPeriod) < DateTime.Now) return true;
                    break;
            }
            return false;
        }

        public abstract object GetObject();
        public TicketedObject(Guid id) { _Id = id; }
    }

    public class TicketedObject<T> : TicketedObject
    {
        private T _Object = default(T);
        public override object GetObject() { return Get(); }
        public T Get()
        {
            if (Strategy == StrategyEnum.Counter) Counter--;
            return _Object;
        }
        public TicketedObject(T obj, Guid id) : base(id) { _Object = obj; }
        public TicketedObject(T obj) : this(obj, Guid.NewGuid()) { }
    }

    /// <summary>
    /// 管理器
    /// </summary>
    public class TicketedObjectManager : IDisposable
    {
        private object _Locker = new object();
        private TypedHashtable _Data = new TypedHashtable();

        /// <summary>
        /// 注册单例（每次注册将删除前一实例）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        /// <param name="id"></param>
        public void RegSingle<T>(T obj, Guid id)
        {
            if (_Data.Contains(id.ToISFormatted())) _Data.Remove(id.ToISFormatted());
            TicketedObject<T> tObject = new TicketedObject<T>(obj, id)
            {
                Strategy = TicketedObject.StrategyEnum.Single
            };
            lock (_Locker) { _Data.Add<TicketedObject<T>>(tObject, id.ToISFormatted()); }
        }

        /// <summary>
        /// 注册按次数获取的
        /// </summary>
        public Guid RegCounter<T>(T obj, int count = 1)
        {
            TicketedObject<T> tObject = new TicketedObject<T>(obj)
            {
                Strategy = TicketedObject.StrategyEnum.Counter,
                Counter = count
            };
            lock (_Locker) { _Data.Add<TicketedObject<T>>(tObject, tObject.Id.ToISFormatted()); }
            return tObject.Id;
        }

        /// <summary>
        /// 按时间获取
        /// </summary>
        public Guid RegTimer<T>(T obj) { return RegTimer<T>(obj, TimeSpan.FromMinutes(10)); }
        public Guid RegTimer<T>(T obj, TimeSpan ts)
        {
            TicketedObject<T> tObject = new TicketedObject<T>(obj)
            {
                Strategy = TicketedObject.StrategyEnum.Timer,
                ValidPeriod = ts
            };
            lock (_Locker) { _Data.Add<TicketedObject<T>>(tObject, tObject.Id.ToISFormatted()); }
            return tObject.Id;
        }

        /// <summary>
        /// 注册永久
        /// </summary>
        public Guid RegManual<T>(T obj)
        {
            TicketedObject<T> tObject = new TicketedObject<T>(obj) { Strategy = TicketedObject.StrategyEnum.Manual };
            lock (_Locker) { _Data.Add<TicketedObject<T>>(tObject, tObject.Id.ToISFormatted()); }
            return tObject.Id;
        }

        /// <summary>
        /// 获取对象
        /// </summary>
        public T Get<T>(Guid id)
        {
            Pulse();
            if (!_Data.Contains(id.ToISFormatted())) return default(T);
            T obj = _Data.Get<TicketedObject<T>>(id.ToISFormatted()).Get();
            Pulse();
            return obj;
        }

        /// <summary>
        /// 获取对象（通用）
        /// </summary>
        public object Get(Guid id)
        {
            Pulse();
            if (!_Data.Contains(id.ToISFormatted())) return null;
            TicketedObject tObj = _Data[id.ToISFormatted()] as TicketedObject;
            object obj = tObj.GetObject();
            Pulse();
            return obj;
        }

        /// <summary>
        /// 去除对象
        /// </summary>
        /// <param name="id"></param>
        public void Remove(Guid id) { _Data.Remove(id.ToISFormatted()); }

        /// <summary>
        /// 巡检
        /// </summary>
        public void Pulse()
        {
            if (_Data.Count == 0) return;
            lock (_Locker)
            {
                List<object> deleted = new List<object>();
                foreach (DictionaryEntry de in _Data)
                    if (de.Value is TicketedObject)
                    {
                        TicketedObject tObj = de.Value as TicketedObject;
                        if (tObj.Removable()) deleted.Add(de.Key);
                    }
                deleted.ForEach(key => _Data.Remove(key));
            }
        }

        public void Dispose() { _Data.Clear(); }
    }
}