<#
.SYNOPSIS 
    Run UiPath Orchestrator Job.

.DESCRIPTION 
    This script is to run orchestrator job.

.PARAMETER processName 
    orchestrator process name to run.

.PARAMETER uriOrch 
    The URL of Orchestrator.

.PARAMETER tenantlName 
    The tenant name

.PARAMETER accountForApp 
    The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

.PARAMETER applicationId 
    The external application id. Must be used together with account, secret and scope(s) for external application.

.PARAMETER applicationSecret 
    The external application secret. Must be used together with account, id and scope(s) for external application.

.PARAMETER applicationScope 
    The space-separated list of application scopes. Must be used together with account, id and secret for external application.

.PARAMETER orchestrator_user
    On-premises Orchestrator admin user name who has a Role of Create Package.

.PARAMETER orchestrator_pass
    The password of the on-premises Orchestrator admin user.

.PARAMETER userKey
    User key for Cloud Platform Orchestrator

.PARAMETER accountName
    Account logical name for Cloud Platform Orchestrator

.PARAMETER input_path
    The full path to a JSON input file. Only required if the entry-point workflow has input parameters.

.PARAMETER jobscount
    The number of job runs. (default 1)

.PARAMETER result_path
    The full path to a JSON file or a folder where the result json file will be created.

.PARAMETER priority
    The priority of job runs. One of the following values: Low, Normal, High. (default Normal)

.PARAMETER robots
    The comma-separated list of specific robot names.

.PARAMETER folder_organization_unit
    The Orchestrator folder (organization unit).

.PARAMETER user
    The name of the user. This should be a machine user, not an orchestrator user. For local users, the format should be MachineName\UserName

.PARAMETER language
    The orchestrator language.

.PARAMETER machine
    The name of the machine.

.PARAMETER timeout
    The timeout for job executions in seconds. (default 1800)

.PARAMETER fail_when_job_fails
    The command fails when at least one job fails. (default true)

.PARAMETER wait
    The command waits for job runs completion. (default true)

.PARAMETER job_type
    The type of the job that will run. Values supported for this command: Unattended, NonProduction. For classic folders do not specify this argument

.PARAMETER disableTelemetry
    Disable telemetry data.

.EXAMPLE
SYNTAX:
    .\UiPathJobRun.ps1 <process_name> <orchestrator_url> <orchestrator_tenant> [-input_path <input_path>] [-jobscount <jobscount>] [-result_path <result_path>] [-priority <priority>] [-robots <robots>] 
    [-fail_when_job_fails <do_not_fail_when_job_fails>] [-timeout <timeout>] [-wait <do_not_wait>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-userKey <auth_token> -accountName <account_name>] 
    [-accountForApp <account_for_app> -applicationId <application_id> -applicationSecret <application_secret> -applicationScope <applicationScope>] [-folder_organization_unit <folder_organization_unit>] [-language <language>] [-user <robotUser>]
    [-machine <robotMachine>] [-job_type <Unattended, NonProduction>]

  Examples:
    
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -orchestrator_pass -priority Low
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -orchestrator_pass -priority Normal -folder_organization_unit MyFolder
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -orchestrator_pass -priority High -folder_organization_unit MyFolder
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -userKey a7da29a2c93a717110a82 -accountName myAccount -fail_when_job_fails false -timeout 0
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -userKey a7da29a2c93a717110a82 -accountName myAccount -orchestrator_pass -priority High -jobscount 3 -wait false -machine ROBOTMACHINE
    .\UiPathJobRun.ps1 "ProcessName" "https://cloud.uipath.com/" default -userKey a7da29a2c93a717110a82 -accountName myAccount -orchestrator_pass -priority Low -robots robotName -result_path C:\Temp
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -userKey a7da29a2c93a717110a82 -accountName myAccount -robots robotName -result_path C:\Temp\status.json
    .\UiPathJobRun.ps1 "ProcessName" "https://uipath-orchestrator.myorg.com" default -accountForApp accountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -robots robotName -result_path C:\Temp\status.json
 
