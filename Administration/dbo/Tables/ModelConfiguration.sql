CREATE TABLE [dbo].[ModelConfiguration](
	[ModelConfigurationID] [int] NOT NULL,
	[AnalysisServicesServer] [varchar](255) NOT NULL,
	[AnalysisServicesDatabase] [varchar](255) NOT NULL,
	[InitialSetUp] [bit] NOT NULL,
	[IncrementalOnline] [bit] NOT NULL,
	[IntegratedAuth] [bit] NOT NULL,
	[ServicePrincipal] [bit] NOT NULL,
	[MaxParallelism] [int] NOT NULL,
	[CommitTimeout] [int] NOT NULL,
	[RetryAttempts] [tinyint] NOT NULL,
	[RetryWaitTimeSeconds] [int] NOT NULL,
 CONSTRAINT [PK_ModelConfiguration] PRIMARY KEY CLUSTERED 
(
	[ModelConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]