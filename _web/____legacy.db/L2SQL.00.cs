using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Data.Linq;
using System.Data.Linq.Mapping;

using eTaxi.L2SQL;
namespace ET.L2SQL
{
    [Serializable]
    [Table(Name = "AspNetRoles")]
    public partial class TB_AspNetRoles : TBObject<TB_AspNetRoles>
    {
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string Name { get; set; }
    }
    [Serializable]
    [Table(Name = "AspNetUserClaims")]
    public partial class TB_AspNetUserClaims : TBObject<TB_AspNetUserClaims>
    {
        [ColumnAttribute(DbType = "nvarchar(max)")]
        public string ClaimType { get; set; }
        [ColumnAttribute(DbType = "nvarchar(max)")]
        public string ClaimValue { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int Id { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "AspNetUserLogins")]
    public partial class TB_AspNetUserLogins : TBObject<TB_AspNetUserLogins>
    {
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string LoginProvider { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string ProviderKey { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "AspNetUserRoles")]
    public partial class TB_AspNetUserRoles : TBObject<TB_AspNetUserRoles>
    {
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string RoleId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "AspNetUsers")]
    public partial class TB_AspNetUsers : TBObject<TB_AspNetUsers>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int AccessFailedCount { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Email { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool EmailConfirmed { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool LockoutEnabled { get; set; }
        [ColumnAttribute(DbType = "datetime")]
        public Nullable<DateTime> LockoutEndDateUtc { get; set; }
        [ColumnAttribute(DbType = "nvarchar(max)")]
        public string PasswordHash { get; set; }
        [ColumnAttribute(DbType = "nvarchar(max)")]
        public string PhoneNumber { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool PhoneNumberConfirmed { get; set; }
        [ColumnAttribute(DbType = "nvarchar(max)")]
        public string SecurityStamp { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool TwoFactorEnabled { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string UserName { get; set; }
    }
    [Serializable]
    [Table(Name = "车辆信息")]
    public partial class TB_车辆信息 : TBObject<TB_车辆信息>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int ID { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 保险公司 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 备注 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车架号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆承包管理费 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆单位 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆获得方式 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆品牌型号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆性质 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车牌号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 发动机号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 交接班地点 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 交接班时间 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 是否缴费 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 所属车队 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 投保日期 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 行审日期 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 行驶证号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 营审日期 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 营运证号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 原车牌号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 治安证编号 { get; set; }
    }
    [Serializable]
    [Table(Name = "代班记录")]
    public partial class TB_代班记录 : TBObject<TB_代班记录>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int ID { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 备注 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车牌号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 代班费用 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 代班驾驶员姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 代班交接班地点 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 代班年份 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 当班驾驶员姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 日期 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 时间段 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 月份 { get; set; }
    }
    [Serializable]
    [Table(Name = "驾驶员信息")]
    public partial class TB_驾驶员信息 : TBObject<TB_驾驶员信息>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int ID { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 备注 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 常住地址 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车牌号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 出生年月 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 从业时间 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 从业资格证号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 户口地址 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 介绍人 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 离职时间 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 联系电话 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 年龄 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 人员状态 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 上车时间 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 身份证号码 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 所属公司 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 文化程度 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 性别 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 原车牌号 { get; set; }
        [ColumnAttribute(DbType = "image")]
        public byte[] 照片 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 政治面貌 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 资格证信誉考核记录 { get; set; }
    }
    [Serializable]
    [Table(Name = "事故处理")]
    public partial class TB_事故处理 : TBObject<TB_事故处理>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int ID { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 备注 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆理赔金额 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆维修公司 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车牌号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 处理结果 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 当班驾驶员 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 发生地点 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 发生时间 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 事件经过 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 现场协调处理人姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 有无责任 { get; set; }
    }
    [Serializable]
    [Table(Name = "投诉接待与处理")]
    public partial class TB_投诉接待与处理 : TBObject<TB_投诉接待与处理>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int ID { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 备注 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆获得方式 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车辆性质 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 车牌号 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 处理结果 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 当班驾驶员姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 驾驶员有无责任 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 接待处理人姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 联系电话 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 投诉来源 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 投诉类型 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 投诉内容 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 投诉时间 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 原车牌号 { get; set; }
    }
    [Serializable]
    [Table(Name = "员工账号")]
    public partial class TB_员工账号 : TBObject<TB_员工账号>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int ID { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 部门 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 密码 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 年龄 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 姓名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 性别 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 用户名 { get; set; }
        [ColumnAttribute(DbType = "varchar(max)")]
        public string 员工权限 { get; set; }
    }
}
