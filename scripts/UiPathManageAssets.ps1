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
                                  asset_1_name,text,asset_value # we can have comments,asset_1_description
                                  asset_2_name,integer,123,asset_2_description
                                  asset_3_name,boolean,false,asset_3_description
                                  asset_4_name,credential,"username::password",asset_4_description

.PARAMETER orchestrator_url 
    Required. The URL of the Orchestrator instance.

.PARAMETER orchestrator_tenant 
    Required. The tenant of the Orchestrator instance.

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


.PARAMETER language
    The orchestrator language.

.PARAMETER disableTelemetry
    Disable telemetry data.

.EXAMPLE
SYNTAX
    . 'C:\scripts\UiPathManageAssets.ps1' <operation> <assets_file.csv> <orchestrator_url> <orchestrator_tenant> [-accountForApp <account_for_app> -applicationId <application_id> -applicationSecret <application_secret> -applicationScope <applicationScope>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

  Examples (Deploy Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://cloud.uipath.com" defaultTenant -accountForApp myAccountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -language en-US
  
  Examples (Delete Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://cloud.uipath.com" defaultTenant -accountForApp myAccountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -language en-US

    #>
    Param (

        #Required
        [string] $operation = "", #Manage assets operation (delete | deploy) 
        [string] $assets_file = "", #Assets file
        
        [string] $orchestrator_url = "", #Required. The URL of the Orchestrator instance.
        [string] $orchestrator_tenant = "", #Required. The tenant of the Orchestrator instance.
    
        #External Apps (Option 1)
        [string] $accountForApp = "", #The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.
        [string] $applicationId = "", #Required. The external application id. Must be used together with account, secret and scope(s) for external application.
        [string] $applicationSecret = "", #Required. The external application secret. Must be used together with account, id and scope(s) for external application.
        [string] $applicationScope = "", #Required. The space-separated list of application scopes. Must be used together with account, id and secret for external application.
    
        #API Access - (Option 2)
        [string] $account_name = "", #Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
        [string] $UserKey = "", #Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
        
        #On prem - (Option 3)
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
    #Running Path
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    #log file
    $debugLog = "$scriptPath\orchestrator-test-run.log"
    
    #region Verifying UiPath CLI installation
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
    #endregion Verifying UiPath CLI installation
    
    $ParamList = New-Object 'Collections.Generic.List[string]'
    
    #region validate input paramters
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
        WriteLog "assets file does not exist in ($assets_file)"
        exit 1
    }
    if($orchestrator_url -eq "" -or $orchestrator_tenant -eq "") 
    {
        WriteLog "Fill the required paramters (orchestrator_url, orchestrator_tenant)"
        exit 1
    }
    
    #required parameters (Cloud accountName and userkey) or (on-prem username and password) 
    if($accountForApp -eq "" -or $applicationId -eq "" -or $applicationSecret -eq "" -or $applicationScope -eq "")
    {
        if($account_name -eq "" -or $UserKey -eq "")
        {
            if($orchestrator_user -eq "" -or $orchestrator_pass -eq "")
            {
                WriteLog "Fill the required paramters (External App OAuth, API Access, or Username & Password)"
                exit 1
            }
        }
    }
    #endregion validate input paramters
    
    
    #region Building uipath cli paramters
    $ParamList.Add("asset")
    $ParamList.Add("$operation")
    $ParamList.Add($assets_file)
    $ParamList.Add($orchestrator_url)
    $ParamList.Add($orchestrator_tenant)
    
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
    if($language -ne ""){
        $ParamList.Add("--language")
        $ParamList.Add($language)
    }
    
    if($disableTelemetry -ne ""){
        $ParamList.Add("--disableTelemetry")
        $ParamList.Add($disableTelemetry)
    }
    #endregion Building uipath cli paramters
    
    #Mask sensitive infos before loging
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
        WriteLog "Unable to execute command. Exit code $LASTEXITCODE"
        Exit 1
    }
    