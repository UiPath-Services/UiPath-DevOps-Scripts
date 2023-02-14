<#
.SYNOPSIS 
    Pack project into a NuGet package

.DESCRIPTION 
    This script is to pack a project into a NuGet package files (*.nupkg).

.PARAMETER project_path 
     Required. Path to a project.json file or a folder containing project.json files.

.PARAMETER destination_folder 
     Required. Destination folder.

.PARAMETER libraryOrchestratorUrl 
    (Optional, useful only for libraries) The Orchestrator URL.

.PARAMETER libraryOrchestratorTenant 
    (Optional, useful only for libraries) The Orchestrator tenant.

.PARAMETER libraryOrchestratorAccountForApp 
    (Optional, useful only for libraries) The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

.PARAMETER libraryOrchestratorApplicationId 
    (Optional, useful only for libraries) The external application id. Must be used together with account, secret and scope(s) for external application.

.PARAMETER libraryOrchestratorApplicationSecret 
    (Optional, useful only for libraries) The external application secret. Must be used together with account, id and scope(s) for external application.

.PARAMETER libraryOrchestratorApplicationScope 
    (Optional, useful only for libraries) The space-separated list of application scopes. Must be used together with account, id and secret for external application.

.PARAMETER libraryOrchestratorUsername
    (Optional, useful only for libraries) The Orchestrator password used for authentication. Must be used together with the username.

.PARAMETER libraryOrchestratorPassword
    (Optional, useful only for libraries) The Orchestrator username used for authentication. Must be used together with the password.

.PARAMETER libraryOrchestratorUserKey
    (Optional, useful only for libraries) The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

.PARAMETER libraryOrchestratorAccountName
    (Optional, useful only for libraries) The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

.PARAMETER libraryOrchestratorFolder
    (Optional, useful only for libraries) The Orchestrator folder (organization unit).

.PARAMETER version
    Package version.

.PARAMETER autoVersion
    Auto-generate package version.

.PARAMETER outputType
    Force the output to a specific type. <Process|Library|Tests|Objects>

.PARAMETER language
    The orchestrator language.

.PARAMETER disableTelemetry
    Disable telemetry data.
    
.PARAMETER uipathCliFilePath
    if not provided, the script will auto download the cli from uipath public feed. the script was testing on version 22.10.8432.18709. if provided, it is recommended to have cli version 22.10.8432.18709 

.EXAMPLE
SYNTAX:
    .\UiPathPack.ps1 <project_path> -destination_folder <destination_folder> [-version <version>] [-autoVersion] [--outputType <Process|Library|Tests|Objects>] [--libraryOrchestratorUrl <orchestrator_url> --libraryOrchestratorTenant <orchestrator_tenant>] [--libraryOrchestratorUsername <orchestrator_user> --libraryOrchestratorPassword <orchestrator_pass>] [--libraryOrchestratorUserKey <UserKey> --libraryOrchestratorAccountName <account_name>] [--libraryOrchestratorFolder <folder>] [-language <language>]

  Examples:
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package"
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -version 1.0.6820.22047
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -autoVersion
    package pack "C:\UiPath\Project" -destination_folder "C:\UiPath\Package"
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" --outputType Tests -language en-US

    .\UiPathPack.ps1 <project_path> -o <destination_folder> [-version <version>] [-autoVersion] [-outputType <Process|Library|Tests|Objects>] [-libraryOrchestratorUrl <orchestrator_url> -libraryOrchestratorTenant <orchestrator_tenant>] [-libraryOrchestratorUsername <orchestrator_user> -libraryOrchestratorPassword <orchestrator_pass>] [-libraryOrchestratorUserKey <auth_token> -libraryOrchestratorAccountName <account_name>] [-libraryOrchestratorAccountForApp <ExternaAppAccount> -libraryOrchestratorApplicationId <AppID> -libraryOrchestratorApplicationSecret <AppSecret> -libraryOrchestratorApplicationScope <AppScope>] 
    [-libraryOrchestratorFolder <folder>] [-language <language>]

  Examples:
    .\UiPathPack.ps1 "C:\UiPath\Project\project.json" --destination_folder "C:\UiPath\Package"
    .\UiPathPack.ps1 "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -version 1.0.6820.22047
    .\UiPathPack.ps1 "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -autoVersion
    .\UiPathPack.ps1 "C:\UiPath\Project" -destination_folder "C:\UiPath\Package"
    .\UiPathPack.ps1 "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -outputType Tests -language en-US
