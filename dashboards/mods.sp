dashboard "turbot_mods" {
  title = "Turbot Mods"
  container {
    title = "Installed Mods Summary"
    card {
      sql   = query.installed_mods_count.sql
      width = 12
    }
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
    }
    table {
      title = "Azure Mods List"
      query = query.installed_azure_mods_list
      width = 4
    }
    table {
      title = "GCP Mods List"
      query = query.installed_gcp_mods_list
      width = 4
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
  sql   = <<EOQ
  select title as "Mod Name",
workspace as "Workspace"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'aws'
order by title;
EOQ
}

query "installed_azure_mods_list" {
  sql   = <<EOQ
  select title as "Mod Name",
workspace as "Workspace"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 5) like 'azure'
order by title;
EOQ
}

query "installed_gcp_mods_list" {
  column = none
  sql   = <<EOQ
  select title as "Mod Name",
workspace as "Workspace"
  from turbot_resource as "List of Installed GCP Mods"
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'gcp'
order by title;
EOQ
}