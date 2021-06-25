
# UiPathDeploy
Deploy packages to an Orchestrator instance, optionally publishing them to a set of environments.
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathDeploy.ps1' <packages_path> <orchestrator_url> <orchestrator_tenant> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <UserKey> -account_name <account_name>] [-folder_organization_unit <folder_organization_unit>] [-environment_list <environment_list>] [-language <language>]
Examples:
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project 1" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\Package.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\Package.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount
    . 'C:\scripts\UiPathDeploy.ps1' "C:\UiPath\Project\TestsPackage.1.0.6820.22047.nupkg" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -environment_list SAPEnvironment,ExcelAutomationEnvironment -language en-US

#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
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

-  `folder_organization_unit`
    The Orchestrator folder (organization unit).

-  `environment_list`
    The comma-separated list of environments to deploy the package to. If the environment does not belong to the default folder (organization unit) it must be prefixed with the folder name, e.g. AccountingTeam\TestEnvironment

-  `language`
    The orchestrator language.

-  `disableTelemetry`
    Disable telemetry data.
