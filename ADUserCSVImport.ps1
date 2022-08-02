
function Test-ADUser {
    <#
        .SYNOPSIS
        Returns a boolean value if an account can be found with the given SAMAccountName.
        .DESCRIPTION
        Returns a boolean value if an account can be found with the given SAMAccountName.
        .PARAMETER Identity
        Mandatory. 
        .INPUTS
        Identity parameter accepts input from pipeline.
        .OUTPUTS
        Returns a boolean value.
        .EXAMPLE
        Test-ADUser -Identity smelton
        .LINK
        Github source: https://github.com/SnoozingPinata/SamsADToolkit
        .LINK
        Author's website: www.samuelmelton.com
    #>
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0)]
        $Identity
    )

    Process {
        $query = (Get-ADUser -Filter "SAMAccountName -eq '$($Identity)'")

        if ($null -eq $query) {
            return $False
        } elseif ($query) {
            return $True
        } else {
            throw "An Unknown Error Occurred."
        }
    }
}

Function Write-Log {
    Param(
        [Parameter(
            Position=0
        )]
        [string] $LogString,

        [Parameter(
            Position=1
        )]
        $LogFilePath
    )
    if (-not (Test-Path $logFilePath -ErrorAction SilentlyContinue)) {
        New-Item $LogFilePath -ItemType File -Force -ErrorAction Stop
    }

    $timeStamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $logMessage = "$timeStamp - $LogString`n"
    Add-Content -Path $LogFilePath -Value $logMessage -ErrorAction Stop
}

$logFilePath = 'C:\logs\ADUserCSVImportScriptLog.txt'
Write-Log -LogString "ADUserCSVImport Script Started" -LogFilePath $logFilePath

$importedUsers = Import-Csv -Path 'C:\ITFiles\UsersList.csv' -Delimiter ","

foreach ($User in $importedUsers) {
    Write-Log -LogString "Processing User $($User.Username)" -LogFilePath $logFilePath

    $UserProperties = @{
        SamAccountName = $User.Username
        UserPrincipalName = $User.Username
        Name = "$($User.Firstname) $($User.Lastname)"
        GivenName = $User.Firstname
        SurName = $User.Lastname
        Enabled = $True
        ChangePasswordAtLogon = $True
        Path = $User.ou
        AccountPassword = (ConvertTo-SecureString -String $User.Password -AsPlainText -Force)
        Description = $User.Description
    }

    if (Test-ADUser -Identity $User.Username) {
        Write-Warning "$($User.Username) already exists"
        Write-Log -LogString "User $($User.Username) already exists." -LogFilePath $logFilePath
    } else {
        New-ADUser @UserProperties
        Write-Log -LogString "Adding AD Account for user $($User.Username)" -LogFilePath $logFilePath
    }
}