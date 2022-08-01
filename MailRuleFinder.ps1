Import-Module ExchangeOnlineManagement


# Change these varibles for your environment.
$adminUserName = ''
$outputFilePath = "C:\365Reports\365MailRulesReport.csv"

# Connecting to Exchange Online. Need to change this if you're using a different service. (like on prem)
Connect-ExchangeOnline -UserPrincipalName $adminUserName

# Adding role to account so you can run this report.
Add-RoleGroupMember -Identity "Discovery Management" -Member $adminUserName

# Getting all of the mailboxes besides the 'Admin' one.
# Change the alias string to whatever your admin's alias is.
$AdminMailboxAlias = 'Admin'
$allMailboxes = Get-Mailbox -ResultSize unlimited -Filter "Alias -ne '$($AdminMailboxAlias)'"

# Changing permissions and turning on auditing on the mailboxes.
foreach ($mailbox in $allMailboxes) {
    # if the mailbox is a user mailbox (opposed to a shared mailbox), turns on auditing
    if ($mailbox.RecipientTypeDetails -eq 'UserMailbox') {
        Set-Mailbox -Identity $mailbox.DistinguishedName -AuditEnabled $true
    }
    Add-MailboxPermission -Identity $mailbox.DistinguishedName -User $adminUserName -AccessRights FullAccess -InheritanceType all -AutoMapping $False
}

# Gets the mailbox rule and exports to csv.
# Could make this better by adding this bit into the loop above.
Get-Mailbox | ForEach-Object { 
    Get-InboxRule -Mailbox $_.DistinguishedName 
} | Export-Csv $outputFilePath

# Closes out of all the active powershell sessions. Change this if you might have other sessions open simultaneously.
Get-PSSession | Remove-PSSession