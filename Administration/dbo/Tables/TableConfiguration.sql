CREATE TABLE [dbo].[TableConfiguration](
	[TableConfigurationID] [int] NOT NULL,
	[ModelConfigurationID] [int] NOT NULL,
	[AnalysisServicesTable] [varchar](255) NOT NULL,
	[DoNotProcess] [bit] NOT NULL,
 CONSTRAINT [PK_TableConfiguration] PRIMARY KEY CLUSTERED 
(
	[TableConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TableConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_TableConfiguration_ModelConfiguration] FOREIGN KEY([ModelConfigurationID])
REFERENCES [dbo].[ModelConfiguration] ([ModelConfigurationID])
GO

ALTER TABLE [dbo].[TableConfiguration] CHECK CONSTRAINT [FK_TableConfiguration_ModelConfiguration]
GO
ALTER TABLE [dbo].[TableConfiguration] ADD  CONSTRAINT [DF_TableConfiguration_DoNotProcess]  DEFAULT ((0)) FOR [DoNotProcess]