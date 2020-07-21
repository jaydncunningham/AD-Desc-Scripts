$parsedUsers = Import-Csv "ad-descs-sanitized.csv"

foreach($user in $parsedUsers) {
    echo $user.DistinguishedName
    if([string]::IsNullOrWhiteSpace($user.Description)) {
        $user.Description = $null
    }
    echo $user.Description
    Set-ADUser -Identity $user.DistinguishedName -Description $user.Description
    echo '~~~~'
}