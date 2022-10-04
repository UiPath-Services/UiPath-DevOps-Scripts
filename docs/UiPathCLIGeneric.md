# UiPathCLIGeneric
 This script is designed for those who know how to work with uipcli.exe and would like to call the cli directly. This script will pass the provided parameters as is directly to Uipcli.exe. 
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathCLIGeneric.ps1' <uipcli desired arguments>

Examples:
    . 'C:\scripts\UiPathCLIGeneric.ps1' package pack "C:\UiPath\Project\project.json" -o "C:\UiPath\Package"
    . 'C:\scripts\UiPathCLIGeneric.ps1' job run ProcessName "https://uipath-orchestrator.myorg.com" default -u admin -p 123456
    . 'C:\scripts\UiPathCLIGeneric.ps1' robot connect machine-name "https://uipath-orchestrator.myorg.com" default -u admin -p 123456 -o OurOrganization -l en-US
    . 'C:\scripts\UiPathCLIGeneric.ps1' machine provision MachineNameExample Template "https://uipath-orchestrator.myorg.com" default -u admin -p 123456 -o ModernFolder -l en-US
    . 'C:\scripts\UiPathCLIGeneric.ps1'app install Studio -m UiPathStudio.msi

#Note: if the script folder location is different, you need to replace "C:" with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
