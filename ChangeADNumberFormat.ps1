# This script replaces a character within all phone number fields for ever user in Active Directory.
# For example, if your company wants to move from storing phone numbers as "123-456-7890" to "123.456.7890", change the $characterToReplace to '-' and the $newCharacter to '.'.

###
# Define the replacement here. ******
###
$characterToReplace = '-'
$newCharacter = '.'

# When the script prompts, enter a username/password with permissions to change AD user attributes values.
$credential = Get-Credential

# These should be all of the AD attributes typically used to store phone numbers.
[string[]]$fieldsToChange = "facsimileTelephoneNumber", "homePhone", "mobile", "pager", "telephoneNumber"

$allUsers = Get-ADUser -Filter * -Properties $fieldsToChange

foreach ($user in $allUsers){

    # Create a hash table, add each field that needs to be updated as a key, add each updated field value as the key's value.
    $updatedValuesHash = New-Object HashTable
    foreach ($field in $fieldsToChange) {
        if ($null -ne $user.$field) {
            $updatedString = $user.$field.replace($characterToReplace, $newCharacter)
            $updatedValuesHash.Add($field, $updatedString)
        }
    }

    # If the hash table isn't empty, apply the hash table values to the user object.
    if ($updatedValuesHash.Count -ne 0){
        Set-ADUser -Identity $user.ObjectGUID -Replace $updatedValuesHash -Credential $credential
    }
}
