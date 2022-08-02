# PowershellOneShots
Random useful scripts I created for a specific one-time tasks. 

ChangeADNumberFormat.ps1
  - This script replaces a character within all phone number fields for every user in Active Directory.

RemoveLocalAdmin.ps1
  - This script connects to each Windows 10 computer in the domain and removes the local admin account named 'admin'.

CheckAccounts.ps1
  - This script takes a list of account names and checks Active Directory to see if they exist and if they are enabled.

MailRuleFinder.ps1
  - This script connects to exchange online, adds a role to the target account, adds permissions to all mailboxes, gets all mail rules on all accounts, and exports the data to a CSV. 
  - The main objective is to scan mail rules for signs of intruders.
  - Not sure if this works, but it should be close. (Made it for someone else and didn't test in my environment.)

ADUserCSVImport.ps1
  - This imports users from a CSV and creates a new account for them in AD with the assigned values.
  - Need to have a semicolon delimited CSV with the following columns: Username, Firstname, Lastname, ou, Password, Description saved at C:\UsersList.csv
  - Default Log file is C:\ADUserCSVImportScriptLog.txt so make sure your account can write to that location or change the path of the log file within the script