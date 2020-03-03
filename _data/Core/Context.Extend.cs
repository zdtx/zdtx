using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data;
using System.Reflection;

namespace eTaxi.L2SQL
{
    /// <summary>
    /// 为上下文进行扩展操作
    /// </summary>
    public partial class CommonContext : DataContextEx
    {
        /// <summary>
        /// 如果对象有上述字段，则在更新过程中进行系统更新
        /// </summary>
        /// <param name="obj"></param>
        public CommonContext Endorse<T>(IUserSession session, T obj, bool isCreating = true) where T:TBObject
        {
            const string FIELD_CREATOR_ID = "CreatedById";
            const string FIELD_CREATE_TIME = "CreateTime";
            const string FIELD_MODIFIER_ID = "ModifiedById";
            const string FIELD_MODIFY_TIME = "ModifyTime";
            
            var t = obj.GetType();
            if (isCreating)
            {
                t.GetProperties()
                    .SingleOrDefault(p => p.Name.ToLower() == FIELD_CREATOR_ID.ToLower())
                    .IfNN(p => p.SetValue(obj, session.Id, null));
                t.GetProperties()
                    .SingleOrDefault(p => p.Name.ToLower() == FIELD_CREATE_TIME.ToLower())
                    .IfNN(p => p.SetValue(obj, session.CurrentTime, null));
            }
            t.GetProperties()
                .SingleOrDefault(p => p.Name.ToLower() == FIELD_MODIFIER_ID.ToLower())
                .IfNN(p => p.SetValue(obj, session.Id, null));
            t.GetProperties()
                .SingleOrDefault(p => p.Name.ToLower() == FIELD_MODIFY_TIME.ToLower())
                .IfNN(p => p.SetValue(obj, session.CurrentTime, null));
            return this;
        }

        /// <summary>
        /// 新增对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="handle"></param>
        /// <returns></returns>
        public CommonContext Create<T>(IUserSession session, Action<T> handle = null) where T : TBObject
        {
            var obj = Activator.CreateInstance<T>();
            if (handle != null) handle(obj);
            Endorse(session, obj);
            GetTable<T>().InsertOnSubmit(obj);
            return this;
        }

        /// <summary>
        /// 更新单个对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="session"></param>
        /// <param name="get"></param>
        /// <param name="handle"></param>
        /// <returns></returns>
        public CommonContext Update<T>(IUserSession session,
            Expression<Func<T, bool>> get, Action<T> handle = null) where T : TBObject
        {
            var obj = GetTable<T>().SingleOrDefault(get);
            if (obj == null) throw DTException.NotFound<T>(get.ToStringEx());
            if (handle != null) handle(obj);
            Endorse<T>(session, obj, false);
            return this;
        }

        /// <summary>
        /// 更新单个对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="handle"></param>
        /// <returns></returns>
        public CommonContext Single<T>(
            Expression<Func<T, bool>> get, Action<T> handle = null) where T : TBObject
        {
            var obj = GetTable<T>().SingleOrDefault(get);
            if (obj == null) throw DTException.NotFound<T>(get.ToStringEx());
            if (handle != null) handle(obj);
            return this;
        }

        /// <summary>
        /// 新增（如果找不到的话）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="get"></param>
        /// <param name="handle"></param>
        /// <returns></returns>
        public CommonContext CreateWhenNotExists<T>(IUserSession session,
            Expression<Func<T, bool>> get, Action<T, bool> handle = null) where T : TBObject
        {
            var obj = GetTable<T>().FirstOrDefault(get);
            if (obj == null)
            {
                obj = Activator.CreateInstance<T>();
                if (handle != null) handle(obj, true);
                Endorse<T>(session, obj);
                GetTable<T>().InsertOnSubmit(obj);
                return this;
            }
            if (handle != null) handle(obj, false);
            Endorse<T>(session, obj, false);
            return this;
        }

        /// <summary>
        /// 删除符合条件的对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="get"></param>
        /// <param name="handle"></param>
        /// <returns></returns>
        public CommonContext DeleteAll<T>(Expression<Func<T, bool>> filter) where T : TBObject, new()
        {
            Store<T>().DeleteAll(filter);
            return this;
        }

        /// <summary>
        /// 申请一个新的序列号
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="handle"></param>
        /// <returns></returns>
        public CommonContext NewSequence<T>(
            IUserSession session, Action<TB_sys_sequence, string> handle) where T : TBObject
        {
            const string DEFAULT_PREFIX = "AA";
            const string DEFAULT_FORMAT = "{0:00000000}";
            const string SHORT_FORMAT = "{0:0000}";
            var table = this.TableInfo<T>().TableName;
            var seq = GetTable<TB_sys_sequence>().SingleOrDefault(s => s.Entity == table);
            if (seq == null) throw DTException.NotFound<TB_sys_sequence>(table);
            seq.Count += seq.Step;
            if (seq.Count > seq.Limit)
                throw new DTException("自增 ID 超出下限", s => s.Record("table", table));
            var prefix = string.IsNullOrEmpty(seq.Prefix.Trim()) ? DEFAULT_PREFIX : seq.Prefix;
            if (seq.ShortForm)
            {
                handle(seq, prefix + string.Format(SHORT_FORMAT, seq.Count));
            }
            else
            {
                handle(seq, prefix + string.Format(DEFAULT_FORMAT, seq.Count));
            }
            Endorse(session, seq, false);
            return this;
        }

        /// <summary>
        /// 生成系统 id 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="session"></param>
        /// <param name="handle"></param>
        /// <returns></returns>
        public string NewSequence<T>(IUserSession session) where T : TBObject
        {
            var newId = string.Empty;
            NewSequence<T>(session, (seq, id) => newId = id);
            return newId;
        }

    }

}
