
# UiPath DevOps Scripts 🤖

Package, deploy, run automations, tests & manage assets.  
[Youtube Video](https://www.youtube.com/watch?v=asdh8XTUQtQ)  
[![Youtube Video](https://img.youtube.com/vi/asdh8XTUQtQ/0.jpg)](https://www.youtube.com/watch?v=asdh8XTUQtQ)


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
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathPack.ps1" -OutFile "C:\\scripts\\UiPathPack.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathDeploy.ps1" -OutFile "C:\\scripts\\UiPathDeploy.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathJobRun.ps1" -OutFile "C:\\scripts\\UiPathJobRun.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathRunTest.ps1" -OutFile "C:\\scripts\\UiPathRunTest.ps1";
 Invoke-WebRequest "https://github.com/UiPath-Services/UiPath-DevOps-Scripts/raw/main/scripts/UiPathManageAssets.ps1" -OutFile "C:\\scripts\\UiPathManageAssets.ps1";
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

---


### PipleLines Samples provided in the video
 [CircleCI sample](yaml_samples/circleci_sample.yml)  
 [GitLab sample](yaml_samples/gitlab_sample.yml)  

### Logging

Each script will log all output to its own `*.log` file and sometimes to the console.

### Dependency
`The scripts will automatically download the dependencies during the runtime`  
[UiPath CLI](https://www.myget.org/feed/uipath-dev/package/nuget/UiPath.CLI)

* Package Pack
* Package Deploy
* Job Run
* Test Run
* asset delete
* asset deploy  

