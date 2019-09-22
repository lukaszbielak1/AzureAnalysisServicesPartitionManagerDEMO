using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using AsPartitionProcessing;
using Microsoft.Extensions.Logging;

namespace AzureAnalysisServicesPartitionManager
{
    public static class PartitionManager
    {
        private static string _modelConfigurationIDs;
        [FunctionName("PartitionManager")]
        public static async Task<List<string>> RunOrchestrator(
            [OrchestrationTrigger] DurableOrchestrationContext context)
        {
            var outputs = new List<string>();

            outputs.Add(await context.CallActivityAsync<string>("PartitionManager_Run", "1"));

            return outputs;
        }

        [FunctionName("PartitionManager_Run")]
        public static string Run([ActivityTrigger] string input, ILogger log)
        {
            log.LogInformation($"Azure Analysis Services Partion Manager started at: {DateTime.Now}");
            try
            {
                /* read from ASPP_ConfigurationLoggingDB */
                List<ModelConfiguration> modelsConfig = InitializeFromDatabase();

                /* loop through Model Config */
                foreach (ModelConfiguration modelConfig in modelsConfig)
                {
                    /* grab user/pw for AzureAS authentication */
                    String azure_AppID = System.Environment.GetEnvironmentVariable("CONNSTR_APPID");
                    String azure_AppKey = System.Environment.GetEnvironmentVariable("CONNSTR_APPKEY");

                    /* apparently you can do it this way as well */
                    modelConfig.UserName = azure_AppID;
                    modelConfig.Password = azure_AppKey;

                    /* perform processing */
                    PartitionProcessor.PerformProcessing(modelConfig, ConfigDatabaseHelper.LogMessage);
                }
            }
            catch (Exception e)
            {
                log.LogInformation($"Azure Analysis Services Partion Manager exception: {e.ToString()}");
            }

            log.LogInformation($"Azure Analysis Services Partion Manager finished at: {DateTime.Now}");
            return "1";

        }


        [FunctionName("PartitionManager_HttpStart")]
        public static async Task<HttpResponseMessage> PartitionManager_HttpStart(
            [HttpTrigger(AuthorizationLevel.Function, "post")]HttpRequestMessage req,
            [OrchestrationClient]DurableOrchestrationClient starter,
            ILogger log)
        {
            // Function input comes from the request content.
            string instanceId = await starter.StartNewAsync("PartitionManager", null);

            log.LogInformation($"Started orchestration with ID = '{instanceId}'.");

            return starter.CreateCheckStatusResponse(req, instanceId);
        }

        public static List<ModelConfiguration> InitializeFromDatabase()
        {
            ConfigDatabaseConnectionInfo connectionInfo = new ConfigDatabaseConnectionInfo();

            connectionInfo.Server = System.Environment.GetEnvironmentVariable("CONNSTR_SERVER");
            connectionInfo.Database = System.Environment.GetEnvironmentVariable("CONNSTR_DB");
            connectionInfo.UserName = System.Environment.GetEnvironmentVariable("CONNSTR_USER");
            connectionInfo.Password = System.Environment.GetEnvironmentVariable("CONNSTR_PW");

            return ConfigDatabaseHelper.ReadConfig(connectionInfo, _modelConfigurationIDs);
        }
    }
}
