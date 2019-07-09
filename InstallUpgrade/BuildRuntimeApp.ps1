$Date = Get-Date
Write-Host "BuidRuntimeApp.ps1 Started... $Date"   -ForegroundColor Green

. 'C:\Program Files (x86)\Microsoft Dynamics NAV\140\RoleTailored Client\NavModelTools.ps1' -NavIde 'C:\Program Files\Microsoft Dynamics NAV\140\Service\finsql.exe'

$computerName = '192.168.2.20'; #Middle Tier Server to Publish against
$cred = Get-Credential
Write-Host "Creating remote PS session on $computerName" -ForegroundColor Cyan
$Session = New-PSSession -ComputerName $computerName
Enter-PSSession $Session -Credential $cred

$InstanceName = 'CUS_VANDECASTEELE_BC14'
$AppFilePath = Get-Location
$AppName = 'VDC Reports'
$Version = (Get-NAVAppInfo -ServerInstance $InstanceName -Tenant Default -TenantSpecificProperties | ? { $_.Name -eq $AppName }).Version
$Publisher = (Get-NAVAppInfo -ServerInstance $InstanceName -Tenant Default -TenantSpecificProperties | ? { $_.Name -eq $AppName }).Publisher

$AppFileName = $AppFilePath + '\' + $Publisher + '_' + $AppName + '_' + $Version + '_Runtime.app'

Write-Host 'AppName         :' $AppName
Write-Host 'Version         :' $Version 
Write-Host 'Publisher       :' $Publisher
Write-Host 'App File Name   :' $AppFileName

#create runtime app
Get-NAVAppRuntimePackage -ServerInstance $InstanceName -AppName $AppName -Version $Version -ExtensionPath $AppFileName

Exit-PSSession
Write-Host "Removing remote PS session on $computerName"  -ForegroundColor DarkYellow
Remove-PSSession $Session

$Date = Get-Date
Write-Host "BuidRuntimeApp.ps1 Ended... $Date" -ForegroundColor Green