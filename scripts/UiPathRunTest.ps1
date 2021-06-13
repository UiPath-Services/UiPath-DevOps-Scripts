<#
.SYNOPSIS 
    Test a given package or run a test set

.DESCRIPTION 
    Test a given package or run a test set in orchestrator

.PARAMETER project_path 
     The path to a test package file.

.PARAMETER testset 
     The name of the test set to execute. The test set should use the latest version of the test cases. If the test set does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestSet

.PARAMETER orchestrator_url 
    Required. The URL of the Orchestrator instance.

.PARAMETER orchestrator_tenant 
    Required. The tenant of the Orchestrator instance.

.PARAMETER result_path 
    Results file path

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

.PARAMETER environment
    The environment to deploy the package to. Must be used together with the project path. Required when not using a modern folder.

.PARAMETER timeout
    The time in seconds for waiting to finish test set executions. (default 7200) 

.PARAMETER out
    Type of result file

.PARAMETER language
    The orchestrator language.

.PARAMETER disableTelemetry
    Disable telemetry data.


.EXAMPLE
.\UiPathRunTest.ps1 <orchestrator_url> <orchestrator_tenant> [-project_path <package>] [-testset <testset>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-environment <environment>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

  Examples:
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -S "MyRobotTests"
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -environment TestingEnv
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder -environment MyEnvironment
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -testset "MyRobotTests"
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -out junit
    .\UiPathRunTest.ps1 "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -result_path "C:\results.json" -out uipath -language en-US
#>
Param (

    #Required
    [string] $orchestrator_url = "", #Required. The URL of the Orchestrator instance.
	[string] $orchestrator_tenant = "", #Required. The tenant of the Orchestrator instance.

	[string] $project_path = "", #The path to a test package file.
	[string] $testset = "", #The name of the test set to execute. The test set should use the latest version of the test cases. If the test set does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestSet

	[string] $result_path = "", #Results file path

    #cloud - Required
    [string] $account_name = "", #Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
	[string] $UserKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem - Required
    [string] $orchestrator_user = "", #Required. The Orchestrator username used for authentication. Must be used together with the password.
	[string] $orchestrator_pass = "", #Required. The Orchestrator password used for authentication. Must be used together with the username
	
	[string] $folder_organization_unit = "", #The Orchestrator folder (organization unit).
	[string] $language = "", #-l, --language                  The orchestrator language.  
    [string] $environment = "", #The environment to deploy the package to. Must be used together with the project path. Required when not using a modern folder.
    [string] $disableTelemetry = "", #-y, --disableTelemetry          Disable telemetry data.   
    [string] $timeout = "", # The time in seconds for waiting to finish test set executions. (default 7200) 
    [string] $out = "" #Type of result file
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
$debugLog = "$scriptPath\orchestrator-test-run.log"

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

if($orchestrator_url -eq "" -or $orchestrator_tenant -eq "") 
{
    WriteLog "Fill the required paramters"
    exit 1
}

#required parameters (Cloud accountName and userkey) or (on-prem username and password) 
if($account_name -eq "" -or $UserKey -eq "")
{
    if($orchestrator_user -eq "" -or $orchestrator_pass -eq "")
    {
        WriteLog "Fill the required paramters"

        exit 1
    }
}

if($project_path -eq "" -and $testset -eq "")
{
    WriteLog "Either TestSet or Project path is required to fill"
    exit 1
}
#Building uipath cli paramters
$ParamList.Add("test")
$ParamList.Add("run")
$ParamList.Add($orchestrator_url)
$ParamList.Add($orchestrator_tenant)

if($project_path -ne ""){
    $ParamList.Add("-P")
    $ParamList.Add($project_path)
}
if($testset -ne ""){
    $ParamList.Add("-s")
    $ParamList.Add($testset)
}
if($result_path -ne ""){
    $ParamList.Add("-r")
    $ParamList.Add($result_path)
}

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
if($environment -ne ""){
    $ParamList.Add("-e")
    $ParamList.Add($environment)
}
if($timeout -ne ""){
    $ParamList.Add("-w")
    $ParamList.Add($timeout)
}
if($out -ne ""){
    $ParamList.Add("--out")
    $ParamList.Add($out)
}
if($language -ne ""){
    $ParamList.Add("-l")
    $ParamList.Add($language)
}

if($disableTelemetry -ne ""){
    $ParamList.Add("-y")
    $ParamList.Add($disableTelemetry)
}


#mask sensitive infos before loging
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
    WriteLog "Unable to run test. Exit code $LASTEXITCODE"
    Exit 1
}
