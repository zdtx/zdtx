USE [eTaxi]
GO

/****** Object:  Table [dbo].[charge_package]    Script Date: 2020/3/15 21:47:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[charge_package](
	[ChargeId] [nvarchar](6) NOT NULL,
	[PackageId] [nvarchar](6) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Remark] [nvarchar](512) NULL,
	[CreatedById] [nvarchar](10) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[ModifiedById] [nvarchar](10) NOT NULL,
	[ModifyTime] [datetime] NOT NULL,
 CONSTRAINT [PK_car_charge_package] PRIMARY KEY CLUSTERED 
(
	[ChargeId] ASC,
	[PackageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'对套餐是否可用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge_package', @level2type=N'COLUMN',@level2name=N'Enabled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge_package', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge_package', @level2type=N'COLUMN',@level2name=N'CreatedById'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge_package', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge_package', @level2type=N'COLUMN',@level2name=N'ModifiedById'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge_package', @level2type=N'COLUMN',@level2name=N'ModifyTime'
GO

