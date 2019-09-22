-- Add user to the database owner role
EXEC sp_addrolemember N'db_datawriter', N'AzureAnalysisServicesPartitionManager'
GO
EXEC sp_addrolemember N'db_datareader', N'AzureAnalysisServicesPartitionManager'