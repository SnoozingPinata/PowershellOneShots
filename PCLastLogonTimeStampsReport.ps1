
# Enter the distinguished Name for the OU that your domain controllers are in in the variable below
$domainControllerOU = ""
$domainControllers = Get-ADComputer -Filter {OperatingSystem -like '*server*'} -SearchBase $domainControllerOU -SearchScope Subtree

$computerTimeStampHashTable = @{}

foreach ($dc in $domainControllers) {

    $allWorkstations = Get-ADComputer -Filter {OperatingSystem -NotLike '*server*'} -Properties LastLogonTimeStamp -Server $dc.Name

    foreach ($workstation in $allWorkstations) {
        $pcName = $workstation.Name
        $pcTimeStamp = $workstation.LastLogonTimeStamp
        $pcNotInHashTable = ($null -eq $computerTimeStampHashTable[$pcName])
        $NewTimeStampIsGreaterThanOldtimeStamp = ($computerTimeStampHashTable[$pcName] -lt $pcTimeStamp)

        if ($pcNotInHashTable) {
            $computerTimeStampHashTable.Add($workstation.Name, $workstation.LastLogonTimeStamp)
        } elseif ($NewTimeStampIsGreaterThanOldtimeStamp) {
            $computerTimeStampHashTable[$pcName] = $pcTimeStamp
        }
    }
}

$computerTimeStampHashTable.GetEnumerator() | Select-Object -Property Key, Value | Export-csv -LiteralPath "c:\logs\ComputerLastLogonTimeStamps.csv" -NoTypeInformation