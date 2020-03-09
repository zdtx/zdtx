USE [eTaxi]
GO

/****** Object:  Table [dbo].[car_payment_item]    Script Date: 2020/3/9 19:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[car_payment_item](
	[CarId] [nvarchar](10) NOT NULL,
	[DriverId] [nvarchar](10) NOT NULL,
	[PaymentId] [nvarchar](10) NOT NULL,
	[ItemId] [nvarchar](6) NOT NULL,
	[ChargeId] [nvarchar](5) NULL,
	[Type] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[SpecifiedMonth] [int] NULL,
	[Remark] [nvarchar](128) NULL,
 CONSTRAINT [PK_car_payment_item] PRIMARY KEY CLUSTERED 
(
	[CarId] ASC,
	[DriverId] ASC,
	[PaymentId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'条目 Id，可能来自预设收费条目，也可能是临时添加' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'car_payment_item', @level2type=N'COLUMN',@level2name=N'ItemId'
GO
