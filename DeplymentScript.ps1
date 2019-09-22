#Parameters for Azure Analysis Services Partition Deployment
$ResourceGroup = ""
$AppServiceName = ""
$FunctionAppName = ""
$StorageAccountName = ""
$StorageAccountLocation = ""
$StorageAccountSKU = ""



#DeploymentScript

#Create AppService plan
az appservice plan create -g $ResourceGroup -n $AppServiceName --sku "B1" 

#Create Storage Account
az storage account create -g $ResourceGroup -n $StorageAccountName -l $StorageAccountLocation --sku $StorageAccountSKU

#Create Azure Function Instance
az functionapp create -g $ResourceGroup  -p $AppServiceName -n $FunctionAppName -s $StorageAccountName 

#Change Version of Azure Function to V1
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings FUNCTIONS_EXTENSION_VERSION=~1

#Deploy Azure Analysis Services Partition Manager
az functionapp deployment source config -n $FunctionAppName -g $ResourceGroup  --repo-url "https://github.com/lukaszbielak1/AzureAnalysisServicesPartitionManager.git"

#Parameters for Azure Analysis Services Partition Connection
$AppID = ""
$AppKey = ""
$ConfigurationServerAddress = ""
$ConfigurationDatabaseName = ""
$ConfigurationDatabaseUser = ""
$ConfigurationDatabaseUserPassword = ""

#Set AppID
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings CONNSTR_APPID=$AppID

#Set AppKey
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings CONNSTR_APPKEY=$AppKey

#Set Server Address
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings CONNSTR_SERVER=$ConfigurationServerAddress

#Set Configuration Database Name
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings CONNSTR_DB=$ConfigurationDatabaseName

#Set Configuration Database User
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings CONNSTR_USER=$ConfigurationDatabaseUser

#Set Configuration Database User Password
az functionapp config appsettings set -n $FunctionAppName -g $ResourceGroup --settings CONNSTR_PW=$ConfigurationDatabaseUserPassword






