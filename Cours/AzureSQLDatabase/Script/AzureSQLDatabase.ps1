Param(   
    [Parameter(Mandatory=$true)][String]$SubscriptionName,
    [Parameter(Mandatory=$true)][String]$FirewallIP,
    [Parameter(Mandatory=$true)][String]$PosteNumber,
    [Parameter(Mandatory=$true)][String]$mail
)

$SubscriptionName = "Osiatis CIS - Azure 1"
$FirewallIP = "31.33.101.85"
$PosteNumber = "master"
$mail = "maxime.launay@gmail.com"

# Set Account and Subscription
Login-AzureRmAccount
$Subscription = Get-AzureRmSubscription |where {$_.SubscriptionName -eq $SubscriptionName}
Set-AzureRmContext -SubscriptionId $Subscription.SubscriptionId

# Set Params
$ResourceGroupName = "IPSSI-DEMO-RG"
$Location = "North Europe"
$ServerName = "ipssi-demo-sql-server-$PosteNumber"
$FirewallRuleName = "Perso"
$FirewallStartIP = $FirewallIP
$FirewallEndIp = $FirewallIP
$DatabaseName = "ipssi-demo-sql-db-1"
$DatabaseNameTemp = "ipssi-demo-sql-db-2"
$DatabaseEdition = "Standard"
$PoolEdition = "Standard"
$DatabasePerfomanceLevel = "S0"
$poolName = "IPSSI-ElasticPool-1"


# Create Resource Group
$ResourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

# Create SQL Server
$Server = New-AzureRmSqlServer -ResourceGroupName $ResourceGroupName -ServerName $ServerName -Location $Location -ServerVersion "12.0"

# Set Firewall Rule
$FirewallRule = New-AzureRmSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $ServerName -FirewallRuleName $FirewallRuleName -StartIpAddress $FirewallStartIP -EndIpAddress $FirewallEndIp

# Create Database
$SqlDatabase = New-AzureRmSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName -Edition $DatabaseEdition -RequestedServiceObjectiveName $DatabasePerfomanceLevel

# Verify database
$SqlDatabase

# Create an Elastic Pool
New-AzureRmSqlElasticPool -ResourceGroupName $resourceGroupName -ServerName $serverName -ElasticPoolName $poolName -Edition $PoolEdition -Dtu 400 -DatabaseDtuMin 10 -DatabaseDtuMax 100

# Create a new SQL Databse in the Pool
New-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $DatabaseNameTemp -ElasticPoolName $poolName -MaxSizeBytes 10GB

# Move a database into an elastic pool
Set-AzureRmSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $DatabaseName -ElasticPoolName $poolName

# Change performance settings of a pool (A retester)
Set-AzureRmSqlElasticPool –ResourceGroupName $resourceGroupName –ServerName $serverName –ElasticPoolName $poolName –Dtu 1200 –DatabaseDtuMax 100 –DatabaseDtuMin 50 

# Get the status of pool operations
Get-AzureRmSqlElasticPoolActivity –ResourceGroupName $resourceGroupName –ServerName $serverName –ElasticPoolName $poolName

# Get the status of moving an elastic database into and out of a pool
Get-AzureRmSqlDatabaseActivity -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $DatabaseName -ElasticPoolName $poolName


# Target Resource ID
$PoolResourceID = (Get-AzureRmSqlElasticPool -ResourceGroupName $resourceGroupName -ServerName $serverName -ElasticPoolName $poolName).ResourceId

# Get resource usage data for an elastic database
$date = get-date
$EndTime = $date.ToShortDateString()
$StartTime = ($date.AddDays(-3)).ToShortDateString()

$metrics = (Get-AzureRmMetric -ResourceId $PoolResourceID `
    -TimeGrain ([TimeSpan]::FromMinutes(5)) -StartTime $StartTime -EndTime $EndTime)
$metrics

# Create an email action
$actionEmail = New-AzureRmAlertRuleEmail -SendToServiceOwners -CustomEmail $mail

# create a unique rule name
$alertName = $poolName + "- DTU consumption rule"

# Create an alert rule for DTU_consumption_percent
Add-AzureRMMetricAlertRule -Name $alertName -Location $location -ResourceGroup $resourceGroupName -TargetResourceId $ResourceID `
    -MetricName "DTU_consumption_percent"  -Operator GreaterThan -Threshold 80  `
    -TimeAggregationOperator Average -WindowSize 00:05:00 -Actions $actionEmail 

# Add alerts to all databases in a pool
    # Get the list of databases in this pool.
    $dbList = Get-AzureRmSqlElasticPoolDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -ElasticPoolName $poolName

    # Create an email action
    $actionEmail = New-AzureRmAlertRuleEmail -SendToServiceOwners -CustomEmail $mail

    # Get resource usage metrics for a database in an elastic database for the specified time interval.
    foreach ($db in $dbList){
    
        # create a unique rule name
        $alertName = $db.DatabaseName + "- DTU consumption rule"

        # Create an alert rule for DTU_consumption_percent
        Add-AzureRMMetricAlertRule -Name $alertName  -Location $location -ResourceGroup $resourceGroupName -TargetResourceId $db.ResourceId -MetricName "dtu_consumption_percent"  -Operator GreaterThan -Threshold 80 -TimeAggregationOperator Average -WindowSize 00:05:00 -Actions $actionEmail

        # drop the alert rule
        #Remove-AzureRmAlertRule -ResourceGroup $resourceGroupName -Name $alertName
    } 





# retrieve resource consumption metrics for a pool and its databases
    $date = get-date
    $StartTime = ($date.ToUniversalTime()).ToShortDateString() + " 00:00:00"
    $EndTime = ($date.ToUniversalTime()).ToShortDateString() + " 23:59:59"

    # Construct the pool resource ID and retrive pool metrics at 60 minute granularity.
    $PoolResourceID = (Get-AzureRmSqlElasticPool -ResourceGroupName $resourceGroupName -ServerName $serverName -ElasticPoolName $poolName).ResourceId
    $poolMetrics = (Get-AzureRmMetric -ResourceId $poolResourceId -TimeGrain ([TimeSpan]::FromMinutes(60)) -StartTime $startTime -EndTime $endTime) 

    # Get the list of databases in this pool.
    $dbList = Get-AzureRmSqlElasticPoolDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -ElasticPoolName $poolName

    # Get resource usage metrics for a database in an elastic database for the specified time interval.
    $dbMetrics = @()
    foreach ($db in $dbList)
    {
        $dbMetrics = $dbMetrics + (Get-AzureRmMetric -ResourceId $db.ResourceId -TimeGrain ([TimeSpan]::FromMinutes(60)) -StartTime $startTime -EndTime $endTime)
    }

    #Optionally you can format the metrics and output as .csv file using the following script block.
    function FormatMetrics {
        param($metricList, $outputFile)

        # Format metrics into a table.
        $table = @()
        foreach($metric in $metricList) { 
            foreach($metricValue in $metric.MetricValues) {
                $sx = New-Object PSObject -Property @{
                    Timestamp = $metricValue.Timestamp.ToString()
                    MetricName = $metric.Name; 
                    Average = $metricValue.Average;
                    ResourceID = $metric.ResourceId 
                }
                $table = $table += $sx
            }
        }
        # Output the metrics into a .csv file.
        write-output $table | Export-csv -Path $outputFile -Append -NoTypeInformation
    }

    # Format and output pool metrics
    FormatMetrics -metricList $poolMetrics -outputFile .\poolmetrics.csv

    # Format and output database metrics
    FormatMetrics -metricList $dbMetrics -outputFile .\dbmetrics.csv