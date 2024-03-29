dashboard "workspace_report" {

  title         = "Turbot Guardrails Workspace Report"
  documentation = file("./dashboards/workspace/docs/workspace_report.md")
  
  tags = merge(local.workspace_common_tags, {
    type     = "Report"
    category = "Summary"
  })

  # Analysis
  container {
    text {
      value = "The workspace report gives a detailed analysis of all connected Turbot Guardrails Workspace(s) along with their Turbot Guardrails Enterprise(TE) Version."
    }

    card {
      sql   = query.workspace_count.sql
      width = 3
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
      value as "TE Version",
      _ctx ->> 'connection_name' as "Connection Name",
      resource_id as "Resource ID"
    from
      guardrails_policy_setting
    where
      policy_type_uri = 'tmod:@turbot/turbot#/policy/types/workspaceVersion'
    order by
      value;
  EOQ
}
