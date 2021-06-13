
# UiPathManageAssets
Manage uipath orchestrator assets.
    - Delete assets from an Orchestrator instance (based on asset name).
    - Deploy assets to an Orchestrator instance.
```PowerShell
SYNTAX
    . 'C:\scripts\UiPathManageAssets.ps1' <operation> <assets_file.csv> <orchestrator_url> <orchestrator_tenant> [-orchestrator_user <orchestrator_user> -orchestrator_pass <orchestrator_pass>] [-UserKey <auth_token> -account_name <account_name>] [-folder_organization_unit <folder_organization_unit>] [-language <language>]

  Examples (Deploy Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' deploy assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US
  
  Examples (Delete Assets):
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://uipath-orchestrator.myorg.com" defaultTenant -orchestrator_user admin -orchestrator_pass 123456 -folder_organization_unit OurOrganization
    . 'C:\scripts\UiPathManageAssets.ps1' delete assets_file.csv "https://cloud.uipath.com" defaultTenant -UserKey a7da29a2c93a717110a82 -account_name myAccount -language en-US

#Note: if script folder location is different you need to replace C: with directory folder (e.g. '[FOLDER_VARIABLE]\scripts\UiPathPack.ps1')
```
Script Parameters
-  `$operation` 
     Manage assets operation either 'delete' or  'deploy'

-  `$assets_file` 
     The following is a sample csv file. The column names are required! Only the first column is used but you need to at least have empty columns in place.  
        <pre>name,type,value  
        asset_1_name,boolean,false # we can have comments  
        asset_2_name,integer,  
        asset_3_name,text,  
        asset_4_name,credential,username::password  
        </pre>

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

-  `language`
    The orchestrator language.

-  `disableTelemetry`
    Disable telemetry data.
