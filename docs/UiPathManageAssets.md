
# UiPathManageAssets
Manage uipath orchestrator assets.
    - Delete assets from an Orchestrator instance (based on asset name).
    - Deploy assets to an Orchestrator instance.
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathManageAssets.ps1' <operation> <assets_file.csv> <orchestrator_url> <orchestrator_tenant> [-accountForApp <account_for_app> -applicationId <application_id> -applicationSecret <application_secret> -applicationScope <applicationScope>] [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

  Examples (Deploy Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://cloud.uipath.com" defaultTenant -accountForApp myAccountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -language en-US
  
  Examples (Delete Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://cloud.uipath.com" defaultTenant -accountForApp myAccountForExternalApp -applicationId myExternalAppId -applicationSecret myExternalAppSecret -applicationScope "OR.Folders.Read OR.Settings.Read" -language en-US


#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
More on different authentication options here [UiPathAuthenticationsOptions](UiPathAuthenticationsOptions.md)

Script Parameters
-  `$operation` 
     Manage assets operation either 'delete' or  'deploy'

-  `$assets_file` 
     The following is a sample csv file. The column names are required! Only the first column is used but you need to at least have empty columns in place.  
        <pre>name,type,value,description  
        asset_1_name,text,asset_value # we can have comments,asset_1_description
        asset_2_name,integer,123,asset_2_description
        asset_3_name,boolean,false,asset_3_description
        asset_4_name,credential,"username::password",asset_4_description
        </pre>

-  `orchestrator_url`
    Required. The URL of the Orchestrator instance.

-  `orchestrator_tenant`
    Required. The tenant of the Orchestrator instance.

-  `accountForApp` 
    The Orchestrator CloudRPA account name. Must be used together with id, secret and scope(s) for external application.

-  `applicationId` 
    The external application id. Must be used together with account, secret and scope(s) for external application.

-  `applicationSecret` 
    The external application secret. Must be used together with account, id and scope(s) for external application.

-  `applicationScope` 
    The space-separated list of application scopes. Must be used together with account, id and secret for external application.
    
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

-  `language`
    The orchestrator language.

-  `disableTelemetry`
    Disable telemetry data.