#>
Param (

    #Required
    
	[string] $project_path = "", # Required. Path to a project.json file or a folder containing project.json files.
    [string] $destination_folder = "", #Required. Destination folder.
	[string] $libraryOrchestratorUrl = "", #Required. The URL of the Orchestrator instance.
	[string] $libraryOrchestratorTenant = "", #(Optional, useful only for libraries) The Orchestrator tenant.

    #Extranal Apps (OAuth) (Cloud/OnPrem)
    [string] $libraryOrchestratorAccountForApp = "", #(Optional, useful only for libraries) The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.
    [string] $libraryOrchestratorApplicationId = "", #(Optional, useful only for libraries) The external application id. Must be used together with account, secret and scope(s) for external application.
    [string] $libraryOrchestratorApplicationSecret = "", #(Optional, useful only for libraries) The external application secret. Must be used together with account, id and scope(s) for external application.
    [string] $libraryOrchestratorApplicationScope = "", #(Optional, useful only for libraries) The space-separated list of application scopes. Must be used together with account, id and secret for external application.
    
    #cloud API Access - Required
    [string] $libraryOrchestratorAccountName = "", #(Optional, useful only for libraries) The Orchestrator URL.
	[string] $libraryOrchestratorUserKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem - Required
    [string] $libraryOrchestratorUsername = "", #Required. The Orchestrator username used for authentication. Must be used together with the libraryOrchestratorPassword.
	[string] $libraryOrchestratorPassword = "", #Required. The Orchestrator password used for authentication. Must be used together with the libraryOrchestratorUsername.
	
	[string] $libraryOrchestratorFolder = "", #Optional, useful only for libraries) The Orchestrator folder (organization unit).
	[string] $language = "", #The orchestrator language.  
    [string] $version = "", #Package version.
    [switch] $autoVersion, #Auto-generate package version.
    [string] $outputType = "", #Force the output to a specific type.  
    [string] $disableTelemetry = "", #Disable telemetry data.
    [string] $uipathCliFilePath = "" #if not provided, the script will auto download the cli from uipath public feed. the script was testing on version 22.10.8438.32859.

    

)
#Log function
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
$debugLog = "$scriptPath\orchestrator-package-pack.log"

