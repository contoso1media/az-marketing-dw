SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM dbo.sysobjects where name = 'Customer')

	CREATE TABLE [dbo].[Customer]
	(
		[Id] [int] NOT NULL,
		[Name] [varchar](50) NULL,
		[Surname] [varchar](50) NOT NULL
	)
	WITH
	(
		DISTRIBUTION = ROUND_ROBIN,
		CLUSTERED COLUMNSTORE INDEX
	)

GO