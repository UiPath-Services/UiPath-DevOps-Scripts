function WriteLog
{
	Param ($message, [switch] $err)
	
	$now = Get-Date -Format "G"
	$line = "$now`t$message"
	$line | Add-Content $debugLog -Encoding UTF8
	if ($err)
	{
		Write-Host $line -ForegroundColor red
	} else {
		Write-Host $line
	}
}

#Running Path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
#log file
$debugLog = "$scriptPath\orchestrator-direct-cli-call.log"
#Verifying UiPath CLI installation
$cliVersion = "1.0.7985.19721"; #CLI Version (Script was tested on this latest version at the time)

$uipathCLI = "$scriptPath\uipathcli\$cliVersion\lib\net461\uipcli.exe"
if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
    WriteLog "UiPath CLI does not exist in this folder. Attempting to download it..."
    try {
        if (-not(Test-Path -Path "$scriptPath\uipathcli\$cliVersion" -PathType Leaf)){
            New-Item -Path "$scriptPath\uipathcli\$cliVersion" -ItemType "directory" -Force | Out-Null
        }
        #Download UiPath CLI
        Invoke-WebRequest "https://www.myget.org/F/uipath-dev/api/v2/package/UiPath.CLI/$cliVersion" -OutFile "$scriptPath\\uipathcli\\$cliVersion\\cli.zip";
        Expand-Archive -LiteralPath "$scriptPath\\uipathcli\\$cliVersion\\cli.zip" -DestinationPath "$scriptPath\\uipathcli\\$cliVersion";
        WriteLog "UiPath CLI is downloaded and extracted in folder $scriptPath\uipathcli\\$cliVersion"
        if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
            WriteLog "Unable to locate uipath cli after it is downloaded."
            exit 1
        }
    }
    catch {
        WriteLog ("Error Occured : " + $_.Exception.Message) -err $_.Exception
        exit 1
    }
    
}
WriteLog "-----------------------------------------------------------------------------"
WriteLog "uipcli location :   $uipathCLI"
#END Verifying UiPath CLI installation

$GenericParamList = New-Object 'Collections.Generic.List[string]'
for ( $i = 0; $i -lt $args.count; $i++ ) {
    write-host "Argument  $i is $($args[$i])"
    if($args[$i].StartsWith("-")){
        $GenericParamList.Add($args[$i])
    }
    else {
        $GenericParamList.Add("`"$($args[$i])`"")
        
    }
    
} 
WriteLog "-----------------------------------------------------------------------------"
#call uipath cli 
& "$uipathCLI" $GenericParamList.ToArray()

if($LASTEXITCODE -eq 0)
{
    WriteLog "Done!"
    Exit 0
}else {
    WriteLog "UiPath CLI returns error. Exit code $LASTEXITCODE"
    Exit 1
}