USE [eTaxi]
GO

/****** Object:  Table [dbo].[charge]    Script Date: 2020/3/9 19:13:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[charge](
	[Id] [nvarchar](6) NOT NULL,
	[Code] [nvarchar](16) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Type] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[SpecifiedMonth] [int] NULL,
	[Remark] [nvarchar](256) NULL,
 CONSTRAINT [PK_car_charge] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'预设收费项编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge', @level2type=N'COLUMN',@level2name=N'Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'收费项名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge', @level2type=N'COLUMN',@level2name=N'Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'收取模式：0 - 按月，1 - 按年，2 - 按实际天数，9 - 临时' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge', @level2type=N'COLUMN',@level2name=N'Type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'指定收费项目发生的月份' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'charge', @level2type=N'COLUMN',@level2name=N'SpecifiedMonth'
GO

