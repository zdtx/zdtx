using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using Microsoft.Practices.Unity;

using eTaxi.L2SQL;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    public partial class Global : System.Web.HttpApplication
    {
        /// <summary>
        /// 全局数据缓存（数据库出来的数据）
        /// </summary>
        public static GlobalCache Cache = new GlobalCache();

        /// <summary>
        /// 全局会话管理
        /// </summary>
        public static HttpSessionStateInfrastructure Sessions = new HttpSessionStateInfrastructure();

        /// <summary>
        /// 用于执行批处理的工作片段处理机
        /// </summary>
        public static TypedHashtable Workers { get { return _Workers; } }
        private static TypedHashtable _Workers = new TypedHashtable();

        /// <summary>
        /// 配置缓存策略
        /// </summary>
        protected void ConfigCache()
        {
            var context = Util.DTContext<CommonContext>(true);
            Cache.Dirty += t =>
            {
                switch (t)
                {
                    case D.CachingTypes.Rank:
                        var qRank =
                            from r in context.Ranks
                            select new
                            {
                                r.Id,
                                r.Name,
                                r.Value,
                                r.Description
                            };
                        Cache.Resolve<List<TB_rank>>(Exp<TB_rank>.Transform(qRank.ToList(), i =>
                            {
                                var item = new TB_rank();
                                i.FlushTo(item);
                                return item;
                            }), D.CachingTypes.Rank.ToString());
                        Cache.ResetDirty(D.CachingTypes.Rank);
                        break;
                    case D.CachingTypes.Department:
                        var qDepartment = 
                            from d in context.Departments
                            select new
                            {
                                d.Id,
                                d.ParentId,
                                d.Path,
                                d.Name,
                                d.Ordinal,
                                d.Description
                            };
                        Cache.Resolve<List<TB_department>>(Exp<TB_department>.Transform(qDepartment.ToList(), i =>
                            {
                                var item = new TB_department();
                                i.FlushTo(item);
                                return item;
                            }), D.CachingTypes.Department.ToString());
                        Cache.ResetDirty(D.CachingTypes.Department);
                        break;
                    case D.CachingTypes.Position:
                        var qPosition =
                            from d in context.Positions
                            select new
                            {
                                d.Id,
                                d.Name,
                                d.RankId,
                                d.Description
                            };
                        Cache.Resolve<List<TB_position>>(Exp<TB_position>.Transform(qPosition.ToList(), i =>
                        {
                            var item = new TB_position();
                            i.FlushTo(item);
                            return item;
                        }), D.CachingTypes.Position.ToString());
                        Cache.ResetDirty(D.CachingTypes.Position);
                        break;
                    case D.CachingTypes.Person:
                        var qPerson =
                            from p in context.Persons
                            select new
                            {
                                p.Id,
                                p.Name,
                                p.FirstName,
                                p.LastName,
                                p.Gender,
                                p.DayOfBirth,
                                p.DepartmentId,
                                p.PositionId
                            };
                        Cache.Resolve<List<TB_person>>(Exp<TB_person>.Transform(qPerson.ToList(), i =>
                        {
                            var item = new TB_person();
                            i.FlushTo(item);
                            return item;
                        }), D.CachingTypes.Person.ToString());
                        Cache.ResetDirty(D.CachingTypes.Person);
                        break;
                    case D.CachingTypes.Module:
                        Cache.Resolve<List<TB_sys_module>>(
                            context.Modules
                                .Where(m => m.Enabled)
                                .ToList(), D.CachingTypes.Module.ToString());
                        Cache.ResetDirty(D.CachingTypes.Module);
                        break;
                    case D.CachingTypes.Portlet:
                        Cache.Resolve<List<PortletInfo>>(
                            Util.GetPortlets(), D.CachingTypes.Portlet.ToString());
                        Cache.ResetDirty(D.CachingTypes.Portlet);
                        break;
                }
            };
        }
    }
}