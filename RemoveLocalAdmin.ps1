
# Change the SearchBase to the DN of your OU.
$searchBase = 'OU=Computers,OU=_SWC,DC=sw-construction,DC=com'
$allComputers = Get-ADComputer -SearchBase $searchBase -SearchScope Subtree -Properties 'OperatingSystem'-Filter *
$credential = Get-Credential


ForEach ($computer in $allComputers) {
    $computerIsEnabled = $computer.Enabled
    $computerIsWindows10Pro = ($computer.OperatingSystem -eq 'Windows 10 Pro')
    if ($computerIsEnabled -and $computerIsWindows10Pro) {
        Enter-PSSession -ComputerName $computer.Name -Credential $credential
        Remove-LocalUser -Name 'admin' 
    }
}