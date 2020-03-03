using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Linq;
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
    /// 表格类定义
    /// </summary>
    [Serializable]
    public abstract class TBObject
    {
        /// <summary>
        /// 修改类型（三元组）
        /// </summary>
        public enum ModiType
        {
            Create = 1,
            Update = 0,
            Delete = -1
        }

        /// <summary>
        /// 修改情况
        /// </summary>
        public class Modification
        {
            /// <summary>
            /// 会话 Id
            /// </summary>
            public Guid SessionId { get { return _SessionId; } }
            private Guid _SessionId = Guid.NewGuid();
            /// <summary>
            /// 类（表格）名字
            /// </summary>
            public string MetaInfo { get { return _MetaInfo; } }
            private string _MetaInfo = string.Empty;
            /// <summary>
            /// 标识唯一行的键值
            /// </summary>
            public string Key { get { return _Key; } }
            private string _Key = string.Empty;
            /// <summary>
            /// 类型
            /// </summary>
            public ModiType Type { get { return _Type; } }
            private ModiType _Type = ModiType.Update;
            /// <summary>
            /// 修改的字段名字
            /// </summary>
            public string Name { get { return _Name; } }
            private string _Name = string.Empty;
            /// <summary>
            /// 修改前
            /// </summary>
            public string Pre { get { return _Pre; } }
            private string _Pre;
            /// <summary>
            /// 修改后
            /// </summary>
            public string Post { get { return _Post; } }
            private string _Post;
            public Modification(string metaInfo, string key, ModiType type, string name = null, string pre = null, string post = null) :
                this(Guid.NewGuid(), metaInfo, key, type, name, pre, post) { }
            public Modification(Guid sessionId,
                string metaInfo, string key, ModiType type, string name = null, string pre = null, string post = null)
            {
                _SessionId = sessionId;
                _MetaInfo = metaInfo;
                _Key = key;
                _Type = type;
                _Name = name ?? string.Empty;
                _Pre = pre ?? string.Empty;
                _Post = post ?? string.Empty;
            }
        }

        public abstract void Snap();
        public abstract bool Traceable();
    }

    /// <summary>
    /// 表格类定义（用于 Linq 界定的类的通用行为
    /// </summary>
    [Serializable]
    public abstract class TBObject<T> : TBObject where T : class, new()
    {
        /// <summary>
        /// 克隆本对象
        /// </summary>
        /// <param name="handle"></param>
        /// <returns></returns>
        public T Clone(Action<T> handle = null)
        {
            T newObj = Activator.CreateInstance<T>();
            this.FlushTo(newObj);
            if (handle != null) handle(newObj);
            return newObj;
        }

        private T _Shadow = null;
        public override void Snap() { _Shadow = Clone(); }
        public override bool Traceable() { return _Shadow != null; }
        public T GetShot() { return _Shadow; }

        public List<TBObject.Modification> GetModifications(string metaInfo, string masterKey, params string[] keys)
        {
            if (_Shadow == null) throw new Exception("Snapshot not ready, please call 'Snap' first.");
            List<TBObject.Modification> result = new List<Modification>();
            typeof(T).GetProperties().ForEach(p =>
            {
                object current = p.GetValue(this, null);
                object previous = p.GetValue(_Shadow, null);

                // 组合键
                string compoundKey = masterKey;
                if (keys.Length > 0) keys.ForEach(k => compoundKey = compoundKey + "." + k);

                // 插入
                Guid sessionId = Guid.NewGuid();
                Action<string, string, string> _add =
                    (name, pre, post) => result.Add(new Modification(
                        sessionId, metaInfo, compoundKey, ModiType.Update, name, pre, post));
                if (current == null && previous != null) _add(p.Name, previous.ToStringEx(), current.ToStringEx());
                if (current != null && previous == null) _add(p.Name, previous.ToStringEx(), current.ToStringEx());
                if (current != null && previous != null)
                    if (!current.Equals(previous)) _add(p.Name, previous.ToStringEx(), current.ToStringEx());
            });

            return result;
        }
        
        public bool BeenModified<TField>(Expression<Func<T, TField>> propertiesGet)
        {
            if (_Shadow == null) throw new Exception("Snapshot not ready, please call 'Snap' first.");
            string[] names = Exp<T>.Properties(propertiesGet);
            foreach (string n in names)
            {
                PropertyInfo property = typeof(T).GetProperty(n);
                object current = property.GetValue(this, null);
                object previous = property.GetValue(_Shadow, null);
                if (current == null && previous != null) return true;
                if (current != null && previous == null) return true;
                if (current != null && previous != null)
                    if (!current.Equals(previous)) return true;
            }
            return false;
        }
    }
}