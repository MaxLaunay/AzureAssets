# Connect to Azure with your account
Login-AzureRmAccount;

# Select Subscription
$SubscriptionName = "Osiatis CIS - Formation Azure";
Select-AzureRmSubscription -Subscriptionid (Get-AzureRmSubscription -SubscriptionName $SubscriptionName).SubscriptionId;

# Create Resource Groups
$rgname = 'MLA-IPSSI-DCOS-RG';
$location = 'northeurope';
New-AzureRMResourceGroup -Name $rgname -Location $location -Force;

# Deploy Azure Container Service via ARM
$templateURI = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-acs-dcos/azuredeploy.json"
$parametersURI = "https://raw.githubusercontent.com/MaximeLaunay/AzureAssets/dev/AzureContainerService/templates/dcos.azuredeploy.parameters.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $rgname -TemplateParameterUri $parametersURI `
    -TemplateUri $templateURI -DeploymentDebugLogLevel All -Name ACSDeployment