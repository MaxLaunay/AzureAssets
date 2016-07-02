Login-AzureRmAccount
$SubscriptionName = "Osiatis CIS - Formation Azure"
# Set Account and Subscription

$Subscription = Get-AzureRmSubscription |where {$_.SubscriptionName -eq $SubscriptionName}
Set-AzureRmContext -SubscriptionId $Subscription.SubscriptionId

$i = 0

for ($i = 1;$i -lt 8;$i++){
    Remove-AzureRmResourceGroup -Name guest-IPSSI-$i -force
}

for ($i = 1;$i -lt 8;$i++){
    New-AzureRmResourceGroup -Name guest-IPSSI-$i -force -Location NorthEurope
}