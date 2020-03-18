/****** Object:  StoredProcedure [dbo].[loadData]    Script Date: 04/03/2020 10:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[loadData] AS

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'CSVFormat') 
CREATE EXTERNAL FILE FORMAT [CSVFormat] 
WITH ( FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2, 
          USE_TYPE_DEFAULT = True)
);

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'ext_ds_lusoare') 
CREATE EXTERNAL DATA SOURCE [ext_ds_lusoare] 
WITH 
(    LOCATION   = 'abfss://filesystem001@mydatalakegen2sa.dfs.core.windows.net', 
      TYPE       = HADOOP,
	  CREDENTIAL = ADLSCredential
);

CREATE EXTERNAL TABLE dbo.ext_factsales
(
	[ProductID] [nvarchar](4000)  NULL,
	[Analyst] [nvarchar](4000)  NULL,
	[Product] [nvarchar](4000)  NULL,
	[CampaignName] [nvarchar](4000)  NULL,
	[Qty] [nvarchar](4000)  NULL,
	[Region] [nvarchar](4000)  NULL,
	[State] [nvarchar](4000)  NULL,
	[City] [nvarchar](4000)  NULL,
	[Revenue] [nvarchar](4000)  NULL,
	[RevenueTarget] [nvarchar](4000)  NULL
)
WITH
(
 LOCATION = 'csv/FactSales.csv', 
 DATA_SOURCE = ext_ds_lusoare, 
 FILE_FORMAT = CSVFormat, 
 REJECT_TYPE = VALUE, 
 REJECT_VALUE = 0
);

CREATE TABLE dbo.factsales
WITH (DISTRIBUTION = ROUND_ROBIN)
AS
SELECT * FROM dbo.ext_factsales
OPTION (LABEL = 'CTAS : Load [dbo].[FactSales]');

