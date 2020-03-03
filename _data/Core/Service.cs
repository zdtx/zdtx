using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Data.Linq.Mapping;
using System.Text;
using System.Data;
using System.Data.Linq;
using Microsoft.Practices.Unity;

namespace eTaxi.L2SQL
{
    /// <summary>
    /// 通用服务（在 L2SQL 支持下）
    /// </summary>
    public partial class CommonService : DTServiceBase<CommonContext>
    {
        #region 存储的分语义创建和初始化

        public CommonService(IDataConnectionManager manager) : base(manager) { }

        #endregion

        /// <summary>
        /// 查权限
        /// </summary>
        /// <param name="code">GUID</param>
        /// <param name="userId"></param>
        /// <param name="roleIds"></param>
        /// <returns></returns>
        public bool AC(string code, string userId, params string[] roleIds)
        {
            Guid moduleId = Guid.Empty;
            if (!Guid.TryParse(code, out moduleId)) return true;
            
            var actorIds = new string[] { userId }.Concat(roleIds).ToList();
            var sql = string.Format(
@"select count(0) from {0} a where 
a.actorid in ({1}) and 
a.moduleid = '{2}' and not exists
(
    select 0
    from {0} b 
    where a.actorid = b.actorid and a.moduleid = b.moduleid and b.isforbidden = 'true'
)", 
            Context.TableInfo<TB_sys_acl>().TableName, 
            actorIds.ToFlat(handlePart: p => string.Format("'{0}'", p)),
            new Guid(code).ToString().ToUpper());

            var count = Context.ExecuteQuery<int>(sql).First();
            return (count > 0);
        }

    }
}
