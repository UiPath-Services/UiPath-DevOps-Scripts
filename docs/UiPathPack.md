
# UiPathPack
 Pack one or more projects into a package.
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathPack.ps1' <project_path> -o <destination_folder> [-version <version>] [-autoVersion] [-outputType <Process|Library|Tests|Objects>] [-libraryOrchestratorUrl <orchestrator_url> -libraryOrchestratorTenant <orchestrator_tenant>] [-libraryOrchestratorUsername <orchestrator_user> -libraryOrchestratorPassword <orchestrator_pass>] [-libraryOrchestratorUserKey <auth_token> -libraryOrchestratorAccountName <account_name>] [-libraryOrchestratorAccountForApp <ExternaAppAccount> -libraryOrchestratorApplicationId <AppID> -libraryOrchestratorApplicationSecret <AppSecret> -libraryOrchestratorApplicationScope <AppScope>] 
    [-libraryOrchestratorFolder <folder>] [-language <language>] [-uipathCliFilePath <uipcli_path>]

Examples:
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package"
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -version 1.0.6820.22047
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -autoVersion
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project" -destination_folder "C:\UiPath\Package"
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -outputType Tests -language en-US

#Note: if the script folder location is different, you need to replace "C:" with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
if running on self-hosted agent and UiPath CLI is available on the agent machine, provide `-uipathCliFilePath` 
```PowerShell
Examples:
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -uipathCliFilePath "C:\uipathcli\uipcli.exe"
```
More on different authentication options here [UiPathAuthenticationsOptions](UiPathAuthenticationsOptions.md)

Script Parameters

- `project_path` 
     Required. Path to a project.json file or a folder containing project.json files.

- `destination_folder` 
     Required. Destination folder.

- `libraryOrchestratorUrl` 
    (Optional, useful only for libraries) The Orchestrator URL.

- `libraryOrchestratorTenant` 
    (Optional, useful only for libraries) The Orchestrator tenant.

- `libraryOrchestratorUsername`
    (Optional, useful only for libraries) The Orchestrator password used for authentication. Must be used together with the username.

- `libraryOrchestratorPassword`
    (Optional, useful only for libraries) The Orchestrator username used for authentication. Must be used together with the password.

- `libraryOrchestratorUserKey`
    (Optional, useful only for libraries) The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

- `libraryOrchestratorAccountName`
    (Optional, useful only for libraries) The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

- `libraryOrchestratorAccountForApp`
    (Optional, useful only for libraries) The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

- `libraryOrchestratorApplicationId`
    (Optional, useful only for libraries) The external application id. Must be used together with account, secret and scope(s) for external application.

- `libraryOrchestratorApplicationSecret`
    (Optional, useful only for libraries) The external application secret. Must be used together with account, id and scope(s) for external application.

- `libraryOrchestratorApplicationScope`
    (Optional, useful only for libraries) The space-separated list of application scopes. Must be used together with account, id and secret for external application.

- `libraryOrchestratorFolder`
    (Optional, useful only for libraries) The Orchestrator folder (organization unit).

- `version`
    Package version.

- `autoVersion`
    Auto-generate package version.

- `outputType`
    Force the output to a specific type. <Process|Library|Tests|Objects>

- `language`
    The orchestrator language.

- `disableTelemetry`
    Disable telemetry data.

- `uipathCliFilePath`
    if not provided, the script will auto download the cli from uipath public feed. the script was tested on version 23.10.8753.32995

- `SpecificCLIVersion`
    CLI version to auto download if uipathCliFilePath not provided. Default is "23.10.8753.32995" where the script was last tested.