Import-Module ActiveDirectory

function StringIsNullOrWhitespace([string] $string)
{
    if ($string -ne $null) { $string = $string.Trim() }
    return [string]::IsNullOrEmpty($string)
}

$parsedUsers = Import-Csv "ad-descs-sanitized.csv"

foreach($user in $parsedUsers) {
    echo $user.DistinguishedName
    if(StringIsNullOrWhitespace($user.Description)) {
        $user.Description = $null
    }
    echo $user.Description
    Set-ADUser -Identity $user.DistinguishedName -Description $user.Description
    echo '~~~~'
}