#Validate provided cli folder (if any)
if($uipathCliFilePath -ne ""){
    $uipathCLI = "$uipathCliFilePath"
    if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
        WriteLog "UiPath cli file path provided does not exist in the provided path $uipathCliFilePath.`r`nDo not provide uipathCliFilePath paramter if you want the script to auto download the cli from UiPath Public feed"
        exit 1
    }
}else{
    #Verifying UiPath CLI installation
    $cliVersion = "22.10.8438.32859"; #CLI Version (Script was tested on this latest version at the time)

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


#Building uipath cli paramters
$ParamList = New-Object 'Collections.Generic.List[string]'

if($project_path -eq "" -or $destination_folder -eq "")
{
    WriteLog "Fill the required paramters (project_path, destination_folder)"
    exit 1
}
$ParamList.Add("package")
$ParamList.Add("pack")
$ParamList.Add($project_path)
$ParamList.Add("--output")
$ParamList.Add($destination_folder)

if($libraryOrchestratorUrl -ne ""){
    $ParamList.Add("--libraryOrchestratorUrl")
    $ParamList.Add($libraryOrchestratorUrl)
}
if($libraryOrchestratorTenant -ne ""){
    $ParamList.Add("--libraryOrchestratorTenant")
    $ParamList.Add($libraryOrchestratorTenant)
}
if($libraryOrchestratorAccountName -ne ""){
    $ParamList.Add("--libraryOrchestratorAccountName")
    $ParamList.Add($libraryOrchestratorAccountName)
}
if($libraryOrchestratorUserKey -ne ""){
    $ParamList.Add("--libraryOrchestratorAuthToken")
    $ParamList.Add($libraryOrchestratorUserKey)
}
if($libraryOrchestratorUsername -ne ""){
    $ParamList.Add("--libraryOrchestratorUsername")
    $ParamList.Add($libraryOrchestratorUsername)
}
if($libraryOrchestratorPassword -ne ""){
    $ParamList.Add("--libraryOrchestratorPassword")
    $ParamList.Add($libraryOrchestratorPassword)
}
if($libraryOrchestratorAccountForApp -ne ""){
    $ParamList.Add("--libraryOrchestratorAccountForApp")
    $ParamList.Add($libraryOrchestratorAccountForApp)
}
if($libraryOrchestratorApplicationId -ne ""){
    $ParamList.Add("--libraryOrchestratorApplicationId")
    $ParamList.Add($libraryOrchestratorApplicationId)
}
if($libraryOrchestratorApplicationSecret -ne ""){
    $ParamList.Add("--libraryOrchestratorApplicationSecret")
    $ParamList.Add($libraryOrchestratorApplicationSecret)
}
if($libraryOrchestratorApplicationScope -ne ""){
    $ParamList.Add("--libraryOrchestratorApplicationScope")
    $ParamList.Add($libraryOrchestratorApplicationScope)
}
if($libraryOrchestratorFolder -ne ""){
    $ParamList.Add("--libraryOrchestratorFolder")
    $ParamList.Add($libraryOrchestratorFolder)
}
if($language -ne ""){
    $ParamList.Add("--language")
    $ParamList.Add($language)
}
if($version -ne ""){
    $ParamList.Add("--version")
    $ParamList.Add($version)
}
if($PSBoundParameters.ContainsKey('autoVersion')) {
    $ParamList.Add("--autoVersion")
}
if($outputType -ne ""){
    $ParamList.Add("--outputType")
    $ParamList.Add($outputType)
}

if($disableTelemetry -ne ""){
    $ParamList.Add("--disableTelemetry")
    $ParamList.Add($disableTelemetry)
}


#region Mask sensitive info before logging 
$ParamMask = New-Object 'Collections.Generic.List[string]'
$ParamMask.AddRange($ParamList)
$secretIndex = $ParamMask.IndexOf("--libraryOrchestratorPassword");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = ("*" * 15)
}
$secretIndex = $ParamMask.IndexOf("--libraryOrchestratorAuthToken");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = $libraryOrchestratorUserKey.Substring(0, [Math]::Min(4, $libraryOrchestratorUserKey.Length)) + ("*" * 15)
}
$secretIndex = $ParamMask.IndexOf("--libraryOrchestratorApplicationId");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = $libraryOrchestratorApplicationId.Substring(0, [Math]::Min($libraryOrchestratorApplicationId.Length, 4)) + ("*" * 15)
}
$secretIndex = $ParamMask.IndexOf("--libraryOrchestratorApplicationSecret");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = ("*" * 15)
}
#endregion  Mask sensitive info before logging 

#log cli call with parameters
WriteLog "Executing $uipathCLI $ParamMask"
WriteLog "-----------------------------------------------------------------------------"
#call uipath cli 
& "$uipathCLI" $ParamList.ToArray()

if($LASTEXITCODE -eq 0)
{
    WriteLog "Done! Package(s) destination folder is : $destination_folder"
    Exit 0
}else {
    WriteLog "Unable to Pack project. Exit code $LASTEXITCODE"
    Exit 1
}
