using System;
using System.IO;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data.Linq.SqlClient;

namespace eTaxi
{
    public static class DataContextExtension
    {
        /// <summary>
        /// 主更新操作，Linq2SQL 的更新暂代方案，不运用时间戳进行共同编辑冲突
        /// </summary>
        public static int ExecuteUpdate(this DataContext context,
            object dataObject, string[] fieldsToUpdate)
        {
            MetaTable table = context.Mapping.GetTable(dataObject.GetType());
            List<string> identities = new List<string>();

            // 获得主键字段
            foreach (MetaDataMember member in
                table.RowType.IdentityMembers) identities.Add(member.Name);
            return ExecuteUpdate(context, dataObject, identities.ToArray(), fieldsToUpdate);
        }
        public static int ExecuteUpdate(this DataContext context,
            object dataObject, string[] keyMatchFields, string[] fieldsToUpdate)
        {
            if (keyMatchFields.Length == 0)
                throw new ArgumentException("at least one field should be applied on filtering", "keyMatchFields");

            MetaTable table = context.Mapping.GetTable(dataObject.GetType());
            PropertyInfo[] properties = dataObject.GetType().GetProperties();
            Hashtable identities = new Hashtable();
            Hashtable updates = new Hashtable();

            // 获得键字段
            foreach (string keyField in keyMatchFields)
            {
                PropertyInfo property =
                    properties.Single(p => p.Name == keyField);
                if (property == null)
                    throw new ArgumentException("field not found: " + keyField);

                MetaDataMember member =
                    table.RowType.PersistentDataMembers.SingleOrDefault(
                    m => m.Name == property.Name);
                if (member == null)
                    throw new ArgumentException("property not bound with datamenber: " + property.Name);

                identities.Add(member.MappedName, property.GetValue(dataObject, null));
            }

            // 检查需要更新的表格信息
            foreach (string field in fieldsToUpdate)
            {
                PropertyInfo property =
                    properties.SingleOrDefault(p => p.Name == field);
                if (property == null)
                    throw new ArgumentException("field not found: " + field);

                MetaDataMember member =
                    table.RowType.PersistentDataMembers.SingleOrDefault(
                    m => m.Name == property.Name);
                if (member == null)
                    throw new ArgumentException("property not bound with datamenber: " + property.Name);

                updates.Add(member.MappedName, property.GetValue(dataObject, null));
            }

            // 没字段需要更新，则返回
            if (identities.Count == 0 || updates.Count == 0) return 0;

            StringBuilder sb = new StringBuilder();
            ArrayList parameters = new ArrayList();

            int parmOrder = 0;

            sb.Append(string.Format("UPDATE [{0}] SET ", table.TableName));
            bool comma = false;
            foreach (DictionaryEntry de in updates)
            {
                if (comma) sb.Append(", ");
                if (de.Value == null)
                {
                    sb.Append(string.Format("[{0}] = NULL", de.Key.ToString()));
                    comma = true;
                }
                else
                {
                    sb.Append(string.Format(
                        "[{0}] = {{{1}}}", de.Key.ToString(), parmOrder.ToString()));
                    parameters.Add(de.Value);
                    comma = true;
                    parmOrder++;
                }
            }

            sb.Append(" WHERE 1=1");
            foreach (DictionaryEntry de in identities)
            {
                if (de.Value == null)
                {
                    sb.Append(string.Format(" AND [{0}] IS NULL", de.Key.ToString()));
                }
                else
                {
                    sb.Append(string.Format(
                        " AND [{0}]={{{1}}}", de.Key.ToString(), parmOrder.ToString()));
                    parameters.Add(de.Value);
                    parmOrder++;
                }
            }

            return context.ExecuteCommand(sb.ToString(), parameters.ToArray());
        }

        /// <summary>
        /// 删除含有主键信息的 dataObject（仅一个或0个）
        /// </summary>
        public static int ExecuteDelete(this DataContext context, object dataObject)
        {
            string[] fields = new string[] { };
            return ExecuteDeleteAll(context, dataObject, fields);
        }

        /// <summary>
        /// 删除含部分主键信息的 dataObject（必须指定系统匹配那个字段的值）
        /// </summary>
        public static int ExecuteDeleteAll<T, TFields>(this DataContext context,
            T dataObject, Expression<Func<T, TFields>> fieldSelector)
        {
            return ExecuteDeleteAll(context, dataObject, Exp<T>.Properties<TFields>(fieldSelector));
        }
        public static int ExecuteDeleteAll(this DataContext context,
            object dataObject, string[] fields)
        {
            MetaTable table = context.Mapping.GetTable(dataObject.GetType());
            PropertyInfo[] properties = dataObject.GetType().GetProperties();
            Hashtable matches = new Hashtable();

