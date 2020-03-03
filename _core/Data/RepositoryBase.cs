using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Linq;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Text.RegularExpressions;

namespace eTaxi.L2SQL
{
    public class RepositoryBase<T, TContext>
        where T : TBObject, new()
        where TContext : DataContextEx
    {
        //public class Updator<T> where T : TBObject
        //{
        //    public Updator(
        //}

        private TContext _Context;
        public RepositoryBase(TContext context) { _Context = context; }
        public Table<T> Table { get { return _Context.GetTable<T>(); } }

        public virtual void Create(T dataObject)
        {
            _Context.GetTable<T>().InsertOnSubmit(dataObject);
            _Context.SubmitChanges();
        }

        public virtual void CreateAll(T[] dataObjects)
        {
            if (dataObjects.Length == 0) return;
            foreach (T o in dataObjects) _Context.GetTable<T>().InsertOnSubmit(o);
            _Context.SubmitChanges();
        }

        public virtual int Delete(T dataObject)
        {
            int result = _Context.ExecuteDelete(dataObject);
            _Context.DiscardDeletes<T>();
            return result;
        }

        public virtual int Update(T dataObject, string[] fieldsToUpdate)
        {
            int result = _Context.ExecuteUpdate(dataObject, fieldsToUpdate);
            _Context.DiscardUpdates<T>();
            return result;
        }

        public virtual int Update<TFields>(T dataObject, Expression<Func<T, TFields>> fieldSelector)
        {
            return Update(dataObject, Exp<T>.Properties(fieldSelector));
        }

        public virtual int UpdateAll(T dataObject, string[] keyMatchFields, string[] fieldsToUpdate)
        {
            int result = _Context.ExecuteUpdate(dataObject, keyMatchFields, fieldsToUpdate);
            return result;
        }

        public virtual int UpdateAll<TKeys, TFields>(
            T dataObject, Expression<Func<T, TKeys>> keySelector, Expression<Func<T, TFields>> fieldSelector)
        {
            int result = _Context.ExecuteUpdate(dataObject,
                Exp<T>.Properties(keySelector), Exp<T>.Properties(fieldSelector));
            return result;
        }

        /// <summary>
        /// 明细表操作
        /// </summary>
        /// <typeparam name="T">细表类型</typeparam>
        /// <param name="objects">细表对象（多个）</param>
        /// <param name="retrieve">取得对象列表的附件条件</param>
        /// <param name="locate">如何根据对象获得另一个列表中的同一个对象</param>
        /// <param name="createTo">创建的时候</param>
        /// <param name="updateTo">更新的时候</param>
        public virtual int SynObjects(List<T> objects,
            Expression<Func<T, bool>> retrieve,
            Func<T, Func<T, bool>> locate,
            Action<T, T> createTo = null, Action<T, T> updateTo = null, Action<T[]> deleteHandle = null)
        {
            var store = new RepositoryBase<T, TContext>(_Context);
            List<T> dbObjects = store.RetrieveAll(retrieve).ToList();
            objects.ForEach(o =>
            {
                var old = dbObjects.SingleOrDefault(locate(o));
                if (old == null)
                {
                    old = new T();
                    o.FlushTo(old);
                    if (createTo != null) createTo(o, old);
                    _Context.GetTable<T>().InsertOnSubmit(old);
                }
                else
                {
                    old.Snap();
                    o.FlushTo(old);
                    if (updateTo != null) updateTo(o, old);
                }
            });
            int result = _Context.CountChanges<T>();
            _Context.SubmitChanges();
            T[] delete = dbObjects.Where(o => !objects.Any(locate(o))).ToArray();
            if (delete.Length > 0)
            {
                result += delete.Length;
                store.DeleteAll(delete);
                if (deleteHandle != null) deleteHandle(delete);
            }
            return result;
        }

        /// <summary>
        /// 对象同步操作（必须手动 submit，做分组而已）
        /// </summary>
        /// <param name="objects"></param>
        /// <param name="retrieve"></param>
        /// <param name="locate"></param>
        /// <param name="create"></param>
        /// <param name="update"></param>
        /// <param name="delete"></param>
        public virtual void SynObjects(List<T> objects,
            Expression<Func<T, bool>> retrieveExp,
            Func<T, Func<T, bool>> locate,
            Action<List<T>> create, Action<List<T>> update, Action<List<T>> delete, 
            Action<List<T>> retrieve = null)
        {
            var store = new RepositoryBase<T, TContext>(_Context);
            List<T> dbObjects = store.RetrieveAll(retrieveExp).ToList();
            if (retrieve != null) retrieve(dbObjects);
            List<T> created = new List<T>();
            List<T> updated = new List<T>();
            List<T> deleted = new List<T>();
            objects.ForEach(o =>
            {
                var old = dbObjects.SingleOrDefault(locate(o));
                if (old == null)
                {
                    old = new T();
                    o.FlushTo(old, c => created.Add(c));
                }
                else
                {
                    old.Snap();
                    o.FlushTo(old, u => updated.Add(u));
                }
            });
            int result = _Context.CountChanges<T>();
            deleted.AddRange(dbObjects.Where(o => !objects.Any(locate(o))));
            if (created.Count > 0 && create != null) create(created);
            if (updated.Count > 0 && update != null) update(updated);
            if (deleted.Count > 0 && delete != null) delete(deleted);
        }

        public virtual int DeleteAll(T[] dataObjects)
        {
            if (dataObjects.Length == 0) return 0;
            foreach (T o in dataObjects) _Context.GetTable<T>().DeleteOnSubmit(o);
            int result = _Context.CountDeletes<T>();
            _Context.SubmitChanges();
            return result;
        }

        //public virtual int DeleteAll<TFields>(T dataObject, Expression<Func<T, TFields>> fieldSelector)
        //{
        //    return _Context.ExecuteDeleteAll(
        //        dataObject, Exp<T>.Properties(fieldSelector));
        //}

        public virtual int DeleteAll(Expression<Func<T, bool>> selector)
        {
            string CONST_TABLE = "table";
            string CONST_ALIAS = "alias";
            string CONST_WHERE = "where";
            string pattern = string.Format(
                @"from\s*(\[dbo\]\.)*(\[*(?<{0}>\w+\d*)\]*)+\s*as\s*(\[*(?<{1}>\w+\d*)\]*)\s*where(?<{2}>.*)",
                CONST_TABLE, CONST_ALIAS, CONST_WHERE);
            var q = _Context.GetTable<T>().Where(selector);
            IDbCommand command = _Context.GetCommand(q);
            MatchCollection matches = Regex.Matches(
                command.CommandText, pattern, RegexOptions.Multiline | RegexOptions.IgnoreCase);
            if (matches == null || matches.Count == 0) return 0;
            Match m = matches[0];
            string table = m.Groups[CONST_TABLE].Value;
            string alias = m.Groups[CONST_ALIAS].Value;
            string where = m.Groups[CONST_WHERE].Value
                .Replace("[" + table + "].", string.Empty)
                .Replace(table + ".", string.Empty);
            List<object> parameters = new List<object>();
            foreach (IDataParameter p in command.Parameters)
            {
                where = where.Replace(alias, table);
                where = where.Replace(p.ParameterName, string.Format("{{{0}}}", parameters.Count.ToString()));
                parameters.Add(p.Value);
            }
            string sql = string.Format("DELETE FROM [{0}] WHERE {1}", table, where);
            return _Context.ExecuteCommand(sql, parameters.ToArray());
        }

        public T Retrieve(Expression<Func<T, bool>> selector, bool exceptionIfNotExists = false)
        {
            T tObject = _Context.GetTable<T>().Where(selector).SingleOrDefault();
            if (exceptionIfNotExists && tObject == null) throw DTException.NotFound<T>(selector.ToString());
            return tObject;
        }

        public IQueryable<T> RetrieveAll(Expression<Func<T, bool>> selector)
        {
            return _Context.GetTable<T>().Where(selector).AsQueryable();
        }

        public bool Exists(Expression<Func<T, bool>> selector)
        {
            string CONST_TABLE = "table";
            string CONST_ALIAS = "alias";
            string CONST_WHERE = "where";
            string pattern = string.Format(
                @"from\s*(\[dbo\]\.)*(\[*(?<{0}>\w+\d*)\]*)+\s*as\s*(\[*(?<{1}>\w+\d*)\]*)\s*where(?<{2}>.*)",
                CONST_TABLE, CONST_ALIAS, CONST_WHERE);
            var q = _Context.GetTable<T>().Where(selector);
            IDbCommand command = _Context.GetCommand(q);
            MatchCollection matches = Regex.Matches(
                command.CommandText, pattern, RegexOptions.Multiline | RegexOptions.IgnoreCase);
            if (matches == null || matches.Count == 0)
                throw new Exception("Query provider generated command not found");
            Match m = matches[0];
            string table = m.Groups[CONST_TABLE].Value;
            string alias = m.Groups[CONST_ALIAS].Value;
            string where = m.Groups[CONST_WHERE].Value
                .Replace("[" + table + "].", string.Empty)
                .Replace(table + ".", string.Empty);
            List<object> parameters = new List<object>();
            foreach (IDataParameter p in command.Parameters)
            {
                where = where.Replace(alias, table);
                where = where.Replace(p.ParameterName, string.Format("{{{0}}}", parameters.Count.ToString()));
                parameters.Add(p.Value);
            }
            string sql = string.Format(
                "SELECT 1 FROM [{0}] WHERE {1}", table, where);
            sql = string.Format(
                "IF EXISTS ({0}) SELECT 1 ELSE SELECT 0", sql);
            int count = _Context.ExecuteQuery<int>(sql, parameters.ToArray()).Single();
            return (count > 0);
        }
    }
}