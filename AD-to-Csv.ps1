Import-Module ActiveDirectory

if($Args.Count -Ne 1) {
    Write-Host "Usage: .\AD-to-Csv.ps1 <organization name>"
    Exit
}

$allUsers = Get-AdUser -Filter * -Properties Description, DisplayName, ProxyAddresses

$parsedUsers = @()
 
foreach($user in $allUsers) {
    
    $parsedUser = New-Object -TypeName psobject

    $parsedUser | Add-Member -MemberType NoteProperty -Name Title -Value $user.DisplayName
    $parsedUser | Add-Member -MemberType NoteProperty -Name SamAccountName -Value $user.SamAccountName
    $parsedUser | Add-Member -MemberType NoteProperty -Name Description -Value $user.Description

    if($user.proxyaddresses.Value -Eq $null) {
        #continue
    } elseif($user.proxyaddresses.Value.GetType().Name -Eq "String[]") {
        foreach($addr in $user.proxyaddresses.Value) {
            if($addr.StartsWith("SMTP:")) {
                $parsedUser | Add-Member -MemberType NoteProperty -Name ProxyAddrString -Value $addr
            }
        }
    } else { #single string
        $parsedUser | Add-Member -MemberType NoteProperty -Name ProxyAddrString -Value $user.proxyaddresses.Value
    } 
    
    $OUs = @()
    foreach($e in $user.DistinguishedName.Split(",")) {
        $sides = $e.split('=')
        if($sides[0] -Eq 'OU') {
            $OUs += $sides[1]
        }
    }
    [array]::Reverse($OUs)
    $parsedUser | Add-Member -MemberType NoteProperty -Name Group -Value ("Active Directory\$($Args[0])\" + [system.String]::Join("\", $OUs))

    Write-Host $parsedUser

    $parsedUsers += $parsedUser
}

$parsedUsers | Format-Table
$parsedUsers | Export-Csv ad.csv