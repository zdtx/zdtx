using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace eTaxi
{
    public interface IUserSession
    {
        /// <summary>
        /// 人员的 ID，即 Page 中的 OperatorID
        /// </summary>
        string Id { get; }
        /// <summary>
        /// 人员姓名
        /// </summary>
        string Name { get; }
        /// <summary>
        /// 分公司
        /// </summary>
        string BranchId { get; }
        /// <summary>
        /// 部门
        /// </summary>
        string DepartmentId { get; }
        /// <summary>
        /// 登录帐号
        /// </summary>
        string UserName { get; }
        /// <summary>
        /// 当前时间
        /// </summary>
        DateTime CurrentTime { get; }
        /// <summary>
        /// 用于接轨 MembershipProvider 的键值
        /// </summary>
        Guid UniqueId { get; }
        /// <summary>
        /// 角色列表
        /// </summary>
        string[] RoleIds { get; }
    }
}
