dashboard "mod_installed_mods_report" {
  title = "Mods Installed"
  tags  = merge(local.mod_common_tags, {
    type     = "Report"
    category = "Installed"
  })
  container {
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