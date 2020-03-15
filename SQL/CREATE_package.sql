USE [eTaxi]
GO

/****** Object:  Table [dbo].[package]    Script Date: 2020/3/15 21:48:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[package](
	[Id] [nvarchar](6) NOT NULL,
	[Code] [nvarchar](16) NULL,
	[Name] [nvarchar](128) NOT NULL,
	[OwnershipPercentage] [int] NOT NULL,
	[Deposit] [money] NULL,
	[Rent] [money] NULL,
	[AdminFee] [money] NULL,
	[Model] [nvarchar](32) NULL,
	[Premium] [money] NULL,
	[DriverCount] [int] NULL,
	[Enabled] [bit] NOT NULL,
	[Remark] [nvarchar](512) NULL,
	[CreatedById] [nvarchar](10) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[ModifiedById] [nvarchar](10) NOT NULL,
	[ModifyTime] [datetime] NOT NULL,
 CONSTRAINT [PK_package] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'套餐编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'套餐名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'归属百分比（0 为租，100 为司机全属）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'OwnershipPercentage'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'押金金额（指导）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Deposit'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'租金（指导）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Rent'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'管理费用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'AdminFee'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'车型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Model'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'保险' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Premium'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'司机人数' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'DriverCount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标记' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Enabled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'CreatedById'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'ModifiedById'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'package', @level2type=N'COLUMN',@level2name=N'ModifyTime'
GO

