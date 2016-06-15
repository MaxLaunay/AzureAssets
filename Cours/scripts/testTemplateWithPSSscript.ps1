cd "C:\Users\maxim\Documents\Git\AzureAssets\VSTSBuild\ARM_Template"
Login-AzureRmAccount
$SubscriptionName = "Osiatis CIS - Azure 1"
Select-AzureRmSubscription -Subscriptionid (Get-AzureRmSubscription -SubscriptionName $SubscriptionName).SubscriptionId
$template = ".\template.json"
$parameters = ".\parameters.json"
$rgname = "IPSSI-VSTS-DEMO"
Remove-AzureRmResourceGroup -Name $rgname -force
New-AzureRmResourceGroup -Location WestEurope -name $rgname
New-AzureRmResourceGroupDeployment -ResourceGroupName $rgname -TemplateFile $template -TemplateParameterFile $parameters -DeploymentDebugLogLevel All