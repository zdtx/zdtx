using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace eTaxi.Definitions
{
    /// <summary>
    /// 批处理来源
    /// </summary>
    public enum BatchChannel
    {
        /// <summary>
        /// 来自实时引擎
        /// </summary>
        Timer = 1
    }

    /// <summary>
    /// 批任务处理状态
    /// </summary>
    public enum BatchHandlingStatus
    {
        /// <summary>
        /// 未处理
        /// </summary>
        Unhandled = -1,
        /// <summary>
        /// 处理中
        /// </summary>
        Handling = 0,
        /// <summary>
        /// 成功
        /// </summary>
        Handled = 1,
        /// <summary>
        /// 过期
        /// </summary>
        Expired = 2,
        /// <summary>
        /// 失败
        /// </summary>
        Failed = 3
    }



}
