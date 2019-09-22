
USE [Administration]
GO


SET QUOTED_IDENTIFIER ON
GO

INSERT [dbo].[ModelConfiguration] ([ModelConfigurationID], [AnalysisServicesServer], [AnalysisServicesDatabase], [InitialSetUp], [IncrementalOnline], [IntegratedAuth], [ServicePrincipal], [MaxParallelism], [CommitTimeout], [RetryAttempts], [RetryWaitTimeSeconds]) VALUES (1, N'asazure://westeurope.asazure.windows.net/worldwideimporterstorun', N'WorldWideImporters', 1, 1, 0, 1, -1, -1, 0, 0)
GO


INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (1, 1, N'City', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (2, 1, N'Customer', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (3, 1, N'Date', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (4, 1, N'Employee', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (5, 1, N'Movement', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (6, 1, N'Order', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (7, 1, N'Payment Method', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (8, 1, N'Purchase', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (9, 1, N'Sale', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (10, 1, N'Stock Holding', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (11, 1, N'Stock Item', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (12, 1, N'Supplier', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (13, 1, N'Transaction', 0)
GO

INSERT [dbo].[TableConfiguration] ([TableConfigurationID], [ModelConfigurationID], [AnalysisServicesTable], [DoNotProcess]) VALUES (14, 1, N'Transaction Type', 0)
GO


INSERT [dbo].[PartitioningConfiguration] ([PartitioningConfigurationID], [TableConfigurationID], [Granularity], [NumberOfPartitionsFull], [NumberOfPartitionsForIncrementalProcess], [MaxDateIsNow], [MaxDate], [IntegerDateKey], [TemplateSourceQuery]) VALUES (1, 5, 0, 10, 5, 0, '2016-05-31', 1, N'SELECT * FROM [tabular].[vMovement] WHERE [Date Key Int] >={0} AND [Date Key Int] <{1} ')
INSERT [dbo].[PartitioningConfiguration] ([PartitioningConfigurationID], [TableConfigurationID], [Granularity], [NumberOfPartitionsFull], [NumberOfPartitionsForIncrementalProcess], [MaxDateIsNow], [MaxDate], [IntegerDateKey], [TemplateSourceQuery]) VALUES (2, 6, 0, 10, 5, 0, '2016-05-31', 1, N'SELECT * FROM [tabular].[vOrder] WHERE [Date Key Int] >={0} AND [Date Key Int] <{1} ')
INSERT [dbo].[PartitioningConfiguration] ([PartitioningConfigurationID], [TableConfigurationID], [Granularity], [NumberOfPartitionsFull], [NumberOfPartitionsForIncrementalProcess], [MaxDateIsNow], [MaxDate], [IntegerDateKey], [TemplateSourceQuery]) VALUES (3, 8, 0, 10, 5, 0, '2016-05-31', 1, N'SELECT * FROM [tabular].[vPurchase] WHERE [Date Key Int] >={0} AND [Date Key Int] <{1} ')
INSERT [dbo].[PartitioningConfiguration] ([PartitioningConfigurationID], [TableConfigurationID], [Granularity], [NumberOfPartitionsFull], [NumberOfPartitionsForIncrementalProcess], [MaxDateIsNow], [MaxDate], [IntegerDateKey], [TemplateSourceQuery]) VALUES (4, 9, 0, 10, 5, 0, '2016-05-31', 1, N'SELECT * FROM [tabular].[vSale] WHERE [Date Key Int] >={0} AND [Date Key Int] <{1} ')
INSERT [dbo].[PartitioningConfiguration] ([PartitioningConfigurationID], [TableConfigurationID], [Granularity], [NumberOfPartitionsFull], [NumberOfPartitionsForIncrementalProcess], [MaxDateIsNow], [MaxDate], [IntegerDateKey], [TemplateSourceQuery]) VALUES (5, 13, 0, 10, 5, 0, '2016-05-31', 1, N'SELECT * FROM [tabular].[vTransaction] WHERE [Date Key Int] >={0} AND [Date Key Int] <{1} ')