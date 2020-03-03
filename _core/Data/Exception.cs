using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace eTaxi
{ 
    /// <summary>
    /// 实体异常（在操作及执行实体相关的增删改和业务操作过程中发生的异常）
    /// </summary>
    public class DTException : Exception
    {
        protected bool _Enumed = false;
        public bool Enumed { get { return _Enumed; } }

        protected object _Value = null;
        public object Value { get { return _Value; } }

        public DTException(string message, Action<DataSetter> set = null)
            : base(message) { if (set != null) set(new DataSetter(Data)); }
        public DTException(Action<DataSetter> set = null) 
            : base() { if (set != null) set(new DataSetter(Data)); }

        public class DataSetter
        {
            private IDictionary _Data = null;
            private object _Lock = new object();

            public DataSetter Record(string name, string message)
            {
                if (_Data == null) return this;
                lock (_Lock)
                {
                    if (_Data.Contains(name)) _Data[name] = message;
                    else _Data.Add(name, message);
                }
                return this;
            }
            public DataSetter(IDictionary data) { _Data = data; }
        }

        public static DTException<T> New<T>(T value, Action<DataSetter> set = null)
            where T : struct, IComparable, IConvertible, IFormattable { return new DTException<T>(value, set); }
        public static TTableRecordNotFound<T> NotFound<T>(string idOrMessage, Action<DataSetter> set = null)
            where T : class { return new TTableRecordNotFound<T>(idOrMessage, set); }
    }

    /// <summary>
    /// 可控的异常（需要配合 enum）
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class DTException<T> : DTException
        where T : struct, IComparable, IConvertible, IFormattable
    {
        public DTException(T value, Action<DataSetter> set = null)
            : base(value.ToString(), set)
        {
            _Enumed = true;
            _Value = value;
        }
    }

    /// <summary>
    /// 找不到相关的表格数据
    /// </summary>
    public class TTableRecordNotFound : DTException
    {
        protected string _TableName = string.Empty;
        public string TableName { get { return _TableName; } }
        public TTableRecordNotFound(Action<DataSetter> set = null)
            : base(set) { }
    }

    /// <summary>
    /// 找不到相关的表格数据
    /// </summary>
    public class TTableRecordNotFound<T> : TTableRecordNotFound where T : class
    {
        public TTableRecordNotFound(string idOrMessage, Action<DataSetter> set = null)
            : base(set)
        {
            _TableName = typeof(T).FullName;
            if (Data != null)
            {
                if (!Data.Contains("IdOrMessage")) Data.Add("IdOrMessage", idOrMessage);
                if (!Data.Contains("Table")) Data.Add("Table", _TableName);
            }
        }
    }

}
