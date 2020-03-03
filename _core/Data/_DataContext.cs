using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Data;
using System.Data.Common;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Reflection;
using System.ComponentModel;
using System.Text;

namespace eTaxi.L2SQL
{
    public partial class DataContextEx : DataContext
    {
        protected static MappingSource mappingSource = new AttributeMappingSource();

        public bool HasPendingInserts() { return GetChangeSet().Inserts.Count > 0; }
        public bool HasPendingUpdates() { return GetChangeSet().Updates.Count > 0; }
        public bool HasPendingDeletes() { return GetChangeSet().Deletes.Count > 0; }
        public bool HasPendingChanges() { return HasPendingInserts() || HasPendingUpdates() || HasPendingDeletes(); }

        public int CountInserts<T>() where T : TBObject { return GetChangeSet().Inserts.Count(o => o is T); }
        public int CountUpdates<T>() where T : TBObject { return GetChangeSet().Updates.Count(o => o is T); }
        public int CountDeletes<T>() where T : TBObject { return GetChangeSet().Deletes.Count(o => o is T); }
        public int CountChanges<T>() where T : TBObject
        {
            ChangeSet changes = GetChangeSet();
            return
                changes.Inserts.Count(o => o is T) +
                changes.Updates.Count(o => o is T) +
                changes.Deletes.Count(o => o is T);
        }

        public override void SubmitChanges(ConflictMode failureMode)
        {
            base.SubmitChanges(failureMode);
        }

        public void DiscardChanges<T>() where T : TBObject
        {
            DiscardInserts<T>();
            DiscardUpdates<T>();
            DiscardDeletes<T>();
        }

        public void DiscardUpdates<T>() where T : TBObject
        {
            IList<object> updates = GetChangeSet().Updates;
            if (updates.Count == 0) return;
            Table<T> table = GetTable<T>();
            for (int i = 0; i < updates.Count; i++)
            {
                object u = updates[i];
                if (u is T)
                {
                    u = table.GetOriginalEntityState(u as T);
                    u.FlushTo(updates[i]);
                }
            }
        }

        public void DiscardInserts<T>() where T : TBObject
        {
            IList<object> inserts = GetChangeSet().Inserts;
            if (inserts.Count == 0) return;
            Table<T> table = GetTable<T>();
            foreach (object i in inserts) if (i is T) table.DeleteOnSubmit(i as T);
        }

        public void DiscardDeletes<T>() where T : TBObject
        {
            IList<object> deletes = GetChangeSet().Deletes;
            if (deletes.Count == 0) return;
            Table<T> table = GetTable<T>();
            foreach (object d in deletes) if (d is T) table.InsertOnSubmit(d as T);
        }

        /// <summary>
        /// 生成单个表格记录的快速访问
        /// </summary>
        /// <typeparam name="T">表类</typeparam>
        /// <param name="obj">表对象（带键值）</param>
        /// <param name="fields">指定字段</param>
        /// <returns>true: 捞到了 false: 捞不到</returns>
        public bool Fill<T>(T obj, params string[] fields) where T : TBObject
        {
            Type t = typeof(T);
            MetaTable table = Mapping.GetTable(t);
            PropertyInfo[] properties = t.GetProperties();
            Dictionary<string, object> identities = new Dictionary<string, object>();
            Dictionary<string, object> selects = new Dictionary<string, object>();

            // 主键及值
            foreach (MetaDataMember member in table.RowType.IdentityMembers)
            {
                PropertyInfo property = properties.Single(p => p.Name == member.Name);
                identities.Add(member.MappedName, property.GetValue(obj, null));
            }

            // 其他字段
            string[] targetFields = (fields.Length > 0) ?
                fields : table.RowType.PersistentDataMembers.Select(m => m.MappedName).ToArray();
            foreach (string f in targetFields)
            {
                PropertyInfo property = properties.SingleOrDefault(p => p.Name == f);
                if (property == null)
                {
                    throw new ArgumentException("field not found: " + f);
                }
                else
                {
                    MetaDataMember member =
                        table.RowType.PersistentDataMembers.SingleOrDefault(
                        m => m.Name == property.Name);
                    if (member == null)
                        throw new ArgumentException("property not bound with datamenber: " + property.Name);
                    if (!
                        identities.ContainsKey(member.MappedName))
                        selects.Add(member.MappedName, property.GetValue(obj, null));
                }
            }

            // reduce purposeless update or no fields
            if (identities.Count == 0 || selects.Count == 0) return false;

            StringBuilder sb = new StringBuilder();
            DbCommand cmd = Connection.CreateCommand();

            sb.Append("select ");
            bool comma = false;
            foreach (var kv in selects)
            {
                if (comma) sb.Append(", ");
                sb.Append(string.Format("[{0}]", kv.Key.ToString()));
                comma = true;
            }

            sb.Append(string.Format(" from [{0}] where 1 = 1", table.TableName));
            foreach (var kv in identities)
            {
                if (kv.Value == null) throw new ArgumentException("key field value not set: " + kv.Key.ToString());
                sb.Append(string.Format(" and [{0}] = @P_{0}", kv.Key.ToString()));
                DbParameter p = cmd.CreateParameter();
                p.ParameterName = string.Format("@P_{0}", kv.Key.ToString());
                p.Value = kv.Value;
                cmd.Parameters.Add(p);
            }

            cmd.CommandText = sb.ToString();
            cmd.Transaction = Transaction;

            int result = 0;
            bool closed = false;
            if (Connection.State == ConnectionState.Closed) { closed = true; Connection.Open(); }
            DbDataReader reader = (closed) ?
                cmd.ExecuteReader(CommandBehavior.CloseConnection) : cmd.ExecuteReader();
            if (reader.HasRows)
                if (reader.Read())
                {
                    for (int i = 0; i < targetFields.Length; i++)
                    {
                        if (selects.Any(kv => kv.Key == targetFields[i]))
                        {
                            var select = selects.Single(s => s.Key == targetFields[i]);
                            PropertyInfo property = properties.Single(p => p.Name == targetFields[i]);
                            int ordinal = reader.GetOrdinal(select.Key);
                            if (property.PropertyType == typeof(Stream))
                            {
                                // TODO: .NET 4.5 支持
                                // property.SetValue(obj, reader.IsDBNull(ordinal) ? null : reader.GetStream(ordinal), null);
                            }
                            else
                            {
                                property.SetValue(obj, reader.IsDBNull(ordinal) ? null : reader.GetValue(ordinal), null);
                            }
                        }
                    }
                    result = 1;
                }
            reader.Close();
            return result > 0;
        }

        private Dictionary<Type, object> _Repositories = new Dictionary<Type, object>();
        public RepositoryBase<T, DataContextEx> Store<T>() where T : TBObject, new()
        {
            if (_Repositories.ContainsKey(typeof(T)))
                return _Repositories[typeof(T)] as RepositoryBase<T, DataContextEx>;
            RepositoryBase<T, DataContextEx> repository =
                new RepositoryBase<T, DataContextEx>(this);
            _Repositories.Add(typeof(T), repository);
            return repository;
        }

        public DataContextEx(IDbConnection connection) :
            base(connection, mappingSource)
        {

//#if DEBUG
            Log = new LinqDebugger();
//#endif

        }
    }
}
