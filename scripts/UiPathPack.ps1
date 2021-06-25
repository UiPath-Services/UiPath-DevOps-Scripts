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
    
.EXAMPLE
SYNTAX:
    .\UiPathPack.ps1 <project_path> -destination_folder <destination_folder> [-version <version>] [-autoVersion] [--outputType <Process|Library|Tests|Objects>] [--libraryOrchestratorUrl <orchestrator_url> --libraryOrchestratorTenant <orchestrator_tenant>] [--libraryOrchestratorUsername <orchestrator_user> --libraryOrchestratorPassword <orchestrator_pass>] [--libraryOrchestratorUserKey <UserKey> --libraryOrchestratorAccountName <account_name>] [--libraryOrchestratorFolder <folder>] [-language <language>]

  Examples:
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package"
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -version 1.0.6820.22047
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -autoVersion
    package pack "C:\UiPath\Project" -destination_folder "C:\UiPath\Package"
    package pack "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" --outputType Tests -language en-US
#>
Param (

    #Required
    
	[string] $project_path = "", # Required. Path to a project.json file or a folder containing project.json files.
    [string] $destination_folder = "", #Required. Destination folder.
	[string] $libraryOrchestratorUrl = "", #Required. The URL of the Orchestrator instance.
	[string] $libraryOrchestratorTenant = "", #(Optional, useful only for libraries) The Orchestrator tenant.

    #cloud - Required
    [string] $libraryOrchestratorAccountName = "", #(Optional, useful only for libraries) The Orchestrator URL.
	[string] $libraryOrchestratorUserKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem - Required
    [string] $libraryOrchestratorUsername = "", #Required. The Orchestrator username used for authentication. Must be used together with the password.
	[string] $libraryOrchestratorPassword = "", #Required. The Orchestrator password used for authentication. Must be used together with the username.
	
	[string] $libraryOrchestratorFolder = "", #Optional, useful only for libraries) The Orchestrator folder (organization unit).
	[string] $language = "", #The orchestrator language.  
    [string] $version = "", #Package version.
    [switch] $autoVersion, #Auto-generate package version.
    [string] $outputType = "", #Force the output to a specific type.  
    [string] $disableTelemetry = "" #Disable telemetry data.   

    

)
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
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$debugLog = "$scriptPath\orchestrator-package-pack.log"

#Verifying UiPath CLI folder
$uipathCLI = "$scriptPath\uipathcli\lib\net461\uipcli.exe"
if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
    WriteLog "UiPath CLI does not exist in this folder. Attempting to download it..."
    try {
        New-Item -Path "$scriptPath" -ItemType "directory" -Name "uipathcli";
        Invoke-WebRequest "https://www.myget.org/F/uipath-dev/api/v2/package/UiPath.CLI/1.0.7802.11617" -OutFile "$scriptPath\\uipathcli\\cli.zip";
        Expand-Archive -LiteralPath "$scriptPath\\uipathcli\\cli.zip" -DestinationPath "$scriptPath\\uipathcli";
        WriteLog "UiPath CLI is downloaded and extracted in folder $scriptPath\\uipathcli"
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

$ParamList = New-Object 'Collections.Generic.List[string]'

if($project_path -eq "" -or $destination_folder -eq "")
{
    WriteLog "Fill the required paramters"
    exit 1
}



#Building uipath cli paramters
$ParamList.Add("package")
$ParamList.Add("pack")
$ParamList.Add($project_path)
$ParamList.Add("-o")
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
if($libraryOrchestratorFolder -ne ""){
    $ParamList.Add("--libraryOrchestratorFolder")
    $ParamList.Add($libraryOrchestratorFolder)
}
if($language -ne ""){
    $ParamList.Add("-l")
    $ParamList.Add($language)
}
if($version -ne ""){
    $ParamList.Add("-v")
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
    $ParamList.Add("-y")
    $ParamList.Add($disableTelemetry)
}


#mask sensitive info before logging 
$ParamMask = New-Object 'Collections.Generic.List[string]'
$ParamMask.AddRange($ParamList)
$secretIndex = $ParamMask.IndexOf("--libraryOrchestratorPassword");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = ("*" * ($libraryOrchestratorPassword.Length))
}
$secretIndex = $ParamMask.IndexOf("--libraryOrchestratorAuthToken");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = $userKey.Substring(0, 4) + ("*" * ($userKey.Length - 4))
}

#log cli call with parameters
WriteLog "Executing $uipathCLI $ParamMask"

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
