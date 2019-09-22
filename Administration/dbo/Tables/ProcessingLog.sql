CREATE TABLE [dbo].[ProcessingLog](
	[PartitioningLogID] [int] IDENTITY(1,1) NOT NULL,
	[ModelConfigurationID] [int] NOT NULL,
	[ExecutionID] [char](36) NOT NULL,
	[LogDateTime] [datetime] NOT NULL,
	[Message] [varchar](8000) NOT NULL,
	[MessageType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ProcessingLog] PRIMARY KEY CLUSTERED 
(
	[PartitioningLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProcessingLog]  WITH CHECK ADD  CONSTRAINT [FK_ProcessingLog_ModelConfiguration] FOREIGN KEY([ModelConfigurationID])
REFERENCES [dbo].[ModelConfiguration] ([ModelConfigurationID])
GO

ALTER TABLE [dbo].[ProcessingLog] CHECK CONSTRAINT [FK_ProcessingLog_ModelConfiguration]