
# UiPath DevOps Scripts 🤖

Package, deploy, run automations, tests & manage assets.

## Overview

More and more customers are requesting integrations of uipath platform to other platforms like GitLab and Circle CI and UiPath is not able to create native plugins for all of them.

Until a generic solution is officially released, this unofficial library of DevOps PowerShell scripts will support customers to integrate CI/CD into their workflows and allow them to package, deploy and run automations and tests.

## Prerequisite:

- The provisioned vm or agent should be a window machine
- Add a step in your CI/CD pipepline to download the descired scripts. (Downlod only the scripts you need, for example if you want to Pack an RPA project then download UiPathPack script)
Use the scripts below as one step in your pipeline and give at any name (e.g. "Preparing Environment")
 ```PowerShell
 #Create scripts folder under C drive. (you can change the directory path )
 New-Item -Path "C:\\" -ItemType "directory" -Name "scripts";
 Invoke-WebRequest "https://github.com/SE-Abdullah/UiPath-DevOps-Scripts/raw/main/scripts/UiPathPack.ps1" -OutFile "C:\\scripts\\UiPathPack.ps1";
 Invoke-WebRequest "https://github.com/SE-Abdullah/UiPath-DevOps-Scripts/raw/main/scripts/UiPathDeploy.ps1" -OutFile "C:\\scripts\\UiPathDeploy.ps1";
 Invoke-WebRequest "https://github.com/SE-Abdullah/UiPath-DevOps-Scripts/raw/main/scripts/UiPathJobRun.ps1" -OutFile "C:\\scripts\\UiPathJobRun.ps1";
 Invoke-WebRequest "https://github.com/SE-Abdullah/UiPath-DevOps-Scripts/raw/main/scripts/UiPathRunTest.ps1" -OutFile "C:\\scripts\\UiPathRunTest.ps1";
 Invoke-WebRequest "https://github.com/SE-Abdullah/UiPath-DevOps-Scripts/raw/main/scripts/UiPathManageAssets.ps1" -OutFile "C:\\scripts\\UiPathManageAssets.ps1";
```


<details>
<summary>
<b><a class="btnfire small stroke"><em class="fas fa-chevron-circle-down"></em>&nbsp;&nbsp;You can't create directory outside your CI/CD privisioned machine?</a></b>  
</summary>
Some CI/CD tool, like gitlab, may not allow the creation of folder outside the build/working directory . For this you need to place the folder and scripts inside the working directory. In the above script you will need to replace "C:\\" with the the CI/CD tool variable referencing the working directory. <br />
 for example, <br />
 GitLab <b>$env:CI_PROJECT_DIR</b><br />
 GitHub Actions: <b>${{github.workspace}}</b><br />
 ..etc<br />

</details>



## Powershell Scripts

### [UiPathPack](docs/UiPathPack.md) 
 Pack one or more projects into a package. Click on the name for detailed documentation
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathPack.ps1' <project_path> -destination_folder <destination_folder> [-version <version>] [-autoVersion] [-outputType <Process|Library|Tests|Objects>] [-libraryOrchestratorUrl <orchestrator_url> -libraryOrchestratorTenant <orchestrator_tenant>] [-libraryOrchestratorUsername <orchestrator_user> -libraryOrchestratorPassword <orchestrator_pass>] [-libraryOrchestratorUserKey <UserKey> -libraryOrchestratorAccountName <account_name>] [-libraryOrchestratorFolder <folder>] [-language <language>]

Examples:
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package"
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -version 1.0.6820.22047
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -autoVersion
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project" -destination_folder "C:\UiPath\Package"
    . 'C:\scripts\UiPathPack.ps1' "C:\UiPath\Project\project.json" -destination_folder "C:\UiPath\Package" -outputType Tests -l en-US

    #Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```

###  [UiPathDeploy](docs/UiPathDeploy.md) 
Deploy packages to an Orchestrator instance, optionally publishing them to a set of environments. Click on the name for detailed documentation
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
### [UiPathJobRun](docs/UiPathJobRun.md) 
Trigger a job on Orchestrator. Click on the name for detailed documentation
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathJobRun.ps1' -processName <processName> <uriOrch> <tenantlName> [-accountName <accountName> -userKey <userKey>] [-folder_organization_unit <folder_organization_unit>]
    . 'C:\scripts\UiPathJobRun.ps1' -processName <processName> <uriOrch> <tenantlName> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-folder_organization_unit <folder_organization_unit>]

Example 1:

    . 'C:\scripts\UiPathJobRun.ps1' -processName SimpleRPAFlow -uriOrch https://cloud.uipath.com -tenantlName AbdullahTenant -accountName accountLogicalName -userKey xxxxxxxxxx -folder_organization_unit folderName

    #Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
### [UiPathRunTest](docs/UiPathRunTest.md) 
Tests a given package or runs a test set. Click on the name for detailed documentation
```PowerShell
SYNTAX
    .\UiPathRunTest.ps1 <orchestrator_url> <orchestrator_tenant> [-project_path <package>] [-testset <testset>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-environment <environment>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

Examples:
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -testset "MyRobotTests"
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -environment TestingEnv
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -project_path "C:\UiPath\Project\project.json" -folder_organization_unit MyFolder -environment MyEnvironment

    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -testset "MyRobotTests"
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -out junit
    . 'C:\scripts\UiPathRunTest.ps1' "https://uipath-orchestrator.myorg.com" default -UserKey a7da29a2c93a717110a82 -account_name myAccount -project_path "C:\UiPath\Project\project.json" -environment TestingEnv -result_path "C:\results.json" -out uipath -language en-US
    #Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')

```

###  [UiPathManageAssets](docs/UiPathManageAssets.md) 
Deploy packages to an Orchestrator instance, optionally publishing them to a set of environments. Click on the name for detailed documentation
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
---

### Logging

Each script will log all output to its own `*.log` file and sometimes to the console.

### Dependency

[UiPath CLI](https://www.myget.org/feed/uipath-dev/package/nuget/UiPath.CLI)

* Package Pack
* Package Deploy
* Job Run
* Test Run