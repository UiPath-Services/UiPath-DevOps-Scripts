<#
.SYNOPSIS 
    Deploy NuGet package files to orchestrator

.DESCRIPTION 
    This script is to deploy NuGet package files (*.nupkg) to Cloud or On-Prem orchestrator.

.PARAMETER packages_path 
     Required. The path to a folder containing packages, or to a package file.

.PARAMETER orchestrator_url 
    Required. The URL of the Orchestrator instance.

.PARAMETER orchestrator_tenant 
    Required. The tenant of the Orchestrator instance.

.PARAMETER orchestrator_user
    Required. The Orchestrator username used for authentication. Must be used together with the password.

.PARAMETER orchestrator_pass
    Required. The Orchestrator password used for authentication. Must be used together with the username

.PARAMETER UserKey
    Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

.PARAMETER account_name
    Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

.PARAMETER folder_organization_unit
    The Orchestrator folder (organization unit).

.PARAMETER environment_list
    The comma-separated list of environments to deploy the package to. If the environment does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestEnvironment

.PARAMETER language
    The orchestrator language.

.PARAMETER disableTelemetry
    Disable telemetry data.

.EXAMPLE
SYNTAX
    . '\UiPathDeploy.ps1' <packages_path> <orchestrator_url> <orchestrator_tenant> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <UserKey> -account_name <account_name>] [-folder_organization_unit <folder_organization_unit>] [-environment_list <environment_list>] [-language <language>]
Examples:
    . '\UiPathDeploy.ps1' "C:\UiPath\Project 1" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456
    . '\UiPathDeploy.ps1' "C:\UiPath\Project\Package.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . '\UiPathDeploy.ps1' "C:\UiPath\Project\Package.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount
    . '\UiPathDeploy.ps1' "C:\UiPath\Project\TestsPackage.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -environment_list SAPEnvironment,ExcelAutomationEnvironment -language en-US
#>
Param (

    #Required
	[string] $packages_path = "", # Required. The path to a folder containing packages, or to a package file.
	[string] $orchestrator_url = "", #Required. The URL of the Orchestrator instance.
	[string] $orchestrator_tenant = "", #Required. The tenant of the Orchestrator instance.

    #cloud - Required
    [string] $account_name = "", #Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
	[string] $UserKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem - Required
    [string] $orchestrator_user = "", #Required. The Orchestrator username used for authentication. Must be used together with the password.
	[string] $orchestrator_pass = "", #Required. The Orchestrator password used for authentication. Must be used together with the username
	
	[string] $folder_organization_unit = "", #The Orchestrator folder (organization unit).
	[string] $language = "", #The orchestrator language.  
    [string] $environment_list = "", #The comma-separated list of environments to deploy the package to. If the environment does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestEnvironment
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
$debugLog = "$scriptPath\orchestrator-package-deploy.log"

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

if($packages_path -eq "" -or $orchestrator_url -eq "" -or $orchestrator_tenant -eq "") 
{
    WriteLog "Fill the required paramters"
    exit 1
}

if($account_name -eq "" -or $UserKey -eq "")
{
    if($orchestrator_user -eq "" -or $orchestrator_pass -eq "")
    {
        WriteLog "Fill the required paramters"

        exit 1
    }
}

#Building uipath cli paramters
$ParamList.Add("package")
$ParamList.Add("deploy")
$ParamList.Add($packages_path)
$ParamList.Add($orchestrator_url)
$ParamList.Add($orchestrator_tenant)

if($account_name -ne ""){
    $ParamList.Add("-a")
    $ParamList.Add($account_name)
}
if($UserKey -ne ""){
    $ParamList.Add("-t")
    $ParamList.Add($UserKey)

}
if($orchestrator_user -ne ""){
    $ParamList.Add("-u")
    $ParamList.Add($orchestrator_user)
}
if($orchestrator_pass -ne ""){
    $ParamList.Add("-p")
    $ParamList.Add($orchestrator_pass)
}
if($folder_organization_unit -ne ""){
    $ParamList.Add("-o")
    $ParamList.Add($folder_organization_unit)
}
if($environment_list -ne ""){
    $ParamList.Add("-e")
    $ParamList.Add($environment_list)
}

if($language -ne ""){
    $ParamList.Add("-l")
    $ParamList.Add($language)
}

if($disableTelemetry -ne ""){
    $ParamList.Add("-y")
    $ParamList.Add($disableTelemetry)
}

#mask sensitive info before logging 
$ParamMask = New-Object 'Collections.Generic.List[string]'
$ParamMask.AddRange($ParamList)
$secretIndex = $ParamMask.IndexOf("-p");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = ("*" * ($orchestrator_pass.Length))
}
$secretIndex = $ParamMask.IndexOf("-t");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = $userKey.Substring(0, 4) + ("*" * ($userKey.Length - 4))
}

#log cli call with parameters
WriteLog "Executing $uipathCLI $ParamMask"

#call uipath cli 
& "$uipathCLI" $ParamList.ToArray()

if($LASTEXITCODE -eq 0)
{
    WriteLog "Done!"
    Exit 0
}else {
    WriteLog "Unable to deploy project. Exit code $LASTEXITCODE"
    Exit 1
}