            if (fields.Length == 0)
            {
                foreach (MetaDataMember member in table.RowType.IdentityMembers)
                {
                    PropertyInfo property =
                        properties.Single(p => p.Name == member.Name);
                    matches.Add(member.MappedName, property.GetValue(dataObject, null));
                }
            }
            else
            {
                foreach (string field in fields)
                {
                    PropertyInfo property =
                        properties.SingleOrDefault(p => p.Name == field);
                    if (property == null)
                        throw new ArgumentException("field not found: " + field);

                    MetaDataMember member =
                        table.RowType.PersistentDataMembers.SingleOrDefault(
                        m => m.Name == property.Name);
                    if (member == null)
                        throw new ArgumentException("property not bound with datamenber: " + property.Name);

                    matches.Add(member.MappedName, property.GetValue(dataObject, null));
                }
            }

            if (matches.Count == 0) return 0;

            StringBuilder sb = new StringBuilder();
            ArrayList parameters = new ArrayList();

            int parmOrder = 0;

            sb.Append(string.Format("DELETE [{0}] WHERE 1=1 ", table.TableName));
            foreach (DictionaryEntry de in matches)
            {
                sb.Append(string.Format(
                    "AND [{0}]={{{1}}} ", de.Key.ToString(), parmOrder.ToString()));
                parameters.Add(de.Value);
                parmOrder++;
            }

            return context.ExecuteCommand(sb.ToString(), parameters.ToArray());
        }

        public static bool Exists(this DataContext context,
            object dataObject)
        {
            MetaTable table = context.Mapping.GetTable(dataObject.GetType());
            PropertyInfo[] properties = dataObject.GetType().GetProperties();
            var qNames =
                from m in table.RowType.IdentityMembers
                select m.Name;
            var qValues =
                from p in properties
                where qNames.Any(n => n == p.Name)
                select p.GetValue(dataObject, null);
            return Exists(context, dataObject, qNames.ToArray(), qValues.ToArray());
        }
        public static bool Exists(this DataContext context,
            object dataObject, string fieldName)
        {
            return Exists(context, dataObject, new string[] { fieldName });
        }
        public static bool Exists(this DataContext context,
            object dataObject, string fieldName, object value)
        {
            return Exists(context, dataObject,
                new string[] { fieldName }, new object[] { value });
        }
        public static bool Exists(this DataContext context,
            object dataObject, string[] fields)
        {
            PropertyInfo[] properties = dataObject.GetType().GetProperties();
            var qValues =
                from p in properties
                where fields.Any(f => f == p.Name)
                select p.GetValue(dataObject, null);
            return Exists(context, dataObject, fields, qValues.ToArray());
        }
        public static object[] Exists(this DataContext context,
            object[] dataObjects, string fieldName)
        {
            ArrayList alReturn = new ArrayList();
            foreach (object o in dataObjects)
                if (Exists(context, o, fieldName)) alReturn.Add(o);
            return alReturn.ToArray();
        }
        public static object[] Exists(this DataContext context,
            object[] dataObjects, string fieldName, object value)
        {
            ArrayList alReturn = new ArrayList();
            foreach (object o in dataObjects)
                if (Exists(context, o, fieldName, value)) alReturn.Add(o);
            return alReturn.ToArray();
        }
        public static object[] Exists(this DataContext context,
            object[] dataObjects, string[] fields)
        {
            ArrayList alReturn = new ArrayList();
            foreach (object o in dataObjects)
                if (Exists(context, o, fields)) alReturn.Add(o);
            return alReturn.ToArray();
        }
        public static bool Exists(this DataContext context,
            object dataObject, string[] fields, object[] values)
        {
            MetaTable table = context.Mapping.GetTable(dataObject.GetType());
            //检查值是否和字段配对
            if (fields.Length != values.Length)
                throw new ArgumentException("length of fields and values mismatched..");
            string sql = string.Format(
                "SELECT 1 FROM [{0}] WHERE 1=1", table.TableName);
            int index = 0;
            foreach (string fieldName in fields)
            {
                MetaDataMember member =
                    table.RowType.PersistentDataMembers.Single(m => m.Name == fieldName);
                sql += string.Format(" AND [{0}] = {{{1}}}", member.MappedName, index.ToString());
                index++;
            }
            sql = string.Format(
                "IF EXISTS ({0}) SELECT 1 ELSE SELECT 0", sql);
            int count =
                context.ExecuteQuery<int>(sql, values).Single();
            return (count > 0);
        }

