<#
.SYNOPSIS 
    Manage uipath orchestrator assets

.DESCRIPTION 
    Delete assets from an Orchestrator instance (based on asset name).
    Deploy assets to an Orchestrator instance.

.PARAMETER $operation 
    Manage assets operation (delete | deploy) 

.PARAMETER $assets_file 
     The following is a sample csv file. The column names are required! Only the first column is used but you need to at least have empty columns in place.
                                  name,type,value
                                  asset_1_name,boolean,false # we can have comments
                                  asset_2_name,integer,
                                  asset_3_name,text,
                                  asset_4_name,credential,username::password

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


.PARAMETER language
    The orchestrator language.

.PARAMETER disableTelemetry
    Disable telemetry data.

.EXAMPLE
SYNTAX
    . 'C:\scripts\UiPathManageAssets.ps1' <operation> <assets_file.csv> <orchestrator_url> <orchestrator_tenant> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

  Examples (Deploy Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US
  
  Examples (Delete Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US

    #>
Param (

    #Required
	[string] $operation = "", #Manage assets operation (delete | deploy) 
	[string] $assets_file = "", #Assets file
    
    [string] $orchestrator_url = "", #Required. The URL of the Orchestrator instance.
	[string] $orchestrator_tenant = "", #Required. The tenant of the Orchestrator instance.

    #cloud - Required
    [string] $account_name = "", #Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
	[string] $UserKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
    
    #On prem - Required
    [string] $orchestrator_user = "", #Required. The Orchestrator username used for authentication. Must be used together with the password.
	[string] $orchestrator_pass = "", #Required. The Orchestrator password used for authentication. Must be used together with the username
	
	[string] $folder_organization_unit = "", #The Orchestrator folder (organization unit).
	[string] $language = "", #-l, --language                  The orchestrator language.  
    [string] $disableTelemetry = "", #-y, --disableTelemetry          Disable telemetry data.   
    [string] $timeout = "" # The time in seconds for waiting to finish test set executions. (default 7200) 

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


if($operation -ne "delete" -and $operation -ne "deploy"){
    WriteLog "invalid operation. operation must either be 'delete' or 'deploy'. You typed '$operation'"
    exit 1
}

#full path of asset file
if(-not($assets_file.Contains("\")))
{
    $assets_file = "$scriptPath\$assets_file"
}
if (-not(Test-Path -Path $assets_file -PathType Leaf)) {
    WriteLog "asset file does not exist ($assets_file)"
    exit 1
}
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
$ParamList.Add("asset")
$ParamList.Add("$operation")
$ParamList.Add($assets_file)
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
    WriteLog "Unable to execute command. Exit code $LASTEXITCODE"
    Exit 1
}
