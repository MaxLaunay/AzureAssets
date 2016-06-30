# Connect to Azure with your account
Login-AzureRmAccount;

# Select Subscription
$SubscriptionName = "Osiatis CIS - Formation Azure";
Select-AzureRmSubscription -Subscriptionid (Get-AzureRmSubscription -SubscriptionName $SubscriptionName).SubscriptionId;

# Create Resource Groups
$rgname = 'MLA-IPSSI-TEST-RG';
$location = 'northeurope';
New-AzureRMResourceGroup -Name $rgname -Location $location -Force;

# Deploy Azure Container Service via ARM
$templateURI = 
$parametersURI = 
New-AzureRmResourceGroupDeployment

# Connect to Azure Container
    # cf. https://azure.microsoft.com/fr-fr/documentation/articles/container-service-connect/

# Get Cluster Agents
    # curl http://localhost/mesos/master/slaves
    Invoke-WebRequest -Uri http://localhost/mesos/master/slaves

# Get current cluster applications
    # curl http://localhost/marathon/v2/apps
    Invoke-WebRequest -Uri http://localhost/marathon/v2/apps

# deploy container
    $inFile = 'https://raw.githubusercontent.com/MaxLaunay/AzureAssets/master/AzureContainerService/templates/nginx.json'
    # curl -X POST http://localhost/marathon/v2/apps -d $content -H "Content-type: application/json"
    Invoke-WebRequest -Method Post -Uri http://localhost/marathon/v2/apps -ContentType application/json -InFile .\templates\nginx.json

# scale container
    Invoke-WebRequest -Method Put -Uri http://localhost/marathon/v2/apps/nginx -ContentType application/json -InFile .\templates\scale.json

function remove{
    Remove-AzureRmResourceGroup -Name $rgname -Force
}