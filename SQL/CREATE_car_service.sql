USE [eTaxi]
GO

/****** Object:  Table [dbo].[car_service]    Script Date: 2020/3/15 21:49:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[car_service](
	[CarId] [nvarchar](10) NOT NULL,
	[Id] [nvarchar](10) NOT NULL,
	[ServiceContent] [nvarchar](128) NOT NULL,
	[ServiceTime] [smalldatetime] NOT NULL,
	[ServiceProvider] [nvarchar](128) NULL,
	[ServiceCost] [money] NULL,
	[Remark] [nvarchar](512) NULL,
	[CreatedById] [nvarchar](10) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[ModifiedById] [nvarchar](10) NOT NULL,
	[ModifyTime] [datetime] NOT NULL,
 CONSTRAINT [PK_car_service] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'维修内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_service', @level2type=N'COLUMN',@level2name=N'ServiceContent'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_service', @level2type=N'COLUMN',@level2name=N'CreatedById'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_service', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_service', @level2type=N'COLUMN',@level2name=N'ModifiedById'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_service', @level2type=N'COLUMN',@level2name=N'ModifyTime'
GO

