using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

using LinqKit;

using D = eTaxi.Definitions;
using E = eTaxi.Exceptions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 执行一个常驻内容的数据结构，带脏标志，碰到脏了，就更新这部分数据
    /// </summary>
    public partial class GlobalCache : TypedHashtable
    {
        /// <summary>
        /// 存储的脏标志
        /// </summary>
        private Dictionary<D.CachingTypes, bool> _Dirties = new Dictionary<D.CachingTypes, bool>();

        /// <summary>
        /// 建立事件机制，让外部执行脏的对应操作
        /// </summary>
        public event Action<D.CachingTypes> Dirty = null;

        /// <summary>
        /// 设脏
        /// </summary>
        /// <param name="section"></param>
        public void SetDirty(D.CachingTypes section, bool value = true) { _Dirties[section] = true; }
        
        /// <summary>
        /// 全部设脏标记
        /// </summary>
        public void SetAllDirty()
        {
            _Dirties.Select(d => d.Key)
                .ToList().ForEach(k => _Dirties[k] = true);
        }

        /// <summary>
        /// 取消脏
        /// </summary>
        /// <param name="section"></param>
        public void ResetDirty(D.CachingTypes section) { _Dirties[section] = false; }

        public GlobalCache()
        {
            _Dirties.Clear();
            _Dirties.Add(D.CachingTypes.Department, true);
            _Dirties.Add(D.CachingTypes.Person, true);
            _Dirties.Add(D.CachingTypes.Module, true);
            _Dirties.Add(D.CachingTypes.Position, true);
            _Dirties.Add(D.CachingTypes.Package, true);
            _Dirties.Add(D.CachingTypes.Rank, true);
            _Dirties.Add(D.CachingTypes.Portlet, true);
            //_Dirties.Add(D.CachingTypes.Role, true);
            //_Dirties.Add(D.CachingTypes.User, true);
        }

        private object _Locker_Rank = new object();
        /// <summary>
        /// 行政级别
        /// </summary>
        public List<TB_rank> Ranks
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Rank])
                    return base.Get<List<TB_rank>>(
                        D.CachingTypes.Rank.ToString(), () => new List<TB_rank>());
                lock (_Locker_Rank)
                {
                    if (!
                        _Dirties[D.CachingTypes.Rank])
                        return base.Get<List<TB_rank>>(D.CachingTypes.Rank.ToString());
                    if (Dirty != null) Dirty(D.CachingTypes.Rank);
                    return base.Get<List<TB_rank>>(
                        D.CachingTypes.Rank.ToString(), () => new List<TB_rank>());
                }
            }
        }

        private object _Locker_Department = new object();
        /// <summary>
        /// 部门缓存
        /// </summary>
        public List<TB_department> Departments
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Department])
                    return base.Get<List<TB_department>>(
                        D.CachingTypes.Department.ToString(), () => new List<TB_department>());
                lock (_Locker_Department)
                {
                    if (!
                        _Dirties[D.CachingTypes.Department])
                        return base.Get<List<TB_department>>(D.CachingTypes.Department.ToString());
                    if (Dirty != null) Dirty(D.CachingTypes.Department);
                    return base.Get<List<TB_department>>(
                        D.CachingTypes.Department.ToString(), () => new List<TB_department>());
                }
            }
        }

        private object _Locker_Position = new object();
        /// <summary>
        /// 岗位缓存
        /// </summary>
        public List<TB_position> Positions
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Position])
                    return base.Get<List<TB_position>>(
                        D.CachingTypes.Position.ToString(), () => new List<TB_position>());
                lock (_Locker_Position)
                {
                    if (!
                        _Dirties[D.CachingTypes.Position])
                        return base.Get<List<TB_position>>(D.CachingTypes.Position.ToString());
                    if (Dirty != null) Dirty(D.CachingTypes.Position);
                    return base.Get<List<TB_position>>(
                        D.CachingTypes.Position.ToString(), () => new List<TB_position>());
                }
            }
        }

        private object _Locker_Package = new object();
        /// <summary>
        /// 经营模式（套餐）缓存
        /// </summary>
        public List<TB_package> Packages
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Package])
                    return base.Get<List<TB_package>>(
                        D.CachingTypes.Package.ToString(), () => new List<TB_package>());
                lock (_Locker_Package)
                {
                    if (!
                        _Dirties[D.CachingTypes.Package])
                        return base.Get<List<TB_package>>(D.CachingTypes.Package.ToString());
                    if (Dirty != null) Dirty(D.CachingTypes.Package);
                    return base.Get<List<TB_package>>(
                        D.CachingTypes.Package.ToString(), () => new List<TB_package>());
                }
            }
        }

        private object _Locker_Person = new object();
        /// <summary>
        /// 人
        /// </summary>
        public List<TB_person> Persons
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Person])
                    return base.Get<List<TB_person>>(
                        D.CachingTypes.Person.ToString(), () => new List<TB_person>());
                lock (_Locker_Person)
                {
                    if (!
                        _Dirties[D.CachingTypes.Person])
                        return base.Get<List<TB_person>>();
                    if (Dirty != null) Dirty(D.CachingTypes.Person);
                    return base.Get<List<TB_person>>(
                        D.CachingTypes.Person.ToString(), () => new List<TB_person>());
                }
            }
        }

        private object _Locker_Module = new object();
        /// <summary>
        /// 模块
        /// </summary>
        public List<TB_sys_module> Modules
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Module])
                    return base.Get<List<TB_sys_module>>(
                        D.CachingTypes.Module.ToString(), () => new List<TB_sys_module>());
                lock (_Locker_Module)
                {
                    if (!
                        _Dirties[D.CachingTypes.Module])
                        return base.Get<List<TB_sys_module>>();
                    if (Dirty != null) Dirty(D.CachingTypes.Module);
                    return base.Get<List<TB_sys_module>>(
                        D.CachingTypes.Module.ToString(), () => new List<TB_sys_module>());
                }
            }
        }

        /// <summary>
        /// 模块 Id 映射
        /// </summary>
        public Dictionary<string, Guid> AccessIds
        {
            get
            {
                const string ACCESS_IDS = "accessIds";
                return base.Get<Dictionary<string, Guid>>(
                    ACCESS_IDS, () =>
                    {
                        var AccessIds = Modules.ToDictionary(m => "~/" + m.Path, m => m.Id);
                        base.Add(AccessIds, ACCESS_IDS);
                        return AccessIds;
                    });
            }
        }

        private object _Locker_Portlet = new object();
        /// <summary>
        /// 模块
        /// </summary>
        public List<PortletInfo> Portlets
        {
            get
            {
                if (!
                    _Dirties[D.CachingTypes.Portlet])
                    return base.Get<List<PortletInfo>>(
                        D.CachingTypes.Portlet.ToString(), () => new List<PortletInfo>());
                lock (_Locker_Portlet)
                {
                    if (!
                        _Dirties[D.CachingTypes.Portlet])
                        return base.Get<List<PortletInfo>>();
                    if (Dirty != null) Dirty(D.CachingTypes.Portlet);
                    return base.Get<List<PortletInfo>>(
                        D.CachingTypes.Portlet.ToString(), () => new List<PortletInfo>());
                }
            }
        }

        public TB_rank GetRank(Func<TB_rank, bool> get) { return Ranks.SingleOrDefault(get) ?? new TB_rank(); }
        public TB_position GetPosition(Func<TB_position, bool> get) { return Positions.SingleOrDefault(get) ?? new TB_position(); }
        public TB_package GetPackage(Func<TB_package, bool> get) { return Packages.SingleOrDefault(get) ?? new TB_package(); }
        public TB_department GetDepartment(Func<TB_department, bool> get) { return Departments.SingleOrDefault(get) ?? new TB_department(); }
        public TB_person GetPerson(Func<TB_person, bool> get)
        {
            return Persons.SingleOrDefault(get) ?? new TB_person();
        }
        public TB_person GetPersonById(string id)
        {
            if (string.IsNullOrEmpty(id))
                return new TB_person()
                {
                    Name = "（管理员）"
                };
            return GetPerson(p => p.Id == id);
        }
        public TB_sys_module GetModule(Func<TB_sys_module, bool> get) { return Modules.SingleOrDefault(get) ?? new TB_sys_module(); }
        
        /// <summary>
        /// 获取所有子部门 ID
        /// </summary>
        /// <param name="id"></param>
        /// <param name="includeMe"></param>
        /// <returns></returns>
        public string[] GetChildDepartmentIds(string id, bool includeMe = true)
        {
            return TreeUtil<TB_department>
                .SubTree(Departments, id, d => d.Id, d => d.ParentId)
                .Where(d => d.Id != id || (d.Id == id && includeMe))
                .Select(d => d.Id).ToArray();
        }

    }
}