CREATE TABLE [dbo].[PartitioningConfiguration](
	[PartitioningConfigurationID] [int] NOT NULL,
	[TableConfigurationID] [int] NOT NULL,
	[Granularity] [tinyint] NOT NULL,
	[NumberOfPartitionsFull] [int] NOT NULL,
	[NumberOfPartitionsForIncrementalProcess] [int] NOT NULL,
	[MaxDateIsNow] [bit] NOT NULL,
	[MaxDate] [date] NULL,
	[IntegerDateKey] [bit] NOT NULL,
	[TemplateSourceQuery] [varchar](max) NOT NULL,
 CONSTRAINT [PK_PartitioningConfiguration] PRIMARY KEY CLUSTERED 
(
	[PartitioningConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartitioningConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PartitioningConfiguration_TableConfiguration] FOREIGN KEY([TableConfigurationID])
REFERENCES [dbo].[TableConfiguration] ([TableConfigurationID])
GO

ALTER TABLE [dbo].[PartitioningConfiguration] CHECK CONSTRAINT [FK_PartitioningConfiguration_TableConfiguration]
GO
ALTER TABLE [dbo].[PartitioningConfiguration]  WITH CHECK ADD  CONSTRAINT [CK_PartitioningConfiguration_Granularity] CHECK  (([Granularity]=(2) OR [Granularity]=(1) OR [Granularity]=(0)))
GO

ALTER TABLE [dbo].[PartitioningConfiguration] CHECK CONSTRAINT [CK_PartitioningConfiguration_Granularity]
GO
ALTER TABLE [dbo].[PartitioningConfiguration]  WITH CHECK ADD  CONSTRAINT [CK_PartitioningConfiguration_NumberOfPartitionsForIncrementalProcess] CHECK  (([NumberOfPartitionsForIncrementalProcess]<=[NumberOfPartitionsFull]))
GO

ALTER TABLE [dbo].[PartitioningConfiguration] CHECK CONSTRAINT [CK_PartitioningConfiguration_NumberOfPartitionsForIncrementalProcess]