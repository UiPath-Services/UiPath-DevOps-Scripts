<#
.SYNOPSIS 
    Check project(s) for workflow analyzer violations

.DESCRIPTION 
    This script is used to analyze UiPath Studio Project for Warrning & Errors.

.PARAMETER ProjectPath 
     Required. Path to a project.json file or a folder containing project.json files.

.PARAMETER analyzerTraceLevel 
    Specifies what types of messages to output (Off|Error|Warning|Info|Verbose).

.PARAMETER stopOnRuleViolation 
    Fail the job when any rule is violated.

.PARAMETER treatWarningsAsErrors 
    Treat warnings as errors.

.PARAMETER resultPath 
    The full path to a JSON file where the result json file will be created. Otherwise print it to the standard console.

.PARAMETER ignoredRules 
    (Default: ) A comma-separated list of rules to be ignored by the analysis procedure.

.PARAMETER orchestratorUsername 
    (Optional, useful only for additional package feeds) The Orchestrator username used for authentication. Must be used together with the password.

.PARAMETER orchestratorPassword
    (Optional, useful only for additional package feeds) The Orchestrator password used for authentication. Must be used together with the username.

.PARAMETER orchestratorAuthToken
    (Optional, useful only for additional package feeds) The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

.PARAMETER orchestratorAccountName
    (Optional, useful only for additional package feeds) The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

.PARAMETER orchestratorAccountForApp
    (Optional, useful only for additional package feeds) The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

.PARAMETER orchestratorApplicationId
    (Optional, useful only for additional package feeds) The external application id. Must be used together with account, secret and scope(s) for external application.

.PARAMETER orchestratorApplicationSecret
    (Optional, useful only for additional package feeds) The external application secret. Must be used together with account, id and scope(s) for external application.

.PARAMETER orchestratorApplicationScope
    (Optional, useful only for additional package feeds) The space-separated list of application scopes. Must be used together with account, id and secret for external application.

.PARAMETER orchestratorFolder
    (Optional, useful only for additional package feeds) The Orchestrator folder (organization unit).

.PARAMETER orchestratorUrl
    (Optional, useful only for additional package feeds) The Orchestrator URL.

.PARAMETER orchestratorTenant
    (Optional, useful only for additional package feeds) The Orchestrator tenant.

.PARAMETER uipathCliFilePath
    if not provided, the script will auto download the cli from uipath public feed. the script was testing on version 22.10.8438.32859

.EXAMPLE
SYNTAX
    . '\UiPathAnalyzeProject.ps1' <project_path> [-analyzerTraceLevel <analyzer_trace_level>] [-stopOnRuleViolation <true|false>] [-treatWarningsAsErrors <true|false>] [-saveOutputToFile] [-ignoredRules <activity_1_id,activity_2_id,activity_3_id,activity_4_id>] [-orchestratorUrl <orchestrator_url> -orchestratorTenant <orchestrator_tenant>] [-orchestratorUsername <orchestrator_user> -orchestratorPassword <orchestrator_pass>] [-orchestratorAuthToken <auth_token> -orchestratorAccountName <account_name>] [-orchestratorFolder <folder>]
