dashboard "turbot_mods" {
  title = "Turbot Mods"
  container {
    title = "Installed Mods Summary"
    card {
      sql   = query.installed_mods_count.sql
      width = 2
    }
    #    chart {
    #      title = "Mod Auto Update"
    #      type = "donut"
    #      sql = query.mod_auto_update.sql
    #      width = 2
    #    }
  }
  container {
    card {
      sql   = query.installed_aws_mods_count.sql
      width = 4
    }
    card {
      sql   = query.installed_azure_mods_count.sql
      width = 4
    }
    card {
      sql   = query.installed_gcp_mods_count.sql
      width = 4
    }
  }
  container {
    title = "Installed Mods List"
    table {
      title = "AWS Mods List"
      query = query.installed_aws_mods_list
      width = 4
      column "id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "Mod Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/admin/mods/{{.'id' | @uri}}
        EOT
      }
    }
    table {
      title = "Azure Mods List"
      query = query.installed_azure_mods_list
      width = 4
      column "id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "Mod Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/admin/mods/{{.'id' | @uri}}
        EOT
      }
    }
    table {
      title = "GCP Mods List"
      query = query.installed_gcp_mods_list
      width = 4
      column "id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "Mod Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/admin/mods/{{.'id' | @uri}}
        EOT
      }
    }
  }
}

query "installed_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "Mods Count"
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
with mod_auto as (select count(*) as result, 'count' as count
                  from turbot_policy_setting
                  where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'),
     workspace_count as (select count(*) as result, 'count' as count
                         from turbot_resource
                         where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/turbot" level:self')
select ma.result, wc.result from mod_auto ma
join workspace_count wc using(count)
EOQ
}
