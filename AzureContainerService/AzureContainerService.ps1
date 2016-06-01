# Connect to Azure with your account
Login-AzureRmAccount;

# Select Subscription
$SubscriptionName = 'Osiatis CIS - Azure 1';
Select-AzureRmSubscription -Subscriptionid (Get-AzureRmSubscription -SubscriptionName $SubscriptionName).SubscriptionId;

# Create Resource Groups
$rgname = 'MLA-IPSSI-TEST-RG';
$location = 'northeurope';
New-AzureRMResourceGroup -Name $rgname -Location $location -Force;

# Create Container Service Config
$csName = 'MLA-IPSSI-TEST-CS';
$masterDnsPrefixName = 'ipssi-master-cs';
$agentPoolDnsPrefixName = 'ipssi-ap';
$agentPoolProfileName = 'IppsiAgentPool1';
$vmSize = 'Standard_A1';
$orchestratorType = 'DCOS';
$adminUserName = 'maxime.launay';
$sshPublicKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAg26jKpgOHjJHtK/MBQ+j0QsuTGW9S4o2jfT1//uv4PzsqL7y+IUjmL/7gazFiTmmf/CsJb0semLuh8+mA7YPgujOCVUM5N1JuxCCsl+jzijY+KHvIxb3YwBTt8aFD0nRTnMqFiPznwV/D17Dkas/h8S1nY2KqFxcCsBPZ6Kt0eGl/iEoevJB47I0YwnPGEMQY3KD0X0evsAC25MBO21Jyanud+1BAQMZoaTV+eD9u2IoQdnbsSVKLGAepvplU3uWsV9qIXEfkPL/4RkrR5dUytS1PcLumFJUBks+DwCxEhN6INH2lhe43RnGN8u2WSV67kwzHrMJDW6+nRktpggp2w== ipssi-Mesosphere-test';
$container = New-AzureRmContainerServiceConfig -Location $location -OrchestratorType $orchestratorType `
    -MasterDnsPrefix $masterDnsPrefixName -AdminUsername $adminUserName -SshPublicKey $sshPublicKey `
    | Add-AzureRmContainerServiceAgentPoolProfile -Name $agentPoolProfileName -VmSize $vmSize -DnsPrefix $agentPoolDnsPrefixName

# Create Container Service
New-AzureRmContainerService -ResourceGroupName $rgname -Name $csName -ContainerService $container;

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