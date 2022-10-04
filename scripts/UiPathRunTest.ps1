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

.PARAMETER accountForApp 
    The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

.PARAMETER applicationId 
    The external application id. Must be used together with account, secret and scope(s) for external application.

.PARAMETER applicationSecret 
    The external application secret. Must be used together with account, id and scope(s) for external application.

.PARAMETER applicationScope 
    The space-separated list of application scopes. Must be used together with account, id and secret for external application.

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
SYNTAX
   .\UiPathRunTest.ps1 <orchestrator_url> <orchestrator_tenant> [-input_path <input_path>] [-project_path <package>] [-testset <testset>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-accountForApp <account_for_app> -applicationId <application_id> -applicationSecret <application_secret> -applicationScope <applicationScope>] [-environment <environment>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

  Examples:
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -orchestrator_user admin -orchestrator_pass 123456 -testset "MyRobotTests"
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -environment TestingEnv
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder -environment MyEnvironment
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -accountForApp myAccountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -testset "MyRobotTests"
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -UserKey a7da29a2c93a717110a82 -account_name myAccount -testset "MyRobotTests"
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv --out junit
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -result_path "C:\results.json" -out uipath -language en-US
    .\UiPathRunTest.ps1 -orchestrator_url "https://uipath-orchestrator.myorg.com" -orchestrator_tenant default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -result_path "C:\results.json" -input_path "C:\UiPath\Project\input-params.json" -out uipath -language en-US
#>
Param (

    #Required
    [string] $orchestrator_url = "", #Required. The URL of the Orchestrator instance.
	[string] $orchestrator_tenant = "", #Required. The tenant of the Orchestrator instance.

	[string] $project_path = "", #The path to a test package file.
    [string] $input_path = "", #The full path to a JSON input file. Only required if the entry-point workflow has input parameters and you want to pass them from command line.
	[string] $testset = "", #The name of the test set to execute. The test set should use the latest version of the test cases. If the test set does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestSet

	[string] $result_path = "", #Results file path

    #External Apps (Option 1)
    [string] $accountForApp = "", #The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.
    [string] $applicationId = "", #Required. The external application id. Must be used together with account, secret and scope(s) for external application.
    [string] $applicationSecret = "", #Required. The external application secret. Must be used together with account, id and scope(s) for external application.
    [string] $applicationScope = "", #Required. The space-separated list of application scopes. Must be used together with account, id and secret for external application.

    #API Access - (Option 2)
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
    [string] $out = "", #Type of result file
    [string] $traceLevel = "" 
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
#Running Path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
#log file
$debugLog = "$scriptPath\orchestrator-test-run.log"

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


$ParamList = New-Object 'Collections.Generic.List[string]'

if($orchestrator_url -eq "" -or $orchestrator_tenant -eq "") 
{
    WriteLog "Fill the required paramters (orchestrator_url, orchestrator_tenant)"
    exit 1
}

#required parameters (Authintication)
if($accountForApp -eq "" -or $applicationId -eq "" -or $applicationSecret -eq "" -or $applicationScope -eq "")
{
    if($account_name -eq "" -or $userKey -eq "")
    {
        if($orchestrator_user -eq "" -or $orchestrator_pass -eq "")
        {
            WriteLog "Fill the required paramters (External App OAuth, API Access, or Username & Password)"
            exit 1
        }
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
    $ParamList.Add("--project-path")
    $ParamList.Add($project_path)
}
if($input_path -ne ""){
    $ParamList.Add("--input_path")
    $ParamList.Add($input_path)
}
if($testset -ne ""){
    $ParamList.Add("--testset")
    $ParamList.Add($testset)
}
if($result_path -ne ""){
    $ParamList.Add("--result_path")
    $ParamList.Add($result_path)
}
if($accountForApp -ne ""){
    $ParamList.Add("--accountForApp")
    $ParamList.Add($accountForApp)
}
if($applicationId -ne ""){
    $ParamList.Add("--applicationId")
    $ParamList.Add($applicationId)
}
if($applicationSecret -ne ""){
    $ParamList.Add("--applicationSecret")
    $ParamList.Add($applicationSecret)
}
if($applicationScope -ne ""){
    $ParamList.Add("--applicationScope")
    $ParamList.Add("`"$applicationScope`"")
}
if($account_name -ne ""){
    $ParamList.Add("--accountName")
    $ParamList.Add($account_name)
}
if($UserKey -ne ""){
    $ParamList.Add("--token")
    $ParamList.Add($UserKey)
}
if($orchestrator_user -ne ""){
    $ParamList.Add("--username")
    $ParamList.Add($orchestrator_user)
}
if($orchestrator_pass -ne ""){
    $ParamList.Add("--password")
    $ParamList.Add($orchestrator_pass)
}
if($folder_organization_unit -ne ""){
    $ParamList.Add("--organizationUnit")
    $ParamList.Add($folder_organization_unit)
}
if($environment -ne ""){
    $ParamList.Add("--environment")
    $ParamList.Add($environment)
}
if($timeout -ne ""){
    $ParamList.Add("--timeout")
    $ParamList.Add($timeout)
}
if($out -ne ""){
    $ParamList.Add("--out")
    $ParamList.Add($out)
}
if($language -ne ""){
    $ParamList.Add("-language")
    $ParamList.Add($language)
}
if($traceLevel -ne ""){
    $ParamList.Add("--traceLevel")
    $ParamList.Add($traceLevel)
}
if($disableTelemetry -ne ""){
    $ParamList.Add("--disableTelemetry")
    $ParamList.Add($disableTelemetry)
}


#mask sensitive infos before loging
$ParamMask = New-Object 'Collections.Generic.List[string]'
$ParamMask.AddRange($ParamList)

$secretIndex = $ParamMask.IndexOf("--password");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = ("*" * 15)
}
$secretIndex = $ParamMask.IndexOf("--token");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = $userKey.Substring(0, [Math]::Min($userKey.Length, 4)) + ("*" * 15)
}
$secretIndex = $ParamMask.IndexOf("--applicationId");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = $applicationId.Substring(0, [Math]::Min($applicationId.Length, 4)) + ("*" * 15)
}
$secretIndex = $ParamMask.IndexOf("--applicationSecret");
if($secretIndex -ge 0){
    $ParamMask[$secretIndex + 1] = ("*" * 15)
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
