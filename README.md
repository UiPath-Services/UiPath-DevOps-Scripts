
## Release Notes
### Released Date 24/04/2024
- testing with the latest [UiPath CLI](https://docs.uipath.com/test-suite/docs/uipath-command-line-interface) as of date ([version 23.10.8753.32995](https://uipath.visualstudio.com/Public.Feeds/_artifacts/feed/UiPath-Official/NuGet/UiPath.CLI.Windows/versions/23.10.8753.32995))
- bug fixes
### Released Date 13/02/2023
- Upgraded the scripts to use the official [UiPath CLI](https://docs.uipath.com/test-suite/docs/uipath-command-line-interface)  
- for self-hosted agents, add paramter to provide path of the UiPath CLI if available on the machine instead of auto downloading the scrip 
# UiPath DevOps Scripts 🤖

Package, deploy, run automations, run tests, manage assets, and analyze automatin projects.  
[Youtube Video](https://www.youtube.com/watch?v=asdh8XTUQtQ) The video was created when the library was first released, so it does not include any features added afterward.
[![Youtube Video](https://img.youtube.com/vi/asdh8XTUQtQ/0.jpg)](https://www.youtube.com/watch?v=asdh8XTUQtQ)


## Overview

More and more customers are requesting integrations of uipath platform to other platforms like GitLab and Circle CI and UiPath is not able to create native plugins for all of them.

This **unofficial** library of DevOps PowerShell scripts will support customers to facilitate the interaction with the offical UiPath CLI to integrate CI/CD into their workflows and allow them to package, deploy and run automations and tests.

## Prerequisite:

- The provisioned vm or agent should be a window machine
- Add a step in your CI/CD pipepline to download the descired scripts. (Download only the scripts you need, for example if you want to Pack an RPA project then download UiPathPack script)
Use the scripts below as one step in your pipeline and give at any name (e.g. "Preparing Environment")

It is recommended to download copy of the scripts from the [scripts folder](scripts) into your own repository 
 ```PowerShell
 #Create scripts folder under C drive. (you can change the directory path )
 New-Item -Path "C:\\" -ItemType "directory" -Name "scripts";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathPack.ps1" -OutFile "C:\\scripts\\UiPathPack.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathDeploy.ps1" -OutFile "C:\\scripts\\UiPathDeploy.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathJobRun.ps1" -OutFile "C:\\scripts\\UiPathJobRun.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathRunTest.ps1" -OutFile "C:\\scripts\\UiPathRunTest.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathManageAssets.ps1" -OutFile "C:\\scripts\\UiPathManageAssets.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathAnalyzeProject.ps1" -OutFile "C:\\scripts\\UiPathAnalyzeProject.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathCLIGeneric.ps1" -OutFile "C:\\scripts\\UiPathCLIGeneric.ps1";
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

Five available scripts can be utilized 

| Script  | Description |
| ------------- | ------------- |
| [UiPathPack](docs/UiPathPack.md)  | Pack one or more projects into a package. Click on the name for detailed documentation |
| [UiPathDeploy](docs/UiPathDeploy.md)  | Deploy packages to an Orchestrator instance, optionally publishing them to a set of environments. Click on the name for detailed documentation  |
| [UiPathJobRun](docs/UiPathJobRun.md) | Trigger a job on Orchestrator. Click on the name for detailed documentation  |
| [UiPathRunTest](docs/UiPathRunTest.md) | Tests a given package or runs a test set. Click on the name for detailed documentation  |
| [UiPathManageAssets](docs/UiPathManageAssets.md) | Manage uipath orchestrator assets.  |
| [UiPathAnalyzeProject](docs/UiPathAnalyzeProject.md) | Check project(s) for workflow analyzer violations  |
| [UiPathCLIGeneric](docs/UiPathCLIGeneric.md) | This script is designed for those who know how to work with uipcli.exe and would like to call the cli directly. This script will pass the provided parameters as is directly to uipcli.exe.  |

---


### PipleLines Samples provided in the video
 [CircleCI sample](yaml_samples/circleci_sample.yml)  
 [GitLab sample](yaml_samples/gitlab_sample.yml)  

### Logging

Each script will log all output to its own `*.log` file and sometimes to the console.

### Dependency
`The scripts will automatically download the dependencies during the runtime`  
[Official UiPath CLI](https://uipath.visualstudio.com/Public.Feeds/_artifacts/feed/UiPath-Official/NuGet/UiPath.CLI.Windows/versions/23.10.8753.32995)


* Package Pack
* Package Deploy
* Job Run
* Test Run
* asset delete
* asset deploy  
* package analyze
