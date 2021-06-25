
# UiPathJobRun
Trigger a job on Orchestrator
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathJobRun.ps1' -processName <processName> <uriOrch> <tenantlName> [-accountName <abumayar> -userKey <userKey>] [-folder_organization_unit <folder_organization_unit>]
    . 'C:\scripts\UiPathJobRun.ps1' -processName <processName> <uriOrch> <tenantlName> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-folder_organization_unit <folder_organization_unit>]

Example 1:

. 'C:\scripts\UiPathJobRun.ps1' -processName SimpleRPAFlow -uriOrch https://cloud.uipath.com -tenantlName AbdullahTenant -accountName accountLogicalName -userKey xxxxxxxxxx -folder_organization_unit folderName

#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
Script Parameters
-  `processName` 
    orchestrator process name to run.

-  `uriOrch` 
    The URL of Orchestrator.

-  `tenantlName` 
    The tenant name

-  `orchestrator_user`
    On-premises Orchestrator admin user name who has a Role of Create Package.

-  `orchestrator_pass`
    The password of the on-premises Orchestrator admin user.

-  `userKey`
    User key for Cloud Platform Orchestrator

-  `accountName`
    Account logical name for Cloud Platform Orchestrator

-  `input_path`
    Client ID for Cloud Platform Orchestrator

-  `input_path`
    The full path to a JSON input file. Only required if the entry-point workflow has input parameters.

-  `jobscount`
    The number of job runs. (default 1)

-  `result_path`
    The full path to a JSON file or a folder where the result json file will be created.

-  `priority`
    The priority of job runs. One of the following values: Low, Normal, High. (default Normal)

-  `robots`
    The comma-separated list of specific robot names.

-  `folder_organization_unit`
    The Orchestrator folder (organization unit).

-  `user`
    The name of the user. This should be a machine user, not an orchestrator user. For local users, the format should be MachineName\UserName

-  `language`
    The orchestrator language.

-  `machine`
    The name of the machine.

-  `timeout`
    The timeout for job executions in seconds. (default 1800)

-  `fail_when_job_fails`
    The command fails when at least one job fails. (default true)

-  `wait`
    The command waits for job runs completion. (default true)

-  `job_type`
    The type of the job that will run. Values supported for this command: Unattended, NonProduction. For classic folders do not specify this argument

-  `disableTelemetry`
    Disable telemetry data.