Examples:
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json"
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error"
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true 
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true -resultPath "C:\UiPath\Project\output.json"
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true -resultPath "C:\UiPath\Project\output.json" -ignoredRules "ST-NMG-009,ST-DBP-020,UI-USG-011,ST-DBP-020"
    . '\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true -resultPath "C:\UiPath\Project\output.json" -ignoredRules "ST-NMG-009,ST-DBP-020,UI-USG-011,ST-DBP-020" -orchestratorUrl "https://orchestratorurl.com" -orchestratorTenant "default" -orchestratorUsername "username" -orchestratorPassword "\_ye5zG9(x" -orchestratorAuthToken "AuthToken" -orchestratorAccountName "AccountName" -orchestratorFolder "OrchestratorFolder"
    
    #>
    Param (

        #Required
        [string] $ProjectPath = "", # Required. Path to a project.json file or a folder containing project.json files.
        [string] $analyzerTraceLevel = "", #Specifies what types of messages to output (Off|Error|Warning|Info|Verbose).
        [string] $stopOnRuleViolation = "", #Fail the job when any rule is violated.
        [string] $treatWarningsAsErrors = "", #Treat warnings as errors.
        [string] $resultPath = "", #The full path to a JSON file where the result json file will be created. Otherwise print it to the standard console.
        [string] $ignoredRules = "", #(Default: ) A comma-separated list of rules to be ignored by the analysis procedure.
        [string] $orchestratorUsername = "", #(Optional, useful only for additional package feeds) The Orchestrator username used for authentication. Must be used together with the password.
        [string] $orchestratorPassword = "", #(Optional, useful only for additional package feeds) The Orchestrator password used for authentication. Must be used together with the username.
        [string] $orchestratorAuthToken = "", # (Optional, useful only for additional package feeds) The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.
        [string] $orchestratorAccountName = "", #(Optional, useful only for additional package feeds) The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.
        [string] $orchestratorAccountForApp = "",#(Optional, useful only for additional package feeds) The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.
        [string] $orchestratorApplicationId = "", #(Optional, useful only for additional package feeds) The external application id. Must be used together with account, secret and scope(s) for external application.
        [string] $orchestratorApplicationSecret = "", #(Optional, useful only for additional package feeds) The external application secret. Must be used together with account, id and scope(s) for external application.
        [string] $orchestratorApplicationScope = "", #(Optional, useful only for additional package feeds) The space-separated list of application scopes. Must be used together with account, id and secret for external application.
        [string] $orchestratorFolder = "", #(Optional, useful only for additional package feeds) The Orchestrator folder (organization unit).
        [string] $orchestratorUrl = "", #(Optional, useful only for additional package feeds) The Orchestrator URL.
        [string] $orchestratorTenant = "", #(Optional, useful only for additional package feeds) The Orchestrator tenant.    
        [string] $uipathCliFilePath = "" #if not provided, the script will auto download the cli from uipath public feed. the script was testing on version 22.10.8432.18709. if provided, it is recommended to have cli version 22.10.8432.18709 
    
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
    $debugLog = "$scriptPath\orchestrator-package-analyze.log"
    
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
    
    
    $ParamList = New-Object 'Collections.Generic.List[string]'
    
    #region Verifying required paramteters
    if($ProjectPath -eq "") 
    {
        WriteLog "Fill the required paramters (packagesPath)"
        exit 1
    }
    
    #endregion Verifying required paramteters
    
    #Building uipath cli paramters
    $ParamList.Add("package")
    $ParamList.Add("analyze")
    $ParamList.Add($ProjectPath)
    
    
    if($analyzerTraceLevel -ne ""){
        $ParamList.Add("--analyzerTraceLevel")
        $ParamList.Add($analyzerTraceLevel)
    }
    if($stopOnRuleViolation -ne ""){
        if($stopOnRuleViolation.Trim().ToLower() -eq "true"){
            $ParamList.Add("--stopOnRuleViolation")
        }
    }
    if($treatWarningsAsErrors -ne ""){
        if($treatWarningsAsErrors.Trim().ToLower() -eq "true"){
            $ParamList.Add("--treatWarningsAsErrors")
        }
    }
    if($resultPath -ne ""){
        $ParamList.Add("--resultPath")
        $ParamList.Add($resultPath)
    }
    if($ignoredRules -ne ""){
        $ParamList.Add("--ignoredRules")
        $ParamList.Add("`"$ignoredRules`"")
    }
    if($orchestratorUsername -ne ""){
        $ParamList.Add("--orchestratorUsername")
        $ParamList.Add($orchestratorUsername)
    }
    if($orchestratorPassword -ne ""){
        $ParamList.Add("--orchestratorPassword")
        $ParamList.Add($orchestratorPassword)
    }
    if($orchestratorAuthToken -ne ""){
        $ParamList.Add("--orchestratorAuthToken")
        $ParamList.Add($orchestratorAuthToken)
    }
    if($orchestratorAccountName -ne ""){
        $ParamList.Add("--orchestratorAccountName")
        $ParamList.Add($orchestratorAccountName)
    }
    if($orchestratorAccountForApp -ne ""){
        $ParamList.Add("--orchestratorAccountForApp")
        $ParamList.Add($orchestratorAccountForApp)
    }
    if($orchestratorApplicationId -ne ""){
        $ParamList.Add("--orchestratorApplicationId")
        $ParamList.Add($orchestratorApplicationId)
    }
    if($orchestratorApplicationSecret -ne ""){
        $ParamList.Add("--orchestratorApplicationSecret")
        $ParamList.Add($orchestratorApplicationSecret)
    }
    if($orchestratorApplicationScope -ne ""){
        $ParamList.Add("--orchestratorApplicationScope")
        $ParamList.Add("`"$orchestratorApplicationScope`"")
    }
    if($orchestratorFolder -ne ""){
        $ParamList.Add("--orchestratorFolder")
        $ParamList.Add($orchestratorFolder)
    }
    if($orchestratorUrl -ne ""){
        $ParamList.Add("--orchestratorUrl")
        $ParamList.Add($orchestratorUrl)
    }
    if($orchestratorTenant -ne ""){
        $ParamList.Add("--orchestratorTenant")
        $ParamList.Add($orchestratorTenant)
    }
    
    
    
    
    #mask sensitive info before logging 
    $ParamMask = New-Object 'Collections.Generic.List[string]'
    $ParamMask.AddRange($ParamList)
    $secretIndex = $ParamMask.IndexOf("--orchestratorPassword");
    if($secretIndex -ge 0){
        $ParamMask[$secretIndex + 1] = ("*" * 15)
    }
    $secretIndex = $ParamMask.IndexOf("--orchestratorAuthToken");
    if($secretIndex -ge 0){
        $ParamMask[$secretIndex + 1] = $orchestratorAuthToken.Substring(0, [Math]::Min($orchestratorAuthToken.Length, 4)) + ("*" * 15)
    }
    $secretIndex = $ParamMask.IndexOf("--orchestratorApplicationId");
    if($secretIndex -ge 0){
        $ParamMask[$secretIndex + 1] = $orchestratorApplicationId.Substring(0, [Math]::Min($orchestratorApplicationId.Length, 4)) + ("*" * 15)
    }
    $secretIndex = $ParamMask.IndexOf("--orchestratorApplicationSecret");
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
        WriteLog "Analyzer returned errors or unable to analyze the project. Exit code $LASTEXITCODE"
        Exit 1
    }
    