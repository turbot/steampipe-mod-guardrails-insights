dashboard "turbot_workspace_report" {
  title = "Turbot Workspace Report"
  # documentation = ""
  # tags = 

  container {
    text {
      value = "The workspace report, gives you a detailed analysis of all the Turbot Workspace you are connected to along with the TE Version they are on."
      # width = "4"
    }

    card {
      sql   = query.turbot_workspace_count.sql
      width = 2
    }
  }

  container {
    table {
      width = 6
      sql   = query.turbot_workspace_version.sql
    }
  }

}

query "turbot_workspace_version" {
  sql = <<-EOQ
    select
      workspace as "Workspace URL",
      value as "Version",
      _ctx ->> 'connection_name' as "Connection",
      resource_id as "Turbot Id"
    from
      turbot_policy_setting
    where
      policy_type_uri = 'tmod:@turbot/turbot#/policy/types/workspaceVersion'
    order by 
      value;
  EOQ 
}
