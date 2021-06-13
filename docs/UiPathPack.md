
# UiPathPack
 Pack one or more projects into a package.
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathPack.ps1' <project_path> -destination_folder <destination_folder> [-version <version>] [-autoVersion] [-outputType <Process|Library|Tests|Objects>] [-libraryOrchestratorUrl <orchestrator_url> -libraryOrchestratorTenant <orchestrator_tenant>] [-libraryOrchestratorUsername <orchestrator_user> --libraryOrchestratorPassword <orchestrator_pass>] [-libraryOrchestratorUserKey <UserKey> -libraryOrchestratorAccountName <account_name>] [-libraryOrchestratorFolder <folder>] [-language <language>]

Examples:
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package"
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -version 1.0.6820.22047
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -autoVersion
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project" -destination_folder "C:\UiPath\Package"
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -outputType Tests -language en-US

#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
Script Parameters
-  `project_path` 
     Required. Path to a project.json file or a folder containing project.json files.

-  `destination_folder` 
     Required. Destination folder.

-  `libraryOrchestratorUrl` 
    (Optional, useful only for libraries) The Orchestrator URL.

-  `libraryOrchestratorTenant` 
    (Optional, useful only for libraries) The Orchestrator tenant.

-  `libraryOrchestratorUsername`
    (Optional, useful only for libraries) The Orchestrator password used for authentication. Must be used together with the username.

-  `libraryOrchestratorPassword`
    (Optional, useful only for libraries) The Orchestrator username used for authentication. Must be used together with the password.

-  `libraryOrchestratorUserKey`
    (Optional, useful only for libraries) The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

-  `libraryOrchestratorAccountName`
    (Optional, useful only for libraries) The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

-  `libraryOrchestratorFolder`
    (Optional, useful only for libraries) The Orchestrator folder (organization unit).

-  `version`
    Package version.

-  `autoVersion`
    Auto-generate package version.

-  `outputType`
    Force the output to a specific type. <Process|Library|Tests|Objects>

-  `language`
    The orchestrator language.

-  `disableTelemetry`
    Disable telemetry data.