        //判断字段的值是否存在 如果是插入id赋值-1或者new Guid,如果是修改id赋值 要修改项的值
        public static bool IsFieldExist(this DataContext context, object dataObject, string fieldName,
            object fieldValue, Guid id, string where)
        {
            MetaTable table = context.Mapping.GetTable(dataObject.GetType());

            if (!string.IsNullOrEmpty(where))
                where = @" and " + where;
            var sql = string.Format(@"select count(*) from {0} as o where o.{1}='{2}' and o.fUniqueID<>'{3}'" + where,
                table.TableName,
                fieldName,
                fieldValue, id);

            int count =
               context.ExecuteQuery<int>(sql).Single();
            return (count > 0);
        }

        public static int ExecuteInsert(this DataContext context,
            object dataObject, string[] fields)
        {
            MetaTable table = context.Mapping.GetTable(dataObject.GetType());
            PropertyInfo[] properties = dataObject.GetType().GetProperties();
            Hashtable identities = new Hashtable();
            Hashtable inserts = new Hashtable();

            // 先取得键字段
            foreach (MetaDataMember member in table.RowType.IdentityMembers)
            {
                PropertyInfo property =
                    properties.Single(p => p.Name == member.Name);
                identities.Add(member.MappedName, property.GetValue(dataObject, null));
            }

            if (identities.Count == 0)
                throw new ArgumentException("identity fields not found.");

            // get select part
            foreach (string field in fields)
            {
                PropertyInfo property =
                    properties.SingleOrDefault(p => p.Name == field);
                if (property == null)
                    throw new ArgumentException("field not found: " + field);

                MetaDataMember member =
                    table.RowType.PersistentDataMembers.SingleOrDefault(
                    m => m.Name == property.Name);
                if (member == null)
                    throw new ArgumentException("property not bound with datamenber: " + property.Name);

                if (!
                    identities.ContainsKey(member.MappedName))
                    inserts.Add(member.MappedName, property.GetValue(dataObject, null));
            }

            // reduce purposeless update or no fields
            if (identities.Count == 0 || inserts.Count == 0) return 0;

            StringBuilder sb = new StringBuilder();
            ArrayList parameters = new ArrayList();

            int parmOrder = 0;

            sb.Append(string.Format(
                "INSERT INTO [{0}] ", table.TableName));
            string sqlSection = string.Empty;

            foreach (DictionaryEntry de in identities)
            {
                if (sqlSection.Length > 0) sqlSection += ", ";
                sqlSection += string.Format("[{0}]", de.Key.ToString());
            }

            foreach (DictionaryEntry de in inserts)
            {
                if (sqlSection.Length > 0) sqlSection += ", ";
                sqlSection += string.Format("[{0}]", de.Key.ToString());
            }

            sb.Append(string.Format("({0}) VALUES ", sqlSection));
            sqlSection = string.Empty;

            foreach (DictionaryEntry de in identities)
            {
                if (de.Value == null)
                    throw new ArgumentException("key field not feed with value: " + de.Key.ToString());

                if (sqlSection.Length > 0) sqlSection += ", ";
                sqlSection += string.Format("{{{0}}}", parmOrder.ToString());
                parameters.Add(de.Value);
                parmOrder++;
            }

            foreach (DictionaryEntry de in inserts)
            {
                if (sqlSection.Length > 0) sqlSection += ", ";
                if (de.Value == null)
                {
                    sqlSection += "NULL";
                }
                else
                {
                    sqlSection += string.Format("{{{0}}}", parmOrder.ToString());
                    parameters.Add(de.Value);
                    parmOrder++;
                }
            }

            sb.Append("(" + sqlSection + ")");
            return context.ExecuteCommand(sb.ToString(), parameters.ToArray());
        }

        /// <summary>
        /// 获取表格的具体信息
        /// </summary>
        public static MetaTable TableInfo<T>(this DataContext context)
            where T : eTaxi.L2SQL.TBObject { return context.Mapping.GetTable(typeof(T)); }
    }

}
