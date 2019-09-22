﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace AsPartitionProcessing
{
    /// <summary>
    /// Class containing helper methods for reading and writing to the configuration and logging database.
    /// </summary>
    public static class ConfigDatabaseHelper
    {
        /// <summary>
        /// Read configuration information from the database.
        /// </summary>
        /// <param name="connectionInfo">Information required to connect to the configuration and logging database.</param>
        /// <param name="modelConfigurationIDs">Comma-delimited list of ModelConfigurationIDs to filter on when getting worklist from the configuration and logging database.</param>
        /// <returns>Collection of partitioned models with configuration information.</returns>
        public static List<ModelConfiguration> ReadConfig(ConfigDatabaseConnectionInfo connectionInfo, string modelConfigurationIDs)
        {
            string commandText = String.Format(@"  
                        SELECT [ModelConfigurationID]
                              ,[AnalysisServicesServer]
                              ,[AnalysisServicesDatabase]
                              ,[InitialSetUp]
                              ,[IncrementalOnline]
                              ,[IntegratedAuth]
                              ,[ServicePrincipal]
                              ,[MaxParallelism]
                              ,[CommitTimeout]
                              ,[RetryAttempts]
                              ,[RetryWaitTimeSeconds]
                              ,[TableConfigurationID]
                              ,[AnalysisServicesTable]
                              ,[Partitioned]
                              ,[PartitioningConfigurationID]
                              ,[Granularity]
                              ,[NumberOfPartitionsFull]
                              ,[NumberOfPartitionsForIncrementalProcess]
                              ,[MaxDateIsNow]
                              ,[MaxDate]
                              ,[IntegerDateKey]
                              ,[TemplateSourceQuery]
                          FROM [dbo].[vPartitioningConfiguration]
                          WHERE [DoNotProcess] = 0 {0}
                          ORDER BY
                               [ModelConfigurationID],
                               [TableConfigurationID],
                               [PartitioningConfigurationID];",
                               (String.IsNullOrEmpty(modelConfigurationIDs) ? "" : $" AND [ModelConfigurationID] IN ({modelConfigurationIDs}) "));

            using (SqlConnection connection = new SqlConnection(GetConnectionString(connectionInfo)))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.Text;
                    command.CommandText = commandText;

                    List<ModelConfiguration> modelConfigs = new List<ModelConfiguration>();
                    ModelConfiguration modelConfig = null;
                    int currentModelConfigurationID = -1;
                    TableConfiguration tableConfig = null;
                    int currentTableConfigurationID = -1;

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        if (modelConfig == null || currentModelConfigurationID != Convert.ToInt32(reader["ModelConfigurationID"]))
                        {
                            modelConfig = new ModelConfiguration();
                            modelConfig.TableConfigurations = new List<TableConfiguration>();
                            modelConfigs.Add(modelConfig);

                            modelConfig.ModelConfigurationID = Convert.ToInt32(reader["ModelConfigurationID"]);
                            modelConfig.AnalysisServicesServer = Convert.ToString(reader["AnalysisServicesServer"]);
                            modelConfig.AnalysisServicesDatabase = Convert.ToString(reader["AnalysisServicesDatabase"]);
                            modelConfig.InitialSetUp = Convert.ToBoolean(reader["InitialSetUp"]);
                            modelConfig.IncrementalOnline = Convert.ToBoolean(reader["IncrementalOnline"]);
                            modelConfig.IntegratedAuth = Convert.ToBoolean(reader["IntegratedAuth"]);
                            modelConfig.ServicePrincipalTokenAuth = Convert.ToBoolean(reader["ServicePrincipal"]);
                            modelConfig.MaxParallelism = Convert.ToInt32(reader["MaxParallelism"]);
                            modelConfig.CommitTimeout = Convert.ToInt32(reader["CommitTimeout"]);
                            modelConfig.RetryAttempts = Convert.ToInt32(reader["RetryAttempts"]);
                            modelConfig.RetryWaitTimeSeconds = Convert.ToInt32(reader["RetryWaitTimeSeconds"]);
                            modelConfig.ConfigDatabaseConnectionInfo = connectionInfo;

                            currentModelConfigurationID = modelConfig.ModelConfigurationID;
                        }

                        if (tableConfig == null || currentTableConfigurationID != Convert.ToInt32(reader["TableConfigurationID"]))
                        {
                            tableConfig = new TableConfiguration();
                            tableConfig.PartitioningConfigurations = new List<PartitioningConfiguration>();
                            modelConfig.TableConfigurations.Add(tableConfig);

                            tableConfig.TableConfigurationID = Convert.ToInt32(reader["TableConfigurationID"]);
                            tableConfig.AnalysisServicesTable = Convert.ToString(reader["AnalysisServicesTable"]);

                            currentTableConfigurationID = tableConfig.TableConfigurationID;
                        }

                        if (Convert.ToBoolean(reader["Partitioned"]))
                        {
                            tableConfig.PartitioningConfigurations.Add(
                                new PartitioningConfiguration(
                                    Convert.ToInt32(reader["PartitioningConfigurationID"]),
                                    (Granularity)Convert.ToInt32(reader["Granularity"]),
                                    Convert.ToInt32(reader["NumberOfPartitionsFull"]),
                                    Convert.ToInt32(reader["NumberOfPartitionsForIncrementalProcess"]),
                                    Convert.ToBoolean(reader["MaxDateIsNow"]),
                                    (reader["MaxDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(reader["MaxDate"])),
                                    Convert.ToBoolean(reader["IntegerDateKey"]),
                                    Convert.ToString(reader["TemplateSourceQuery"])
                                )
                            );
                        }
                    }

                    return modelConfigs;
                }
            }
        }

        /// <summary>
        /// Delete all existing logs from the database. Useful in demo scenarios to initialize the database.
        /// </summary>
        /// <param name="connectionInfo">Information required to connect to the configuration and logging database.</param>
        public static void ClearLogTable(ConfigDatabaseConnectionInfo connectionInfo)
        {
            using (var connection = new SqlConnection(GetConnectionString(connectionInfo)))
            {
                connection.Open();
                using (var command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.Text;
                    command.CommandText = "DELETE FROM [dbo].[ProcessingLog];";
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Log a message to the databsae.
        /// </summary>
        /// <param name="message">Message to be logged.</param>
        /// <param name="partitionedModel">Partitioned model with configuration information.</param>
        public static void LogMessage(string message, MessageType messageType, ModelConfiguration partitionedModel)
        {
            using (var connection = new SqlConnection(GetConnectionString(partitionedModel.ConfigDatabaseConnectionInfo)))
            {
                connection.Open();
                using (var command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.Text;
                    command.CommandText = @"
                        INSERT INTO [dbo].[ProcessingLog]
                               ([ModelConfigurationID]
                               ,[ExecutionID]
                               ,[LogDateTime]
                               ,[Message]
                               ,[MessageType])
                         VALUES
                               (@ModelConfigurationID
                               ,@ExecutionID
                               ,@LogDateTime
                               ,@Message
                               ,@MessageType);";
                
                    SqlParameter parameter;

                    parameter = new SqlParameter("@ModelConfigurationID", SqlDbType.Int);
                    parameter.Value = partitionedModel.ModelConfigurationID;
                    command.Parameters.Add(parameter);

                    parameter = new SqlParameter("@ExecutionID", SqlDbType.Char, 36);
                    parameter.Value = partitionedModel.ExecutionID;
                    command.Parameters.Add(parameter);

                    parameter = new SqlParameter("@LogDateTime", SqlDbType.DateTime);
                    parameter.Value = DateTime.Now;
                    command.Parameters.Add(parameter);

                    parameter = new SqlParameter("@Message", SqlDbType.VarChar, 4000);
                    parameter.Value = message;
                    command.Parameters.Add(parameter);

                    parameter = new SqlParameter("@MessageType", SqlDbType.VarChar, 50);
                    parameter.Value = messageType.ToString();
                    command.Parameters.Add(parameter);

                    command.ExecuteNonQuery();
                }
            }
        }

        private static string GetConnectionString(ConfigDatabaseConnectionInfo connectionInfo)
        {
            string connectionString;
            if (connectionInfo.IntegratedAuth)
            {
                connectionString = $"Server={connectionInfo.Server};Database={connectionInfo.Database};Integrated Security=SSPI;";
            }
            else
            {
                connectionString = $"Server={connectionInfo.Server};Database={connectionInfo.Database};User ID={connectionInfo.UserName};Password={connectionInfo.Password};";
            }

            return connectionString;
        }
    }

    /// <summary>
    /// Enumeration of log message types.
    /// </summary>
    public enum MessageType
    {
        Informational,
        Error
    }
}
