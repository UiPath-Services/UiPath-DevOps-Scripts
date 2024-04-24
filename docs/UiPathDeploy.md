
# UiPathDeploy
Deploy packages to an Orchestrator instance, optionally publishing them to a set of environments.
```PowerShell
SYNTAX
    . 'C:\scripts\\UiPathDeploy.ps1'  <packages_path> <orchestrator_url> <orchestrator_tenant> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-accountForApp <account_for_app> -applicationId <application_id> -applicationSecret <application_secret> -applicationScope <applicationScope>] [-folder_organization_unit <folder_organization_unit>] [-entryPoints Main.xaml][-environment_list <environment_list>] [-language <language>] [-uipathCliFilePath <uipcli_path>]
Examples:
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project 1" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\Package.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\TestsPackage.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -environment_list SAPEnvironment,ExcelAutomationEnvironment -language en-US
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\Package.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\TestsPackage.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -accountForApp myAccountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read"
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\TestsPackage.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -environment_list SAPEnvironment,ExcelAutomationEnvironment -language en-US -entryPoints EntryPoint1,EntryPoint2

#Note: if script path is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
if running on self-hosted agent and UiPath CLI is available on the agent machine, provide `-uipathCliFilePath` 
```PowerShell
Examples:
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project 1" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -uipathCliFilePath "C:\uipathcli\uipcli.exe"
```

More on different authentication options here [UiPathAuthenticationsOptions](UiPathAuthenticationsOptions.md)

Script Parameters
  -  `packages_path` 
     Required. The path to a folder containing packages, or to a package file.

-  `orchestrator_url`
    Required. The URL of the Orchestrator instance.

-  `orchestrator_tenant`
    Required. The tenant of the Orchestrator instance.

-  `orchestrator_user`
    Required. The Orchestrator username used for authentication. Must be used together with the password.

-  `orchestrator_pass`
    Required. The Orchestrator password used for authentication. Must be used together with the username

-  `UserKey`
    Required. The Orchestrator OAuth2 refresh token used for authentication. Must be used together with the account name and client id.

-  `account_name`
    Required. The Orchestrator CloudRPA account name. Must be used together with the refresh token and client id.

-  `accountForApp` 
    The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

-  `applicationId` 
    The external application id. Must be used together with account, secret and scope(s) for external application.

-  `applicationSecret` 
    The external application secret. Must be used together with account, id and scope(s) for external application.

-  `applicationScope` 
    The space-separated list of application scopes. Must be used together with account, id and secret for external application.

-  `folder_organization_unit`
    The Orchestrator folder (organization unit).

-  `entryPoints`
     Define the specific entry points to create or update a process. This is the filePath of the entry point starting from the root of the project. For classic folders only one entry point can be specified, for each environment it will be created or updated a process with the specified entry point.
     
-  `environment_list`
    The comma-separated list of environments to deploy the package to. If the environment does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestEnvironment

-  `language`
    The orchestrator language.

-  `disableTelemetry`
    Disable telemetry data.

-  `uipathCliFilePath`
    if not provided, the script will auto download the cli from uipath public feed. the script was tested on version 23.10.8753.32995

- `SpecificCLIVersion`
    CLI version to auto download if uipathCliFilePath not provided. Default is "23.10.8753.32995" where the script was last tested.