#>
Param (

    #Required
    
    [string] $processName = "", #Process Name (pos. 0)           Required.
    [string] $uriOrch = "", #Orchestrator URL (pos. 1)       Required. The URL of the Orchestrator instance.
    [string] $tenantlName = "", #Orchestrator Tenant (pos. 2)    Required. The tenant of the Orchestrator instance.

    #External Apps (Option 1)
    [string] $accountForApp = "", #The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.
    [string] $applicationId = "", #Required. The external application id. Must be used together with account, secret and scope(s) for external application.
    [string] $applicationSecret = "", #Required. The external application secret. Must be used together with account, id and scope(s) for external application.
    [string] $applicationScope = "", #Required. The space-separated list of application scopes. Must be used together with account, id and secret for external application.

    #API Access - (Option 2)
    [string] $accountName = "", #Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
    [string] $userKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem UserName & Password - (Option 3) 
    [string] $orchestrator_user = "", #Required. The Orchestrator username used for authentication. Must be used together with the password.
    [string] $orchestrator_pass = "", #Required. The Orchestrator password used for authentication. Must be used together with the username.
	
    [string] $input_path = "", #The full path to a JSON input file. Only required if the entry-point workflow has input parameters.
    [string] $jobscount = "", #The number of job runs. (default 1)
    [string] $result_path = "", #The full path to a JSON file or a folder where the result json file will be created.
    [string] $priority = "", #The priority of job runs. One of the following values: Low, Normal, High. (default Normal)
    [string] $robots = "", #The comma-separated list of specific robot names.
    [string] $folder_organization_unit = "", #The Orchestrator folder (organization unit).
    [string] $language = "", #The orchestrator language.  
    [string] $user = "", #The name of the user. This should be a machine user, not an orchestrator user. For local users, the format should be MachineName\UserName
    [string] $machine = "", #The name of the machine.
    [string] $timeout = "", #The timeout for job executions in seconds. (default 1800)
    [string] $fail_when_job_fails = "", #The command fails when at least one job fails. (default true)
    [string] $wait = "", #The command waits for job runs completion. (default true)
    [string] $job_type = "", #The type of the job that will run. Values supported for this command: Unattended, NonProduction. For classic folders do not specify this argument
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
#Running Path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
#log file
$debugLog = "$scriptPath\orchestrator-job-run.log"

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

if($processName -eq "" -or $uriOrch -eq "" -or $tenantlName -eq "")
{
    WriteLog "Fill the required paramters (processName, uriOrch, tenantlName)"
    exit 1
}

if($accountForApp -eq "" -or $applicationId -eq "" -or $applicationSecret -eq "" -or $applicationScope -eq "")
{
    if($accountName -eq "" -or $userKey -eq "")
    {
        if($orchestrator_user -eq "" -or $orchestrator_pass -eq "")
        {
            WriteLog "Fill the required paramters (External App OAuth, API Access, or Username & Password)"
            exit 1
        }
    }
}

#Building uipath cli paramters
$ParamList.Add("job")
$ParamList.Add("run")
$ParamList.Add($processName)
$ParamList.Add($uriOrch)
$ParamList.Add($tenantlName)

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
if($accountName -ne ""){
    $ParamList.Add("--accountName")
    $ParamList.Add($accountName)
}
if($userKey -ne ""){
    $ParamList.Add("--token")
    $ParamList.Add($userKey)

}
if($orchestrator_user -ne ""){
    $ParamList.Add("--username")
    $ParamList.Add($orchestrator_user)
}
if($orchestrator_pass -ne ""){
    $ParamList.Add("--password")
    $ParamList.Add($orchestrator_pass)
}
if($input_path -ne ""){
    $ParamList.Add("--input_path")
    $ParamList.Add($input_path)
}
if($jobscount -ne ""){
    $ParamList.Add("--jobscount")
    $ParamList.Add($jobscount)
}
if($result_path -ne ""){
    $ParamList.Add("--result_path")
    $ParamList.Add($result_path)
}
if($priority -ne ""){
    $ParamList.Add("--priority")
    $ParamList.Add($priority)
}
if($robots -ne ""){
    $ParamList.Add("--robots")
    $ParamList.Add($robots)
}
if($folder_organization_unit -ne ""){
    $ParamList.Add("--organizationUnit")
    $ParamList.Add($folder_organization_unit)
}
if($language -ne ""){
    $ParamList.Add("--language")
    $ParamList.Add($language)
}
if($user -ne ""){
    $ParamList.Add("--user")
    $ParamList.Add($user)
}
if($machine -ne ""){
    $ParamList.Add("--machine")
    $ParamList.Add($machine)
}
if($timeout -ne ""){
    $ParamList.Add("--timeout")
    $ParamList.Add($timeout)
}
if($fail_when_job_fails -ne ""){
    $ParamList.Add("--fail_when_job_fails")
    $ParamList.Add($fail_when_job_fails)
}
if($wait -ne ""){
    $ParamList.Add("--wait")
    $ParamList.Add($wait)
}
if($job_type -ne ""){
    $ParamList.Add("--job_type")
    $ParamList.Add($job_type)
}
if($disableTelemetry -ne ""){
    $ParamList.Add("--disableTelemetry")
    $ParamList.Add($disableTelemetry)
}

#mask sensitive info before logging 
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
WriteLog "-----------------------------------------------------------------------------"

#call uipath cli 
& "$uipathCLI" $ParamList.ToArray()

if($LASTEXITCODE -eq 0)
{
    WriteLog "Done!"
    Exit 0
}else {
    WriteLog "Unable to run process. Exit code $LASTEXITCODE"
    Exit 1
}