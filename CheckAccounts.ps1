
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

# put the accounts you wan to check in this list.
$accounts = 'account1', 'account2'

foreach ($account in $accounts) {
    if (Test-ADUser $account) {
        if ((Get-ADUser $account).Enabled) {
            Write-Output "SUCCESS - $account - exists and is enabled"
        } else {
            Write-Output "FAILURE - $account - Account exists but is inactive."
        }
    } else {
        Write-Output "FAILURE - $account - Account does not exist."
    }
}