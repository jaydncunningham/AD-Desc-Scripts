Import-Module ActiveDirectory

$allUsers = Get-AdUser -Filter * -Properties Description

$parsedUsers = @()
 
foreach($user in $allUsers) {
    
    $parsedUser = New-Object -TypeName psobject

    $parsedUser | Add-Member -MemberType NoteProperty -Name DistinguishedName -Value $user.DistinguishedName
    $parsedUser | Add-Member -MemberType NoteProperty -Name Description -Value $user.Description

    Write-Host $parsedUser

    $parsedUsers += $parsedUser
}

$parsedUsers | Export-Csv ad-descs.csv