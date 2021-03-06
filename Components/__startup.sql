USE [eTaxi]
GO
/****** 对象:  Table [dbo].[car]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car](
	[Id] [nchar](10) NOT NULL,
	[PlateNumber] [nvarchar](16) NOT NULL,
	[FormerPlateNum] [nvarchar](16) NULL,
	[Manufacturer] [nvarchar](64) NOT NULL,
	[Model] [nvarchar](32) NOT NULL,
	[Type] [int] NOT NULL,
	[Source] [int] NOT NULL,
	[EngineNum] [nvarchar](32) NOT NULL,
	[CarriageNum] [nvarchar](32) NOT NULL,
	[SecSerialNum] [nvarchar](32) NOT NULL,
	[HandOverTime] [timestamp] NOT NULL,
	[HandOverPlace] [nvarchar](128) NOT NULL,
	[License] [nvarchar](32) NOT NULL,
	[LicenseRenewTime] [smalldatetime] NOT NULL,
	[DrvLicense] [nvarchar](32) NOT NULL,
	[DrvLicenseRenewTime] [smalldatetime] NOT NULL,
	[InsuranceCom] [nvarchar](64) NOT NULL,
	[Premium] [money] NOT NULL,
	[InsuranceStart] [smalldatetime] NOT NULL,
	[ServiceCom] [nvarchar](64) NOT NULL,
	[DepartmentId] [nchar](5) NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车牌号码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'PlateNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'原车牌号码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'FormerPlateNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'品牌' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Manufacturer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'型号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Model'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆性质' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆获得方式' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Source'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'发动机号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'EngineNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车架号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'CarriageNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'治安证编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'SecSerialNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'交接班时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'HandOverTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'交接班地点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'HandOverPlace'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'营运证号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'License'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'营运证年审到期日' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'LicenseRenewTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行驶证号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'DrvLicense'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行驶证年审到期日' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'DrvLicenseRenewTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'保险公司' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'InsuranceCom'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'保险费用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Premium'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投保日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'InsuranceStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆定点维修公司' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'ServiceCom'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'部门归属（营运一二三部）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'DepartmentId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car'
GO
/****** 对象:  Table [dbo].[car_accident]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_accident](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Place] [nvarchar](128) NOT NULL,
	[PlateNumber] [nvarchar](16) NOT NULL,
	[DriverId] [nchar](10) NOT NULL,
	[Type] [int] NOT NULL,
	[Description] [nvarchar](256) NULL,
	[Coordinator] [nvarchar](64) NOT NULL,
	[ServiceCom] [nvarchar](64) NULL,
	[Claim] [money] NOT NULL,
	[Result] [nvarchar](256) NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_accident] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'发生时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'发生地点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Place'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车牌号码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'PlateNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'当班驾驶员（司机）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'责任类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'事件经过' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'现场协调处理人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Coordinator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆维修公司' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'ServiceCom'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'理赔金额' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Claim'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'处理结果' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Result'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 交通事故记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_accident'
GO
/****** 对象:  Table [dbo].[car_balance]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_balance](
	[CarId] [nchar](50) NOT NULL,
	[Id] [nchar](50) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Type] [int] NULL,
	[IsIncome] [bit] NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Status] [int] NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_balance] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'费用名目及是由' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否收入项（否则为支出项）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'IsIncome'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'登记时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 费用核算表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_balance'
GO
/****** 对象:  Table [dbo].[car_complain]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_complain](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [datetime] NULL,
	[DriverId] [nchar](10) NOT NULL,
	[Source] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[Description] [nvarchar](256) NOT NULL,
	[ContactPersonn] [nvarchar](256) NULL,
	[Contact] [nvarchar](128) NULL,
	[Coordinator] [nvarchar](128) NULL,
	[OwnFault] [bit] NOT NULL,
	[Result] [nvarchar](256) NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_complain] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投诉时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'当班驾驶员（司机）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投诉来源' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Source'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投诉类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投诉主要内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投诉人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'ContactPersonn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'投诉人联系方式' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Contact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'接待处理人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Coordinator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'驾驶员有无责任' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'OwnFault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'处理结果' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Result'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 投诉' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_complain'
GO
/****** 对象:  Table [dbo].[car_inspection]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_inspection](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Year] [nchar](4) NOT NULL,
	[TransactionCode] [nvarchar](64) NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_inspection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[CarId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_inspection', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_inspection', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'年审时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_inspection', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_inspection', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 年审记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_inspection'
GO
/****** 对象:  Table [dbo].[car_insurance]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_insurance](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[TransactionCode] [nvarchar](64) NOT NULL,
	[ServiceCom] [nvarchar](64) NULL,
	[Product] [nvarchar](128) NULL,
	[Contact] [nvarchar](256) NULL,
	[EndTime] [smalldatetime] NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_insurance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[CarId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'承保合同流水码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'TransactionCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'保险公司' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'ServiceCom'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'险种' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'Product'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代理联系人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'Contact'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'保单到期日' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'EndTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 保险记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_insurance'
GO
/****** 对象:  Table [dbo].[car_log]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_log](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Type] [int] NOT NULL,
	[ReferenceId] [nvarchar](32) NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_car_log] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（内部唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'写入时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'参考ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'ReferenceId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标题' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 日志' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_log'
GO
/****** 对象:  Table [dbo].[car_rental]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_rental](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[StartTime] [smalldatetime] NOT NULL,
	[EndTime] [smalldatetime] NOT NULL,
	[Rental] [money] NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_rental] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（内部唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'签订时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'开始时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'StartTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'结束时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'EndTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'租金（按月）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'Rental'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 承租记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental'
GO
/****** 对象:  Table [dbo].[car_rental_driver]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_rental_driver](
	[CarId] [nchar](10) NOT NULL,
	[RentalId] [nchar](10) NOT NULL,
	[DriverId] [nchar](10) NOT NULL,
 CONSTRAINT [PK_car_rental_driver] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[RentalId] ASC,
	[DriverId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_driver', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'合同' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_driver', @level2type=N'COLUMN',@level2name=N'RentalId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_driver', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 承租合同 - 司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_driver'
GO
/****** 对象:  Table [dbo].[car_rental_payment]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_rental_payment](
	[CarId] [nvarchar](10) NOT NULL,
	[Id] [nvarchar](10) NOT NULL,
	[Due] [smalldatetime] NOT NULL,
	[Month] [nchar](6) NOT NULL,
	[Amount] [money] NOT NULL,
	[Paid] [money] NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_rental_payment] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'到期日' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'Due'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'月份归属' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'Month'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'总额' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'Amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'已付' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'Paid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 承租合同 - 费用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_payment'
GO
/****** 对象:  Table [dbo].[car_rental_shift]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_rental_shift](
	[CarId] [nchar](10) NOT NULL,
	[RentalId] [nchar](10) NOT NULL,
	[DriverId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Reason] [nvarchar](512) NOT NULL,
	[StartTime] [smalldatetime] NOT NULL,
	[EndTime] [smalldatetime] NOT NULL,
	[SubDriverId] [nchar](50) NOT NULL,
	[Status] [int] NOT NULL,
	[ConfirmedDays] [int] NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_rental_shift_1] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[RentalId] ASC,
	[DriverId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'承租' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'RentalId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'申请时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代班原因' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'Reason'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代班开始' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'StartTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代班结束' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'EndTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代班司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'SubDriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代班天数' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'ConfirmedDays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 承租 - 代班记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_rental_shift'
GO
/****** 对象:  Table [dbo].[car_violation]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_violation](
	[CarId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[DriverId] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Place] [nvarchar](128) NOT NULL,
	[Type] [int] NOT NULL,
	[Reason] [nvarchar](512) NOT NULL,
	[Severity] [int] NOT NULL,
	[Fine] [money] NOT NULL,
	[DemeritPoints] [int] NOT NULL,
	[Remarks] [nvarchar](512) NULL,
 CONSTRAINT [PK_car_violation] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'CarId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'违章时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'违章地点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Place'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'违章类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'处罚内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Reason'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'违章性质' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Severity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'罚款' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Fine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'扣分' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'DemeritPoints'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation', @level2type=N'COLUMN',@level2name=N'Remarks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车辆 - 交通违章记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_violation'
GO
/****** 对象:  Table [dbo].[department]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[department](
	[Id] [nchar](5) NOT NULL,
	[ParentId] [nchar](5) NOT NULL,
	[RootId] [nchar](5) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Path] [nvarchar](500) NOT NULL,
	[Dept] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Description] [nvarchar](256) NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'父部门' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'ParentId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'根部门' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'RootId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'路径' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Path'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'深度' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Dept'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'同层排序值（越小越靠前）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'部门' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'department'
GO
/****** 对象:  Table [dbo].[driver]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[driver](
	[Id] [nchar](50) NOT NULL,
	[Name] [nvarchar](8) NOT NULL,
	[FirstName] [nvarchar](2) NOT NULL,
	[LastName] [nvarchar](6) NOT NULL,
	[Gender] [int] NOT NULL,
	[CHNId] [nvarchar](20) NOT NULL,
	[DayOfBirth] [smalldatetime] NOT NULL,
	[Education] [int] NOT NULL,
	[SocialCat] [int] NOT NULL,
	[Tel1] [nvarchar](16) NULL,
	[Tel2] [nvarchar](16) NULL,
	[Enabled] [bit] NOT NULL,
	[CareerStart] [smalldatetime] NOT NULL,
	[Type] [int] NOT NULL,
	[DepartmentId] [nchar](5) NOT NULL,
	[Guarantor] [nvarchar](64) NOT NULL,
	[HKAddress] [nvarchar](256) NULL,
	[Address] [nvarchar](256) NOT NULL,
	[ContactPerson] [nvarchar](64) NULL,
	[ContactNumber] [nvarchar](32) NULL,
	[Status] [int] NOT NULL,
	[CertNumber] [nvarchar](64) NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_driver] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'全名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'FirstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'姓' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'LastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'性别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'身份证' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'CHNId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'出生日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'DayOfBirth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'文化程度' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Education'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'政治面貌' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'SocialCat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'联系电话1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Tel1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'联系电话2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Tel2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'从业时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'CareerStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'公司归属类别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'部门归宿（营运一二三部）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'DepartmentId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'介绍人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Guarantor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'户口地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'HKAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'常住地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'亲属联系人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'ContactPerson'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'亲属联系电话' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'ContactNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'人员状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'从业资格证号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'CertNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver'
GO
/****** 对象:  Table [dbo].[driver_certificate]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[driver_certificate](
	[DriverId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Due] [smalldatetime] NOT NULL,
	[Type] [int] NOT NULL,
	[Number] [nvarchar](64) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_driver_certificate] PRIMARY KEY CLUSTERED 
(
	[DriverId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'登记时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'有效期至' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Due'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'考核类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'号码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机 - 资格证信誉考核记录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_certificate'
GO
/****** 对象:  Table [dbo].[driver_log]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[driver_log](
	[DriverId] [nchar](10) NOT NULL,
	[Id] [nchar](10) NOT NULL,
	[Time] [smalldatetime] NOT NULL,
	[Type] [int] NOT NULL,
	[ReferenceId] [nvarchar](32) NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](256) NULL,
 CONSTRAINT [PK_driver_log] PRIMARY KEY CLUSTERED 
(
	[DriverId] ASC,
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'DriverId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'登记时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'类别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'参考ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'ReferenceId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机 - 日志' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'driver_log'
GO
/****** 对象:  Table [dbo].[person]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person](
	[Id] [nchar](10) NOT NULL,
	[Code] [nvarchar](16) NOT NULL,
	[Name] [nvarchar](8) NOT NULL,
	[FirstName] [nvarchar](2) NOT NULL,
	[LastName] [nvarchar](6) NOT NULL,
	[Gender] [int] NOT NULL,
	[CHNId] [nvarchar](20) NULL,
	[DayOfBirth] [smalldatetime] NULL,
	[DepartmentId] [nchar](5) NOT NULL,
	[PositionId] [nchar](10) NOT NULL,
 CONSTRAINT [PK_person] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'全名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'FirstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'姓' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'LastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'性别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'Gender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'身份证' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'CHNId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'出生日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'DayOfBirth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'部门归属（营业一二三部）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'DepartmentId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'岗位' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person', @level2type=N'COLUMN',@level2name=N'PositionId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'人员' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'person'
GO
/****** 对象:  Table [dbo].[position]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[position](
	[Id] [nchar](5) NOT NULL,
	[RankId] [nchar](5) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](512) NULL,
 CONSTRAINT [PK_position] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'position', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'级别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'position', @level2type=N'COLUMN',@level2name=N'RankId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'position', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'position', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'岗位' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'position'
GO
/****** 对象:  Table [dbo].[rank]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rank](
	[Id] [nchar](5) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Value] [int] NOT NULL,
	[Description] [nvarchar](512) NULL,
 CONSTRAINT [PK_rank] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rank', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rank', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'值（越小、则越高级）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rank', @level2type=N'COLUMN',@level2name=N'Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rank', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'级别' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rank'
GO
/****** 对象:  Table [dbo].[sys_sequence]    脚本日期: 03/08/2016 13:29:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_sequence](
	[Id] [nvarchar](10) NOT NULL,
	[Entity] [nvarchar](128) NOT NULL,
	[Prefix] [nchar](2) NOT NULL,
	[Separator] [nchar](1) NULL,
	[Count] [int] NOT NULL,
	[Limit] [int] NULL,
	[ShortForm] [bit] NOT NULL,
	[Step] [int] NOT NULL,
	[Remark] [nvarchar](512) NULL,
 CONSTRAINT [PK_sys_sequence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'（系统唯一码）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'表格（实体名）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Entity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'前序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Prefix'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'分隔符' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Separator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'当前计数' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Count'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'下限值' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Limit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否短格式' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'ShortForm'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'步进（默认为 1 ）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Step'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence', @level2type=N'COLUMN',@level2name=N'Remark'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'系统编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sys_sequence'