﻿dashboard "turbot_mods" {
  title = "Turbot Mods Dashboard"
  container {
    title = "Installed Mods Summary"
    card {
      sql   = query.installed_mods_count.sql
      width = 2
    }
    card {

      sql   = query.mod_auto_update.sql
      width = 2
    }
  }
  container {
    card {
      sql   = query.installed_aws_mods_count.sql
      width = 4
      href  = dashboard.mods_installed_aws.url_path
    }
    card {
      sql   = query.installed_azure_mods_count.sql
      width = 4
      href  = dashboard.mods_installed_azure.url_path
    }
    card {
      sql   = query.installed_gcp_mods_count.sql
      width = 4
      href  = dashboard.mods_installed_gcp.url_path
    }
  }

}

query "installed_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self';
EOQ
}

query "installed_aws_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "AWS Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'aws';
EOQ
}

query "installed_azure_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "Azure Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 5) like 'azure';
EOQ
}

query "installed_gcp_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "GCP Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'gcp';
EOQ
}

query "installed_aws_mods_list" {
  sql = <<EOQ
  select
    title as "Mod Name",
    id,
    substring(workspace from 'https://([a-z]+)(.)' ) as "Workspace",
    workspace as "Workspace URL"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'aws'
  order by title;
EOQ


}

query "installed_azure_mods_list" {
  sql = <<EOQ
  select
    title as "Mod Name",
    id,
    substring(workspace from 'https://([a-z]+)(.)' ) as "Workspace",
    workspace as "Workspace URL"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 5) like 'azure'
order by title;
EOQ
}

query "installed_gcp_mods_list" {
  column = none
  sql    = <<EOQ
  select
    title as "Mod Name",
    id,
    substring(workspace from 'https://([a-z]+)(.)' ) as "Workspace",
    workspace as "Workspace URL"
  from turbot_resource as "List of Installed GCP Mods"
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'gcp'
order by title;
EOQ
}

query "mod_auto_update" {
  sql = <<EOQ
select count(*) as "Workspaces with Auto Update Enabled"
  from turbot_policy_setting
  where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
EOQ
}