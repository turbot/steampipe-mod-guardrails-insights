dashboard "turbot_mods" {
  title = "Turbot Mods"
  container {
    card {
      sql   = query.installed_mods_count.sql
      width = 2
    }
    card {
      sql   = query.installed_aws_mods_count.sql
      width = 2
    }
    card {
      sql   = query.installed_azure_mods_count.sql
      width = 2
    }
    card {
      sql   = query.installed_gcp_mods_count.sql
      width = 2
    }
  }
}

query "installed_mods_count" {
  title = "Count of Installed Mods"
  sql   = <<EOQ
  select count(*) as "Mods Count"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod"';
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
  select count(*) as "Azure Installed Mods"
  from turbot_resource
  where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self'
  and substring(title from 9 for 3) like 'gcp';
EOQ
}