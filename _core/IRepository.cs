using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;

namespace ISS.Domain
{
    /// <summary>
    /// 最核心的CURD定义
    /// </summary>
    public interface IRepository<T> where T : class
    {
        void Create(T dataObject);
        void CreateAll(T[] dataObjects);
        int Update(T dataObject, string[] fieldsToUpdate);
        int Update<TFields>(T dataObject, Expression<Func<T, TFields>> fieldSelector);
        int Delete(T dataObject);
        int DeleteAll(T[] dataObjects);
        int DeleteAll<TFields>(T dataObject, Expression<Func<T, TFields>> fieldSelector);
        int DeleteAll(Expression<Func<T, bool>> selector);
        T Retrieve(Expression<Func<T, bool>> selector, bool exceptionIfNotExists);
        IQueryable<T> RetrieveAll(Expression<Func<T, bool>> selector);
        bool Exists(T dataObject);
        bool Exists<TFields>(T dataObject, Expression<Func<T, TFields>> fieldSelector);
    }
}
