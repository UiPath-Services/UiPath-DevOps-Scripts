<#
.SYNOPSIS 
    call uipcli.exe with cli paramters

.DESCRIPTION 
    call uipcli.exe with cli paramters
    
# .PARAMETER uipathCliFilePath
#     if not provided, the script will auto download the cli from uipath public feed.
#>
# Param (
#     [string] $uipathCliFilePath = "" #if not provided, the script will auto download the cli from uipath public feed.
# )
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

$uipathCliFilePath = "" #provide uipcli.exe if running on self-hosted agent and uipath cli is available on the machine 
#Validate provided cli folder (if any)
if($uipathCliFilePath -ne ""){
    $uipathCLI = "$uipathCliFilePath"
    if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
        WriteLog "UiPath cli file path provided does not exist in the provided path $uipathCliFilePath.`r`nDo not provide uipathCliFilePath paramter if you want the script to auto download the cli from UiPath Public feed"
        exit 1
    }
}else{
    #Verifying UiPath CLI installation
    $cliVersion = "23.10.8753.32995"; #CLI Version (Script was tested on this latest version at the time)

    $uipathCLI = "$scriptPath\uipathcli\$cliVersion\tools\uipcli.exe"
    if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
        WriteLog "UiPath CLI does not exist in this folder. Attempting to download it..."
        try {
            if (-not(Test-Path -Path "$scriptPath\uipathcli\$cliVersion" -PathType Leaf)){
                New-Item -Path "$scriptPath\uipathcli\$cliVersion" -ItemType "directory" -Force | Out-Null
            }
            #Download UiPath CLI
            #Invoke-WebRequest "https://www.myget.org/F/uipath-dev/api/v2/package/UiPath.CLI/$cliVersion" -OutFile "$scriptPath\\uipathcli\\$cliVersion\\cli.zip";
            Invoke-WebRequest "https://uipath.pkgs.visualstudio.com/Public.Feeds/_apis/packaging/feeds/1c781268-d43d-45ab-9dfc-0151a1c740b7/nuget/packages/UiPath.CLI.Windows/versions/$cliVersion/content" -OutFile "$scriptPath\\uipathcli\\$cliVersion\\cli.zip";
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
}
WriteLog "-----------------------------------------------------------------------------"
WriteLog "uipcli location :   $uipathCLI"
#END Verifying UiPath CLI installation

$GenericParamList = New-Object 'Collections.Generic.List[string]'
for ( $i = 0; $i -lt $args.count; $i++ ) {
    #write-host "Argument  $i is $($args[$i])"
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