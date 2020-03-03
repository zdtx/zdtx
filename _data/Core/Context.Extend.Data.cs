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
        /// 修改部门的父部门
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="newParentId"></param>
        public CommonContext ResolveParent(TB_department obj, string newParentId)
        {
            if (string.IsNullOrEmpty(obj.Id)) throw new ArgumentException("obj 对象 id 未指明");
            if (obj.Id == newParentId) throw new ArgumentException("不能自选定为父亲");
            var oldPath = obj.Path + obj.Id + "/";
            var subTree = Departments.Where(d => d.Path.StartsWith(oldPath)).ToList();
            if (string.IsNullOrEmpty(newParentId))
            {
                // 放置根
                obj.ParentId = null;
                obj.Path = "/";
            }
            else
            {
                Departments.SingleOrDefault(p => p.Id == newParentId).IfNN(parent =>
                {
                    // 检查循环设置的情况
                    if (parent.Path.StartsWith(oldPath)) throw new Exception("不能循环设置树");
                    obj.ParentId = parent.Id;
                    obj.Path = parent.Path + parent.Id + "/";

                }, () =>
                {
                    throw DTException.NotFound<TB_department>(newParentId);
                });
            }

            subTree.ForEach(c => c.Path = c.Path.Replace(oldPath, obj.Path + obj.Id + "/"));
            return this;
        }

    }

}
