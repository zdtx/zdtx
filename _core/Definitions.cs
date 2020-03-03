using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

// 域定义
namespace eTaxi.Definitions
{
    /// <summary>
    /// 操作分类
    /// </summary>
    public struct CURD
    {
        public const string Create = "create";
        public const string Update = "update";
        public const string Retrieve = "retrieve";
        public const string Delete = "delete";
        public const string Manage = "manage";
    }

    /// <summary>
    /// 流程状态
    /// </summary>
    public enum WorkflowStatus
    {
        /// <summary>
        /// 未知状态
        /// </summary>
        Unknown = -1,
        /// <summary>
        /// 未提交
        /// </summary>
        Drafting = 0,
        /// <summary>
        /// 已提交
        /// </summary>
        Submitted = 1,
        /// <summary>
        /// 驳回
        /// </summary>
        Rejected = 2,
        /// <summary>
        /// 已完成
        /// </summary>
        Committed = 3,
        /// <summary>
        /// （用户）取消
        /// </summary>
        Canceled = 4
    }
}
