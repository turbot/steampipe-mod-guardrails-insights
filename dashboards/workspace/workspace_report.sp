dashboard "workspace_report" {
  title         = "Workspace Report"
  documentation = file("./dashboards/workspace/docs/workspace_report.md")
  tags = merge(local.workspace_common_tags, {
    type = "Report"
    # category = "Age"
  })

  # Analysis
  container {
    text {
      value = "The workspace report, gives you a detailed analysis of all the Turbot Workspace you are connected to along with the TE Version they are on."
      # width = "4"
    }

    card {
      sql   = query.workspace_count.sql
      width = 2
    }
  }

  # Analysis
  container {
    table {
      width = 12
      sql   = query.workspace_version.sql
    }
  }

}

query "workspace_version" {
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
