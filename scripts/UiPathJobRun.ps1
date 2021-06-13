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
PS> .\UiPathJobRun -processName SimpleRPAFlow -uriOrch https://cloud.uipath.com -tenantlName AbdullahTenant -accountName acountLogicalName -userKey uYxxxxxxxx -folder_organization_unit MyWork-Dev 
- (Cloud Example) Run a process named SimpleRPAFlow in folder MyWork-Dev 

.EXAMPLE
PS> .\UiPathJobRun -processName SimpleRPAFlow -uriOrch https://myorch.company.com -tenantlName AbdullahTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit MyWork-Dev 
- (On Prem Example) Run a process named SimpleRPAFlow in folder MyWork-Dev 


#>
Param (

    #Required
    
    [string] $processName = "", #Process Name (pos. 0)           Required.
    [string] $uriOrch = "", #Orchestrator URL (pos. 1)       Required. The URL of the Orchestrator instance.
    [string] $tenantlName = "", #Orchestrator Tenant (pos. 2)    Required. The tenant of the Orchestrator instance.

    #cloud - Required
    [string] $accountName = "", #Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
    [string] $userKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem - Required
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
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$debugLog = "$scriptPath\orchestrator-job-run.log"

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

if($processName -eq "" -or $uriOrch -eq "" -or $tenantlName -eq "")
{
    WriteLog "Fill the required paramters"
    exit 1
}

if($accountName -eq "" -or $userKey -eq "")
{
    if($orchestrator_user -eq "" -or $orchestrator_user -eq "")
    {
        WriteLog "Fill the required paramters"

        exit 1
    }
}
#Building uipath cli paramters
$ParamList.Add("job")
$ParamList.Add("run")
$ParamList.Add($processName)
$ParamList.Add($uriOrch)
$ParamList.Add($tenantlName)
if($accountName -ne ""){
    $ParamList.Add("-a")
    $ParamList.Add($accountName)
}
if($userKey -ne ""){
    $ParamList.Add("-t")
    $ParamList.Add($userKey)

}
if($orchestrator_user -ne ""){
    $ParamList.Add("-u")
    $ParamList.Add($orchestrator_user)
}
if($orchestrator_pass -ne ""){
    $ParamList.Add("-p")
    $ParamList.Add($orchestrator_pass)
}
if($input_path -ne ""){
    $ParamList.Add("-i")
    $ParamList.Add($input_path)
}
if($jobscount -ne ""){
    $ParamList.Add("-j")
    $ParamList.Add($jobscount)
}
if($result_path -ne ""){
    $ParamList.Add("-R")
    $ParamList.Add($result_path)
}
if($priority -ne ""){
    $ParamList.Add("-P")
    $ParamList.Add($priority)
}
if($robots -ne ""){
    $ParamList.Add("-r")
    $ParamList.Add($robots)
}
if($folder_organization_unit -ne ""){
    $ParamList.Add("-o")
    $ParamList.Add($folder_organization_unit)
}
if($language -ne ""){
    $ParamList.Add("-l")
    $ParamList.Add($language)
}
if($user -ne ""){
    $ParamList.Add("-U")
    $ParamList.Add($user)
}
if($machine -ne ""){
    $ParamList.Add("-M")
    $ParamList.Add($machine)
}
if($timeout -ne ""){
    $ParamList.Add("-T")
    $ParamList.Add($timeout)
}
if($fail_when_job_fails -ne ""){
    $ParamList.Add("-f")
    $ParamList.Add($fail_when_job_fails)
}
if($wait -ne ""){
    $ParamList.Add("-w")
    $ParamList.Add($wait)
}
if($job_type -ne ""){
    $ParamList.Add("-b")
    $ParamList.Add($job_type)
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
    WriteLog "Unable to run process. Exit code $LASTEXITCODE"
    Exit 1
}