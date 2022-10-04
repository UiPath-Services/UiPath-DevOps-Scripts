
# UiPathPack
 Check project(s) for workflow analyzer violations
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathAnalyzeProject.ps1' <project_path> [-analyzerTraceLevel <analyzer_trace_level>] [-stopOnRuleViolation <true|false>] [-treatWarningsAsErrors <true|false>] [-saveOutputToFile] [-ignoredRules <activity_1_id,activity_2_id,activity_3_id,activity_4_id>] [-orchestratorUrl <orchestrator_url> -orchestratorTenant <orchestrator_tenant>] [-orchestratorUsername <orchestrator_user> -orchestratorPassword <orchestrator_pass>] [-orchestratorAuthToken <auth_token> -orchestratorAccountName <account_name>] [-orchestratorFolder <folder>]

Examples:
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json"
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error"
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true 
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true -resultPath "C:\UiPath\Project\output.json"
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true -resultPath "C:\UiPath\Project\output.json" -ignoredRules "ST-NMG-009,ST-DBP-020,UI-USG-011,ST-DBP-020"
    . 'C:\scripts\UiPathAnalyzeProject.ps1' "C:\UiPath\Project\project.json" -analyzerTraceLevel "Error" -stopOnRuleViolation true -treatWarningsAsErrors true -resultPath "C:\UiPath\Project\output.json" -ignoredRules "ST-NMG-009,ST-DBP-020,UI-USG-011,ST-DBP-020" -orchestratorUrl "https://orchestratorurl.com" -orchestratorTenant "default" -orchestratorUsername "username" -orchestratorPassword "\_ye5zG9(x" -orchestratorAuthToken "AuthToken" -orchestratorAccountName "AccountName" -orchestratorFolder "OrchestratorFolder"
    

#Note: if the script folder location is different, you need to replace "C:" with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```

More on different authentication options here [UiPathAuthenticationsOptions](UiPathAuthenticationsOptions.md)

Script Parameters
-  `project_path` 
     Required. Path to a project.json file or a folder containing project.json files.

-  `analyzerTraceLevel`
    Specifies what types of messages to output (Off|Error|Warning|Info|Verbose).

-  `stopOnRuleViolation` 
    Fail the job when any rule is violated.

-  `treatWarningsAsErrors` 
    Treat warnings as errors.

-  `resultPath` 
    The full path to a JSON file where the result json file will be created. Otherwise print it to the standard console.

-  `ignoredRules` 
    (Default: ) A comma-separated list of rules to be ignored by the analysis procedure.

-  `orchestratorUsername` 
    (Optional, useful only for additional package feeds) The Orchestrator username used for authentication. Must be used together with the password.

-  `orchestratorPassword`
    (Optional, useful only for additional package feeds) The Orchestrator password used for authentication. Must be used together with the username.

-  `orchestratorAuthToken`
    (Optional, useful only for additional package feeds) The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

-  `orchestratorAccountName`
    (Optional, useful only for additional package feeds) The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

-  `orchestratorAccountForApp`
    (Optional, useful only for additional package feeds) The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

-  `orchestratorApplicationId`
    (Optional, useful only for additional package feeds) The external application id. Must be used together with account, secret and scope(s) for external application.

-  `orchestratorApplicationSecret`
    (Optional, useful only for additional package feeds) The external application secret. Must be used together with account, id and scope(s) for external application.

-  `orchestratorApplicationScope`
    (Optional, useful only for additional package feeds) The space-separated list of application scopes. Must be used together with account, id and secret for external application.

-  `orchestratorFolder`
    (Optional, useful only for additional package feeds) The Orchestrator folder (organization unit).

-  `orchestratorUrl`
    (Optional, useful only for additional package feeds) The Orchestrator URL.

-  `orchestratorTenant`
    (Optional, useful only for additional package feeds) The Orchestrator tenant.
