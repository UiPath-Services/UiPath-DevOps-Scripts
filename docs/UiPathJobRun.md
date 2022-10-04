
# UiPathJobRun
Trigger a job on Orchestrator
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathJobRun.ps1' <process_name> <orchestrator_url> <orchestrator_tenant> [-input_path <input_path>] [-jobscount <jobscount>] [-result_path <result_path>] [-priority <priority>] [-robots <robots>] 
    [-fail_when_job_fails <do_not_fail_when_job_fails>] [-timeout <timeout>] [-wait <do_not_wait>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-userKey <auth_token> -accountName <account_name>] [-accountForApp <account_for_app> -applicationId <application_id> -applicationSecret <application_secret> -applicationScope <applicationScope>] [-folder_organization_unit <folder_organization_unit>] [-language <language>] [-user <robotUser>] [-machine <robotMachine>] [-job_type <Unattended, NonProduction>]

Example 1:

. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -orchestrator_pass -priority Low
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -orchestrator_pass -priority Normal -folder_organization_unit MyFolder
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -orchestrator_user admin -orchestrator_pass 123456 -orchestrator_pass -priority High -folder_organization_unit MyFolder
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -userKey a7da29a2c93a717110a82 -accountName myAccount -fail_when_job_fails false -timeout 0
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -userKey a7da29a2c93a717110a82 -accountName myAccount -orchestrator_pass -priority High -jobscount 3 -wait false -machine ROBOTMACHINE
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://cloud.uipath.com/" default -userKey a7da29a2c93a717110a82 -accountName myAccount -orchestrator_pass -priority Low -robots robotName -result_path C:\Temp
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -userKey a7da29a2c93a717110a82 -accountName myAccount -robots robotName -result_path C:\Temp\status.json
. 'C:\scripts\UiPathJobRun.ps1' "ProcessName" "https://uipath-orchestrator.myorg.com" default -accountForApp accountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -robots robotName -result_path C:\Temp\status.json
 

#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
More on different authentication options here [UiPathAuthenticationsOptions](UiPathAuthenticationsOptions.md)

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

-  `accountForApp` 
    The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

-  `applicationId` 
    The external application id. Must be used together with account, secret and scope(s) for external application.

-  `applicationSecret` 
    The external application secret. Must be used together with account, id and scope(s) for external application.

-  `applicationScope` 
    The space-separated list of application scopes. Must be used together with account, id and secret for external application.
    
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