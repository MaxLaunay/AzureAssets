Param(
    [Parameter(Mandatory=$true)][String]$SubscriptionName,
    [Parameter(Mandatory=$true)][String]$rgname,
    [Parameter(Mandatory=$true)][String]$location,
    [Parameter(Mandatory=$true)][String]$vmSize,
    [Parameter(Mandatory=$true)][String]$orchestratorType,
    [Parameter(Mandatory=$true)][String]$adminUserName,
    [Parameter(Mandatory=$true)][String]$sshPublicKey
)

# Params
$csName = $rgname + "-cs";
$masterDnsPrefixName = $rgname + "-master";
$agentPoolDnsPrefixName = $rgname + "-agent";
$agentPoolProfileName = $rgname + "-pool";

# Connect to Azure with your account
Login-AzureRmAccount;

# Select Subscription
$Subscription = Get-AzureRmSubscription |where {$_.SubscriptionName -eq $SubscriptionName}
Set-AzureRmContext -SubscriptionId $Subscription.SubscriptionId

# Create Resource Groups
New-AzureRMResourceGroup -Name $rgname -Location $location -Force;

# Create Container Service Config
$container = New-AzureRmContainerServiceConfig -Location $location -OrchestratorType $orchestratorType `
    -MasterDnsPrefix $masterDnsPrefixName -AdminUsername $adminUserName -SshPublicKey $sshPublicKey `
    | Add-AzureRmContainerServiceAgentPoolProfile -Name $agentPoolProfileName -VmSize $vmSize -DnsPrefix $agentPoolDnsPrefixName

# Create Container Service
New-AzureRmContainerService -ResourceGroupName $rgname -Name $csName -ContainerService $container;