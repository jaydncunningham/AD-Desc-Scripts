# Description cleaning
Set of scripts to assist with cleaning sensitive information from Active Directory descriptions
A lot of people will stick credentials in the description field in AD not realising that any domain user can run an LDAP query and clean house
A less harmful alternative, if you need to store credentials for service accounts etc. is to put them in a password manager

## .\AD-to-csv.ps1
Exports display name, username, password, and OU heirarchy for import into a password manager

## .\AD-Desc-To-Csv.ps1
Exports distinguished name and description into a csv for manual editing to be imported back

## .\AD-Csv-To-Desc.ps1
Imports edited csv from AD-Desc-To-Csv.ps1 back in to active directory