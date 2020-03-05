using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace eTaxi.Definitions
{
    public struct Themes
    {
        /// <summary>
        /// 蓝色
        /// </summary>
        public const string Office2010Blue = "office2010blue";

        /// <summary>
        /// 灰色
        /// </summary>
        public const string Office2010Silver = "office2010silver";
    }

    /// <summary>
    /// 整体被 Cache 掉的数据类别
    /// </summary>
    public enum CachingTypes
    {
        /// <summary>
        /// 部门数据
        /// </summary>
        Department,
        /// <summary>
        /// 角色
        /// </summary>
        Role,
        /// <summary>
        /// 人员
        /// </summary>
        Person,
        /// <summary>
        /// 用户
        /// </summary>
        User,
        /// <summary>
        /// 模块
        /// </summary>
        Module,
        /// <summary>
        /// 人员岗位
        /// </summary>
        Position,
        /// <summary>
        /// 套餐
        /// </summary>
        Package,
        /// <summary>
        /// 行政级别
        /// </summary>
        Rank,
        /// <summary>
        /// 门户控件
        /// </summary>
        Portlet
    }

    /// <summary>
    /// 临时目录分类
    /// </summary>
    public enum TempFolder
    {
        /// <summary>
        /// 一般上传文件
        /// </summary>
        File,
        /// <summary>
        /// 导出 Excel
        /// </summary>
        Export
    }

    namespace Session
    {
        /// <summary>
        /// 会话变量的几个系统 Key
        /// </summary>
        public struct Keys
        {
            public const string Id = "id";
            public const string TicketObjectManager = "SYS.TicketObjectManager";
            public const string ExtraThread = "SYS.ExtraThread";
            public const string Loader = "SYS.Loader";
            public const string Cache = "SYS.Cache";
        }
    }

    /// <summary>
    /// 命名变量
    /// </summary>
    public struct NamedSection
    {
        /// <summary>
        /// 数据库连接
        /// </summary>
        public const string DataConnection = "data";
        /// <summary>
        /// 在 Url 加载回调函数的变量名
        /// </summary>
        public const string CallbackQuery = "___cb";
    }

    public struct Login
    {
        /// <summary>
        /// 管理员
        /// </summary>
        public const string Administrator = "admin";
        public const string AdministratorId = "00000000-0000-0000-0000-000000000001";
        /// <summary>
        /// 访客（匿名用户）
        /// </summary>
        public const string Guest = "guest";
        public const string GuestId = "00000000-0000-0000-0000-000000000000";
    }


    /// <summary>
    /// 页面按钮动作定义
    /// </summary>
    public struct Actions
    {
        /// <summary>
        /// 登录
        /// </summary>
        public const string Login = "login";

        /// <summary>
        /// 创建
        /// </summary>
        public const string Create = CURD.Create;

        /// <summary>
        /// 更新
        /// </summary>
        public const string Update = CURD.Update;

        /// <summary>
        /// 保存按钮
        /// </summary>
        public const string Save = "save";

        /// <summary>
        /// 保存子操作-新增
        /// </summary>
        public const string Add = "add";

        /// <summary>
        /// 移除（明细）
        /// </summary>
        public const string Remove = "remove";

        /// <summary>
        /// 重新加载
        /// </summary>
        public const string Reload = "reload";

        /// <summary>
        /// 刷新
        /// </summary>
        public const string Refresh = "refresh";

        /// <summary>
        /// 保存子操作-修改
        /// </summary>
        public const string Edit = "edit";

        /// <summary>
        /// 删除按钮
        /// </summary>
        public const string Delete = CURD.Delete;

        /// <summary>
        /// 提交审批
        /// </summary>
        public const string Submit = "submit";

        /// <summary>
        /// 同步
        /// </summary>
        public const string Syn = "sny";

        /// <summary>
        /// 通过审批
        /// </summary>
        public const string Approve = "approve";

        /// <summary>
        /// 驳回审批
        /// </summary>
        public const string Reject = "reject";

        /// <summary>
        /// 查看审批历史
        /// </summary>
        public const string History = "history";

        /// <summary>
        /// 搜索/查询
        /// </summary>
        public const string Search = "search";

        /// <summary>
        /// 关闭
        /// </summary>
        public const string Close = "close";

        /// <summary>
        /// 弹窗，如果同一页面有很多类型的弹窗事件，需要以子操作作区分，子操作名在各自页面中定义
        /// </summary>
        public const string Popup = "popup";

        /// <summary>
        /// 选择操作
        /// </summary>
        public const string Select = "select";

        /// <summary>
        /// 一般操作
        /// </summary>
        public const string Process = "process";

        /// <summary>
        /// 打印操作
        /// </summary>
        public const string Print = "print";

        /// <summary>
        /// 下一个
        /// </summary>
        public const string Next = "next";

        /// <summary>
        /// 上一个
        /// </summary>
        public const string Previous = "previous";
    }

    /// <summary>
    /// 获取数据分区定义
    /// </summary>
    public struct DataSections
    {
        /// <summary>
        /// 获取 List 数据
        /// </summary>
        public const string List = "list";

        /// <summary>
        /// 树状导航
        /// </summary>
        public const string Tree = "tree";

        /// <summary>
        /// 主表
        /// </summary>
        public const string Master = "master";

        /// <summary>
        /// 明细表
        /// </summary>
        public const string Detail = "detail";

        /// <summary>
        /// 查询条件
        /// </summary>
        public const string Filter = "filter";
    }

    /// <summary>
    /// 通用的视图状态
    /// </summary>
    public struct DataStates
    {
        /// <summary>
        /// 通用的对象 Id 
        /// </summary>
        public const string ObjectId = "objectId";
        /// <summary>
        /// 是否新增
        /// </summary>
        public const string IsCreating = "isCreating";
        /// <summary>
        /// 选定的数据
        /// </summary>
        public const string Selected = "selected";
        /// <summary>
        /// 列表数据
        /// </summary>
        public const string List = "list";
        /// <summary>
        /// 明细数据
        /// </summary>
        public const string Detail = "detail";
    }

    /// <summary>
    /// 绑定数据动作定义
    /// </summary>
    public struct VisualSections
    {
        /// <summary>
        /// 保存过滤条件
        /// </summary>
        public const string Filter = "filter";

        /// <summary>
        /// 绑定主数据List
        /// </summary>
        public const string List = "list";

        /// <summary>
        /// 页面的表头
        /// </summary>
        public const string Header = "header";

        /// <summary>
        /// 主表
        /// </summary>
        public const string Master = "master";

        /// <summary>
        /// 明细表
        /// </summary>
        public const string Detail = "detail";

        /// <summary>
        /// 绑定数据分页导航
        /// </summary>
        public const string Pager = "pager";

        /// <summary>
        /// 树状导航区
        /// </summary>
        public const string Tree = "tree";

        /// <summary>
        /// 导出界面
        /// </summary>
        public const string Export = "export";

    }
}
