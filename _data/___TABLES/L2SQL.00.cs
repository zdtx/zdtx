using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace eTaxi.L2SQL
{
    [Serializable]
    [Table(Name = "____column")]
    public partial class TB_____column : TBObject<TB_____column>
    {
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> CharMaxLength { get; set; }
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> CharOctLength { get; set; }
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string CharsetName { get; set; }
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string CharsetSchema { get; set; }
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string CollationCatalog { get; set; }
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> DateTimePrecision { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string Name { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Nullable { get; set; }
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> NumericPrecision { get; set; }
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> NumericPrecisionRadix { get; set; }
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> NumericScale { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Ordinal { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid TableId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Type { get; set; }
    }
    [Serializable]
    [Table(Name = "____property")]
    public partial class TB_____property : TBObject<TB_____property>
    {
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string Field { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string Name { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid TableId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(max)")]
        public string Value { get; set; }
    }
    [Serializable]
    [Table(Name = "____table")]
    public partial class TB_____table : TBObject<TB_____table>
    {
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Catalog { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string KeyInfo { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        [ColumnAttribute(DbType = "nvarchar(16)", CanBeNull = false)]
        public string Scheme { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid TableId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(16)", CanBeNull = false)]
        public string Type { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_Applications")]
    public partial class TB_aspnet_Applications : TBObject<TB_aspnet_Applications>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid ApplicationId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string ApplicationName { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Description { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string LoweredApplicationName { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_Membership")]
    public partial class TB_aspnet_Membership : TBObject<TB_aspnet_Membership>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false)]
        public Guid ApplicationId { get; set; }
        [ColumnAttribute(DbType = "ntext")]
        public string Comment { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateDate { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Email { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int FailedPasswordAnswerAttemptCount { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime FailedPasswordAnswerAttemptWindowStart { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int FailedPasswordAttemptCount { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime FailedPasswordAttemptWindowStart { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsApproved { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsLockedOut { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastLockoutDate { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastLoginDate { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastPasswordChangedDate { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string LoweredEmail { get; set; }
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string MobilePIN { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Password { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string PasswordAnswer { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int PasswordFormat { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string PasswordQuestion { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string PasswordSalt { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_Paths")]
    public partial class TB_aspnet_Paths : TBObject<TB_aspnet_Paths>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false)]
        public Guid ApplicationId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string LoweredPath { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string Path { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid PathId { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_PersonalizationAllUsers")]
    public partial class TB_aspnet_PersonalizationAllUsers : TBObject<TB_aspnet_PersonalizationAllUsers>
    {
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastUpdatedDate { get; set; }
        [ColumnAttribute(DbType = "image", CanBeNull = false)]
        public byte[] PageSettings { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid PathId { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_PersonalizationPerUser")]
    public partial class TB_aspnet_PersonalizationPerUser : TBObject<TB_aspnet_PersonalizationPerUser>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid Id { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastUpdatedDate { get; set; }
        [ColumnAttribute(DbType = "image", CanBeNull = false)]
        public byte[] PageSettings { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier")]
        public Nullable<Guid> PathId { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier")]
        public Nullable<Guid> UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_Profile")]
    public partial class TB_aspnet_Profile : TBObject<TB_aspnet_Profile>
    {
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastUpdatedDate { get; set; }
        [ColumnAttribute(DbType = "ntext", CanBeNull = false)]
        public string PropertyNames { get; set; }
        [ColumnAttribute(DbType = "image", CanBeNull = false)]
        public byte[] PropertyValuesBinary { get; set; }
        [ColumnAttribute(DbType = "ntext", CanBeNull = false)]
        public string PropertyValuesString { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_Roles")]
    public partial class TB_aspnet_Roles : TBObject<TB_aspnet_Roles>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false)]
        public Guid ApplicationId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Description { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string LoweredRoleName { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid RoleId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string RoleName { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_SchemaVersions")]
    public partial class TB_aspnet_SchemaVersions : TBObject<TB_aspnet_SchemaVersions>
    {
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string CompatibleSchemaVersion { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false, IsPrimaryKey = true)]
        public string Feature { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsCurrentVersion { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_Users")]
    public partial class TB_aspnet_Users : TBObject<TB_aspnet_Users>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false)]
        public Guid ApplicationId { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsAnonymous { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastActivityDate { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string LoweredUserName { get; set; }
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string MobileAlias { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid UserId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string UserName { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_UsersInRoles")]
    public partial class TB_aspnet_UsersInRoles : TBObject<TB_aspnet_UsersInRoles>
    {
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid RoleId { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid UserId { get; set; }
    }
    [Serializable]
    [Table(Name = "aspnet_WebEvent_Events")]
    public partial class TB_aspnet_WebEvent_Events : TBObject<TB_aspnet_WebEvent_Events>
    {
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string ApplicationPath { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string ApplicationVirtualPath { get; set; }
        [ColumnAttribute(DbType = "ntext")]
        public string Details { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int EventCode { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int EventDetailCode { get; set; }
        [ColumnAttribute(DbType = "char(32)", CanBeNull = false, IsPrimaryKey = true)]
        public string EventId { get; set; }
        [ColumnAttribute(DbType = "decimal(19, 0)", CanBeNull = false)]
        public decimal EventOccurrence { get; set; }
        [ColumnAttribute(DbType = "decimal(19, 0)", CanBeNull = false)]
        public decimal EventSequence { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime EventTime { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime EventTimeUtc { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string EventType { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string ExceptionType { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string MachineName { get; set; }
        [ColumnAttribute(DbType = "nvarchar(1024)")]
        public string Message { get; set; }
        [ColumnAttribute(DbType = "nvarchar(1024)")]
        public string RequestUrl { get; set; }
    }
    /// <summary>
    /// 车辆
    /// </summary>
    [Serializable]
    [Table(Name = "car")]
    public partial class TB_car : TBObject<TB_car>
    {
        /// <summary>
        /// 车架号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string CarriageNum { get; set; }
        /// <summary>
        /// 车辆单位
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Company { get; set; }
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> ConstructDueTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string ContractId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 部门归属（营运一二三部）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false)]
        public string DepartmentId { get; set; }
        /// <summary>
        /// 行驶证号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string DrvLicense { get; set; }
        /// <summary>
        /// 行驶证年审到期日
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime DrvLicenseRenewTime { get; set; }
        /// <summary>
        /// 发动机号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string EngineNum { get; set; }
        /// <summary>
        /// 所属车队
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string Fleet { get; set; }
        /// <summary>
        /// 原车牌号码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string FormerPlateNum { get; set; }
        /// <summary>
        /// 交接班地点
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string HandOverPlace { get; set; }
        /// <summary>
        /// 交接班时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> HandOverTime { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 保险公司
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string InsuranceCom { get; set; }
        /// <summary>
        /// 投保日期
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime InsuranceEnd { get; set; }
        /// <summary>
        /// 保单号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string InsuranceTransCode { get; set; }
        /// <summary>
        /// 营运证号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string License { get; set; }
        /// <summary>
        /// 营运证年审到期日
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime LicenseRenewTime { get; set; }
        /// <summary>
        /// 品牌
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Manufacturer { get; set; }
        /// <summary>
        /// 型号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string Model { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string ModuleNo { get; set; }
        [ColumnAttribute(DbType = "nvarchar(6)")]
        public string PackageId { get; set; }
        /// <summary>
        /// 车牌号码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)", CanBeNull = false)]
        public string PlateNumber { get; set; }
        /// <summary>
        /// 保险费用
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Premium { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 承包管理费
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Rental { get; set; }
        /// <summary>
        /// 治安证编号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string SecSerialNum { get; set; }
        /// <summary>
        /// 车辆定点维修公司
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)")]
        public string ServiceCom { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string ServiceContent { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string ServiceId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string ServiceNextContent { get; set; }
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> ServiceNextTime { get; set; }
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> ServiceTime { get; set; }
        /// <summary>
        /// 车辆获得方式
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Source { get; set; }
        /// <summary>
        /// 车辆性质
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    /// <summary>
    /// 车辆 - 交通事故记录
    /// </summary>
    [Serializable]
    [Table(Name = "car_accident")]
    public partial class TB_car_accident : TBObject<TB_car_accident>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 理赔金额
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> Claim { get; set; }
        /// <summary>
        /// 现场协调处理人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Coordinator { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 事件经过
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Description { get; set; }
        /// <summary>
        /// 当班驾驶员（司机）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string DriverId { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 标题
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 发生地点
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Place { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 责任类型（-1：无责 1：次责 2：主责）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int RespLevel { get; set; }
        /// <summary>
        /// 处理结果
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Result { get; set; }
        /// <summary>
        /// 车辆维修公司
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)")]
        public string ServiceCom { get; set; }
        /// <summary>
        /// 处理状态（未启用）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Status { get; set; }
        /// <summary>
        /// 发生时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
    }
    /// <summary>
    /// 车辆 - 费用核算表
    /// </summary>
    [Serializable]
    [Table(Name = "car_balance")]
    public partial class TB_car_balance : TBObject<TB_car_balance>
    {
        /// <summary>
        /// 金额
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Amount { get; set; }
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 是否收入项（否则为支出项）
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsIncome { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 已支付
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Paid { get; set; }
        /// <summary>
        /// 参考1
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string Ref1 { get; set; }
        /// <summary>
        /// 参考2
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string Ref2 { get; set; }
        /// <summary>
        /// 参考3
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string Ref3 { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 类型
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Source { get; set; }
        /// <summary>
        /// 状态
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Status { get; set; }
        /// <summary>
        /// 登记时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
        /// <summary>
        /// 费用名目、标题
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Title { get; set; }
    }
    /// <summary>
    /// 车辆 - 投诉
    /// </summary>
    [Serializable]
    [Table(Name = "car_complain")]
    public partial class TB_car_complain : TBObject<TB_car_complain>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 投诉人联系方式
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string Contact { get; set; }
        /// <summary>
        /// 投诉人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string ContactPerson { get; set; }
        /// <summary>
        /// 接待处理人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string Coordinator { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 投诉主要内容
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string Description { get; set; }
        /// <summary>
        /// 当班驾驶员（司机）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string DriverId { get; set; }
        /// <summary>
        /// 罚款金额
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> Fine { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 标题
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 驾驶员有无责任
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool OwnFault { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 处理结果
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Result { get; set; }
        /// <summary>
        /// 投诉来源
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Source { get; set; }
        /// <summary>
        /// 处理状态（未启用）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Status { get; set; }
        /// <summary>
        /// 投诉时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime Time { get; set; }
        /// <summary>
        /// 投诉类型（0：96169 1：电话 2：网络 -1：其他）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    [Serializable]
    [Table(Name = "car_contract")]
    public partial class TB_car_contract : TBObject<TB_car_contract>
    {
        /// <summary>
        /// 附件（二进制）Id （用于查找 temp file 目录中的文件）
        /// </summary>
        [ColumnAttribute(DbType = "uniqueidentifier")]
        public Nullable<Guid> Blob { get; set; }
        /// <summary>
        /// 合同原始文件名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string BlobOrginalName { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 合同编号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)")]
        public string Code { get; set; }
        /// <summary>
        /// 合同执行时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime CommenceDate { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string DriverId { get; set; }
        /// <summary>
        /// 合同到期时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> EndDate { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 合同类型
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    /// <summary>
    /// 车辆 - 年审记录
    /// </summary>
    [Serializable]
    [Table(Name = "car_inspection")]
    public partial class TB_car_inspection : TBObject<TB_car_inspection>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime ExpiryDate { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 开关标记（0：营运证 1：行驶证）
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsDrivingLicense { get; set; }
        /// <summary>
        /// 证照号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string License { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
    }
    /// <summary>
    /// 车辆 - 保险记录
    /// </summary>
    [Serializable]
    [Table(Name = "car_insurance")]
    public partial class TB_car_insurance : TBObject<TB_car_insurance>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 保险公司
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string InsuranceCom { get; set; }
        /// <summary>
        /// 投保日期
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime InsuranceEnd { get; set; }
        /// <summary>
        /// 保单号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string InsuranceTransCode { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 保险费用
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Premium { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
    }
    /// <summary>
    /// 车辆 - 好人好事（日志）
    /// </summary>
    [Serializable]
    [Table(Name = "car_log")]
    public partial class TB_car_log : TBObject<TB_car_log>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 内容
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string Description { get; set; }
        /// <summary>
        /// 司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string DriverId { get; set; }
        /// <summary>
        /// （内部唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 标题
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 写入时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
        /// <summary>
        /// 类型
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    /// <summary>
    /// 车辆 - 月结单
    /// </summary>
    [Serializable]
    [Table(Name = "car_payment")]
    public partial class TB_car_payment : TBObject<TB_car_payment>
    {
        /// <summary>
        /// 应缴总额
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Amount { get; set; }
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> ClosingBalance { get; set; }
        /// <summary>
        /// 实际驾驶天数
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int CountDays { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 当月天数
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Days { get; set; }
        /// <summary>
        /// 司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        /// <summary>
        /// 到期日
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Due { get; set; }
        /// <summary>
        /// 系统唯一码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 月份信息（例如：201603）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false)]
        public string MonthInfo { get; set; }
        /// <summary>
        /// 名目
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> OpeningBalance { get; set; }
        /// <summary>
        /// 已付总额
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Paid { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
    }
    [Serializable]
    [Table(Name = "car_payment_item")]
    public partial class TB_car_payment_item : TBObject<TB_car_payment_item>
    {
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Amount { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 条目 Id，可能来自预设收费条目，也可能是临时添加
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string ChargeId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(16)", CanBeNull = false)]
        public string Code { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsNegative { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Paid { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string PaymentId { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string Remark { get; set; }
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> SpecifiedMonth { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    /// <summary>
    /// 车辆 - 承租记录
    /// </summary>
    [Serializable]
    [Table(Name = "car_rental")]
    public partial class TB_car_rental : TBObject<TB_car_rental>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// （内部唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        /// <summary>
        /// 额外费用1（当前用于社保收费）
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Extra1 { get; set; }
        /// <summary>
        /// 额外费用2
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Extra2 { get; set; }
        /// <summary>
        /// 额外费用3
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Extra3 { get; set; }
        /// <summary>
        /// 是否试用
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsProbation { get; set; }
        /// <summary>
        /// 生成月结单时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> LastPaymentGenTime { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 排序
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Ordinal { get; set; }
        /// <summary>
        /// 试用到期日
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> ProbationExpiryDate { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 租金或管理费（按月）
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Rental { get; set; }
        /// <summary>
        /// 上车时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime StartTime { get; set; }
    }
    /// <summary>
    /// 车辆 - 承租历史信息
    /// </summary>
    [Serializable]
    [Table(Name = "car_rental_history")]
    public partial class TB_car_rental_history : TBObject<TB_car_rental_history>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        /// <summary>
        /// 下车时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime EndTime { get; set; }
        /// <summary>
        /// 额外费用1（当前用于社保）
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Extra1 { get; set; }
        /// <summary>
        /// 额外费用2
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Extra2 { get; set; }
        /// <summary>
        /// 额外费用3
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Extra3 { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 租金或管理费
        /// </summary>
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Rental { get; set; }
        /// <summary>
        /// 上车时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime StartTime { get; set; }
    }
    /// <summary>
    /// 车辆 - 承租 - 代班记录
    /// </summary>
    [Serializable]
    [Table(Name = "car_rental_shift")]
    public partial class TB_car_rental_shift : TBObject<TB_car_rental_shift>
    {
        /// <summary>
        /// 实际结束时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> ActualEndTime { get; set; }
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 代班天数
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int ConfirmedDays { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        /// <summary>
        /// 代班结束
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime EndTime { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 状态
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsActive { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 代班原因
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)", CanBeNull = false)]
        public string Reason { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 代班开始
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime StartTime { get; set; }
        /// <summary>
        /// 代班司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string SubDriverId { get; set; }
        /// <summary>
        /// 申请时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
    }
    /// <summary>
    /// 车辆 - 更换历史（车架、发动机等）
    /// </summary>
    [Serializable]
    [Table(Name = "car_replace")]
    public partial class TB_car_replace : TBObject<TB_car_replace>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 车架号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string CarriageNum { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 发动机号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string EngineNum { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 品牌
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Manufacturer { get; set; }
        /// <summary>
        /// 型号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string Model { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
    }
    [Serializable]
    [Table(Name = "car_service")]
    public partial class TB_car_service : TBObject<TB_car_service>
    {
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 维修内容
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string ServiceContent { get; set; }
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> ServiceCost { get; set; }
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string ServiceProvider { get; set; }
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime ServiceTime { get; set; }
    }
    /// <summary>
    /// 车辆 - 交通违章记录
    /// </summary>
    [Serializable]
    [Table(Name = "car_violation")]
    public partial class TB_car_violation : TBObject<TB_car_violation>
    {
        /// <summary>
        /// 车辆
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string CarId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 扣分
        /// </summary>
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> DemeritPoints { get; set; }
        /// <summary>
        /// 事件经过
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Description { get; set; }
        /// <summary>
        /// 当班驾驶员（司机）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string DriverId { get; set; }
        /// <summary>
        /// 罚款
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> Fine { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 标题
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 违章地点
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Place { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remarks { get; set; }
        /// <summary>
        /// 处理结果
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Result { get; set; }
        /// <summary>
        /// 严重程度（0：一般 1：严重）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int SeverityLevel { get; set; }
        /// <summary>
        /// 处理状态（未启用）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Status { get; set; }
        /// <summary>
        /// 发生时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
        /// <summary>
        /// 违章类型（0：闯红灯 1：压线 2：逆行 3：违停 4：超速 -1：其他）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    [Serializable]
    [Table(Name = "charge")]
    public partial class TB_charge : TBObject<TB_charge>
    {
        [ColumnAttribute(DbType = "money", CanBeNull = false)]
        public decimal Amount { get; set; }
        /// <summary>
        /// 预设收费项编码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)", CanBeNull = false)]
        public string Code { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Enabled { get; set; }
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsNegative { get; set; }
        /// <summary>
        /// 收费项名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Remark { get; set; }
        /// <summary>
        /// 指定收费项目发生的月份
        /// </summary>
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> SpecifiedMonth { get; set; }
        /// <summary>
        /// 收取模式：0 - 按月，1 - 按年，2 - 按实际天数，9 - 临时
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    [Serializable]
    [Table(Name = "charge_package")]
    public partial class TB_charge_package : TBObject<TB_charge_package>
    {
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string ChargeId { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 对套餐是否可用
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Enabled { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string PackageId { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
    }
    /// <summary>
    /// 部门
    /// </summary>
    [Serializable]
    [Table(Name = "department")]
    public partial class TB_department : TBObject<TB_department>
    {
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 说明
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Description { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 同层排序值（越小越靠前）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Ordinal { get; set; }
        /// <summary>
        /// 父部门
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)")]
        public string ParentId { get; set; }
        /// <summary>
        /// 路径
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(600)", CanBeNull = false)]
        public string Path { get; set; }
    }
    /// <summary>
    /// 司机
    /// </summary>
    [Serializable]
    [Table(Name = "driver")]
    public partial class TB_driver : TBObject<TB_driver>
    {
        /// <summary>
        /// 常住地址
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Address { get; set; }
        /// <summary>
        /// 从业时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> CareerStart { get; set; }
        /// <summary>
        /// 从业资格证号
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)")]
        public string CertNumber { get; set; }
        /// <summary>
        /// 身份证
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(20)")]
        public string CHNId { get; set; }
        /// <summary>
        /// 亲属联系电话
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string ContactNumber { get; set; }
        /// <summary>
        /// 亲属联系人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)")]
        public string ContactPerson { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 出生日期
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> DayOfBirth { get; set; }
        /// <summary>
        /// 文化程度
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Education { get; set; }
        /// <summary>
        /// 人员状态
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Enabled { get; set; }
        /// <summary>
        /// 名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(5)", CanBeNull = false)]
        public string FirstName { get; set; }
        /// <summary>
        /// 性别（Null：未填报 1：男   0：女）
        /// </summary>
        [ColumnAttribute(DbType = "bit")]
        public Nullable<bool> Gender { get; set; }
        /// <summary>
        /// 介绍人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Guarantor { get; set; }
        /// <summary>
        /// 户口地址
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string HKAddress { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 姓
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(3)", CanBeNull = false)]
        public string LastName { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 全名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(8)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 政治面貌
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int SocialCat { get; set; }
        /// <summary>
        /// 联系电话1
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string Tel1 { get; set; }
        /// <summary>
        /// 联系电话2
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string Tel2 { get; set; }
    }
    /// <summary>
    /// 司机 - 资格证信誉考核记录（未启用）
    /// </summary>
    [Serializable]
    [Table(Name = "driver_certificate")]
    public partial class TB_driver_certificate : TBObject<TB_driver_certificate>
    {
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        /// <summary>
        /// 有效期至
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Due { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 号码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Number { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 登记时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
        /// <summary>
        /// 考核类型
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    /// <summary>
    /// 司机 - 日志（未启用）
    /// </summary>
    [Serializable]
    [Table(Name = "driver_log")]
    public partial class TB_driver_log : TBObject<TB_driver_log>
    {
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 说明
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Description { get; set; }
        /// <summary>
        /// 司机
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string DriverId { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 参考ID
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string ReferenceId { get; set; }
        /// <summary>
        /// 登记时间
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime", CanBeNull = false)]
        public DateTime Time { get; set; }
        /// <summary>
        /// 类别
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Type { get; set; }
    }
    [Serializable]
    [Table(Name = "package")]
    public partial class TB_package : TBObject<TB_package>
    {
        /// <summary>
        /// 管理费用
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> AdminFee { get; set; }
        /// <summary>
        /// 套餐编码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string Code { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 押金金额（指导）
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> Deposit { get; set; }
        /// <summary>
        /// 司机人数
        /// </summary>
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> DriverCount { get; set; }
        /// <summary>
        /// 删除标记
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Enabled { get; set; }
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 车型
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string Model { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 套餐名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 归属百分比（0 为租，100 为司机全属）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int OwnershipPercentage { get; set; }
        /// <summary>
        /// 保险
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> Premium { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 租金（指导）
        /// </summary>
        [ColumnAttribute(DbType = "money")]
        public Nullable<decimal> Rent { get; set; }
    }
    /// <summary>
    /// 人员
    /// </summary>
    [Serializable]
    [Table(Name = "person")]
    public partial class TB_person : TBObject<TB_person>
    {
        /// <summary>
        /// 身份证
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(20)")]
        public string CHNId { get; set; }
        /// <summary>
        /// 编码
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)", CanBeNull = false)]
        public string Code { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 出生日期
        /// </summary>
        [ColumnAttribute(DbType = "smalldatetime")]
        public Nullable<DateTime> DayOfBirth { get; set; }
        /// <summary>
        /// 删除标记（0：正常 1：已删除）
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Deleted { get; set; }
        /// <summary>
        /// 部门归属（营业一二三部）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false)]
        public string DepartmentId { get; set; }
        /// <summary>
        /// 名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(2)", CanBeNull = false)]
        public string FirstName { get; set; }
        /// <summary>
        /// 性别
        /// </summary>
        [ColumnAttribute(DbType = "bit")]
        public Nullable<bool> Gender { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 姓
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false)]
        public string LastName { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 全名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(8)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 密码（明文）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(16)")]
        public string Password { get; set; }
        /// <summary>
        /// 岗位
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string PositionId { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 唯一ID用于 membershipProvider
        /// </summary>
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false)]
        public Guid UniqueId { get; set; }
        /// <summary>
        /// 用户名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string UserName { get; set; }
    }
    /// <summary>
    /// 岗位
    /// </summary>
    [Serializable]
    [Table(Name = "position")]
    public partial class TB_position : TBObject<TB_position>
    {
        /// <summary>
        /// 分支
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)")]
        public string Branch { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 说明
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Description { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 级别
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false)]
        public string RankId { get; set; }
    }
    /// <summary>
    /// 级别
    /// </summary>
    [Serializable]
    [Table(Name = "rank")]
    public partial class TB_rank : TBObject<TB_rank>
    {
        /// <summary>
        /// 创建人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string CreatedById { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 说明
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Description { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(6)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false)]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 名称
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 值（越大则越高级）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Value { get; set; }
    }
    /// <summary>
    /// 访问控制表
    /// </summary>
    [Serializable]
    [Table(Name = "sys_acl")]
    public partial class TB_sys_acl : TBObject<TB_sys_acl>
    {
        /// <summary>
        /// 用户或者角色Id
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)", CanBeNull = false, IsPrimaryKey = true)]
        public string ActorId { get; set; }
        /// <summary>
        /// 加入时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 是否被禁止（禁止访问拥有最强的施加效果）
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsForbidden { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 模块Id
        /// </summary>
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid ModuleId { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
    }
    /// <summary>
    /// 批命令表
    /// </summary>
    [Serializable]
    [Table(Name = "sys_batch")]
    public partial class TB_sys_batch : TBObject<TB_sys_batch>
    {
        /// <summary>
        /// 任务来源
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Channel { get; set; }
        /// <summary>
        /// 状态
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Completed { get; set; }
        [ColumnAttribute(DbType = "datetime")]
        public Nullable<DateTime> ExpiryTime { get; set; }
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid Id { get; set; }
        /// <summary>
        /// 最后操作时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastActionTime { get; set; }
        /// <summary>
        /// 明晨
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string Name { get; set; }
        /// <summary>
        /// 优先级别（越大越优先）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Priority { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Remark { get; set; }
        /// <summary>
        /// 计划执行时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime")]
        public Nullable<DateTime> ScheduleTime { get; set; }
        /// <summary>
        /// 发起时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime Time { get; set; }
    }
    /// <summary>
    /// 任务明细
    /// </summary>
    [Serializable]
    [Table(Name = "sys_batch_item")]
    public partial class TB_sys_batch_item : TBObject<TB_sys_batch_item>
    {
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int ActionCount { get; set; }
        /// <summary>
        /// 批次Id（主表）
        /// </summary>
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid BatchId { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)")]
        public string Exception { get; set; }
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string ExceptionTrace { get; set; }
        /// <summary>
        /// 任务Id
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false, IsPrimaryKey = true)]
        public string Id { get; set; }
        /// <summary>
        /// 最后执行时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime LastActionTime { get; set; }
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Ordinal { get; set; }
        /// <summary>
        /// 参数1
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Param1 { get; set; }
        /// <summary>
        /// 参数2
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Param2 { get; set; }
        /// <summary>
        /// 参数3
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Param3 { get; set; }
        /// <summary>
        /// 参数4
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Param4 { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)")]
        public string Remark { get; set; }
        /// <summary>
        /// 分区关键字
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false, IsPrimaryKey = true)]
        public string Section { get; set; }
        /// <summary>
        /// 当前状态
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Status { get; set; }
        /// <summary>
        /// 任务描述
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Task { get; set; }
    }
    /// <summary>
    /// 系统模块（用于权限划分和控制）
    /// </summary>
    [Serializable]
    [Table(Name = "sys_module")]
    public partial class TB_sys_module : TBObject<TB_sys_module>
    {
        /// <summary>
        /// 创建时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 可用否（下线的模块做 False 处理）
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool Enabled { get; set; }
        /// <summary>
        /// 目录归属
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)", CanBeNull = false)]
        public string Folder { get; set; }
        /// <summary>
        /// 标识（系统唯一）
        /// </summary>
        [ColumnAttribute(DbType = "uniqueidentifier", CanBeNull = false, IsPrimaryKey = true)]
        public Guid Id { get; set; }
        /// <summary>
        /// 是否属于信息块（而不是整个页面）
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool IsPage { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime", CanBeNull = false)]
        public DateTime ModifyTime { get; set; }
        /// <summary>
        /// 命名
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(64)", CanBeNull = false)]
        public string Name { get; set; }
        /// <summary>
        /// 排序
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Ordinal { get; set; }
        /// <summary>
        /// 路径
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(256)", CanBeNull = false)]
        public string Path { get; set; }
        /// <summary>
        /// 备注
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 子分类
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(32)")]
        public string SubFolder { get; set; }
    }
    /// <summary>
    /// 系统编码
    /// </summary>
    [Serializable]
    [Table(Name = "sys_sequence")]
    public partial class TB_sys_sequence : TBObject<TB_sys_sequence>
    {
        /// <summary>
        /// 当前计数
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Count { get; set; }
        /// <summary>
        /// 表格（实体名）
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(128)", CanBeNull = false)]
        public string Entity { get; set; }
        /// <summary>
        /// （系统唯一码）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false, IsPrimaryKey = true)]
        public int Id { get; set; }
        /// <summary>
        /// 下限值
        /// </summary>
        [ColumnAttribute(DbType = "int")]
        public Nullable<int> Limit { get; set; }
        /// <summary>
        /// 修改人
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(10)")]
        public string ModifiedById { get; set; }
        /// <summary>
        /// 修改时间
        /// </summary>
        [ColumnAttribute(DbType = "datetime")]
        public Nullable<DateTime> ModifyTime { get; set; }
        /// <summary>
        /// 前序
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(2)", CanBeNull = false)]
        public string Prefix { get; set; }
        /// <summary>
        /// 摘要
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(512)")]
        public string Remark { get; set; }
        /// <summary>
        /// 分隔符
        /// </summary>
        [ColumnAttribute(DbType = "nvarchar(1)")]
        public string Separator { get; set; }
        /// <summary>
        /// 是否短格式
        /// </summary>
        [ColumnAttribute(DbType = "bit", CanBeNull = false)]
        public bool ShortForm { get; set; }
        /// <summary>
        /// 步进（默认为 1 ）
        /// </summary>
        [ColumnAttribute(DbType = "int", CanBeNull = false)]
        public int Step { get; set; }
    }
}
