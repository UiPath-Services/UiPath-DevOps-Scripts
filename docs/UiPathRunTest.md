
# UiPathRunTest
Tests a given package or runs a test set.
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathRunTest.ps1' <orchestrator_url> <orchestrator_tenant> [-project_path <package>] [-testset <testset>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-environment <environment>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

Examples:
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -S "MyRobotTests"
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -environment TestingEnv
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder -environment MyEnvironment
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -testset "MyRobotTests"
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -out junit
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -result_path "C:\results.json" -out uipath -language en-US

#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
Script Parameters
- `project_path` 
     The path to a test package file.

- `testset` 
     The name of the test set to execute. The test set should use the latest version of the test cases. If the test set does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestSet

- `orchestrator_url`
    Required. The URL of the Orchestrator instance.

- `orchestrator_tenant` 
    Required. The tenant of the Orchestrator instance.

- `result_path` 
    Results file path

- `orchestrator_user`
    Required. The Orchestrator username used for authentication. Must be used together with the password.

- `orchestrator_pass`
    Required. The Orchestrator password used for authentication. Must be used together with the username

- `UserKey`
    Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

- `account_name`
    Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

- `folder_organization_unit`
    The Orchestrator folder (organization unit).

- `environment`
    The environment to deploy the package to. Must be used together with the project path. Required when not using a modern folder.

- `timeout`
    The time in seconds for waiting to finish test set executions. (default 7200) 

- `out`
    Type of result file

- `language`
    The orchestrator language.

- `disableTelemetry`
    Disable telemetry data.