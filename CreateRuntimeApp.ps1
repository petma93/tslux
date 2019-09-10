#region Variables
$servicetier = "CUS_VANDECASTEELE_BC14"
$remoteNAVAdminToolPath = "C:\Program Files\Microsoft Dynamics 365 Business Central\140 - CU1\Service\NavAdminTool.ps1"
$appJsonFile = "app.json"
$remotePath = "C:\TEMP\APPS\"
$remotePathUNC = "\\TRITON\C$\TEMP\APPS\"
#endregion

#region Execution
$appJsonObject = Get-Content -Raw -Path $appJsonFile | ConvertFrom-Json

Invoke-Command -ComputerName "triton.abecon.nl" -Credential (Get-Credential) -ScriptBlock { Param($appJsonObject,$servicetier,$remotePath,$remoteNAVAdminToolPath)

    Import-Module $($remoteNAVAdminToolPath) –force | Out-Null

    $runtimePath = "$($remotePath)$($appJsonObject.name)_$($appJsonObject.version)_runtime.app"
    
    Get-NAVAppRuntimePackage -ServerInstance $servicetier -AppName $sppJsonObject.name -Version $appJsonObject.version -ExtensionPath $runtimePath
    
} -ArgumentList $appJsonObject,$servicetier,$remotePath,$remoteNAVAdminToolPath


Copy-Item "$($remotePathUNC)$($appJsonObject.name)_$($appJsonObject.version)_runtime.app" -Destination "$($appJsonObject.name)_$($appJsonObject.version)_runtime.app"

Remove-Item "$($remotePathUNC)$($appJsonObject.name)_$($appJsonObject.version)_runtime.app"

#endregion