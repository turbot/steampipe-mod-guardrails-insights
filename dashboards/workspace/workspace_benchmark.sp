benchmark "guardrails_workspace" {
  title = "Turbot Guardrails Workspace Health"
  tags = merge(local.workspace_common_tags, {
    type     = "Benchmark"
    category = "Health"
  })

  description   = "Run Turbot Guardrails Workspace Health benchmarks across all your Guardrails workspaces. It covers control checks for Cache, Mods, Database and Workspace health."
  documentation = file("./dashboards/workspace/docs/workspace_benchmark.md")
  children = [
    control.cache_health_check,
    control.mod_health,
    control.mod_process_monitor,
    control.smart_process_retention,
    control.smart_retention,
    control.workspace_health_control,
  ]
}

control "cache_health_check" {
  title       = "Turbot > Cache > Health Check"
  description = "Check Cache health status."
  query       = query.cache_health_check
}

control "mod_health" {
  title       = "Turbot > Mod > Health"
  description = "Workspaces Mod health summary."
  query       = query.mod_health_benchmark
}

control "mod_process_monitor" {
  title       = "Turbot > Mod > Process Monitor"
  description = "Workspaces Mod Process Monitor summary."
  query       = query.mod_process_monitor_benchmark
}

control "smart_process_retention" {
  title       = "Turbot > Smart Process Retention"
  description = "Smart Process Retention health summary."
  query       = query.smart_process_retention
}

control "smart_retention" {
  title       = "Turbot > Smart Retention"
  description = "Smart Retention health summary."
  query       = query.smart_retention
}

control "workspace_health_control" {
  title       = "Turbot > Workspace > Health Control"
  description = "DB Queries health summary."
  query       = query.workspace_health_control
}

query "cache_health_check" {
  sql = <<-EOQ
    select
      id as resource,
      case 
        when state = 'ok' then 'ok'
        when state in ('error', 'tbd', 'invalid') then 'error'
        when state = 'alarm' then 'alarm'
        when state = 'skipped' then 'skipped'
        else 'alarm'
      end as status,
      case
        when state = 'ok' then split_part(workspace, '//', 2) || ' is healthy.'
        else split_part(workspace, '//', 2) || ' ' || reason || '.'
        end as reason
        ${local.common_dimensions_sql}
    from
      guardrails_control
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/cacheHealthCheck'
    order by workspace
  EOQ
}

query "mod_health_benchmark" {
  sql = <<-EOQ
    select
      split_part(resource_trunk_title, '>', 2) as resource,
      case 
        when state in ('tbd', 'invalid') then 'info'
        else state
      end as status,
      case
        when state = 'ok' then split_part(resource_trunk_title, '>', 2) || ' is healthy.'
        else split_part(resource_trunk_title, '>', 2) || ' ' || reason || '.'
        end as reason
        ${local.common_dimensions_sql}
    from
      guardrails_control
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/modHealth'
    group by workspace,id,state,resource_trunk_title,reason
    order by workspace
  EOQ
}

query "mod_process_monitor_benchmark" {
  sql = <<-EOQ
    select
      workspace as resource,
      case 
        when state in ('tbd', 'invalid') then 'info'
        else state
      end as status,
      case
        when state = 'ok' then split_part(workspace, '//', 2) || ' is healthy.'
        else split_part(workspace, '//', 2) || ' ' || reason || '.'
        end as reason
        ${local.common_dimensions_sql}
    from
      guardrails_control
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/processMonitor'
    group by workspace,id,state,resource_trunk_title,reason
    order by workspace
  EOQ
}

query "smart_process_retention" {
  sql = <<-EOQ
    select
      id as resource,
      case 
        when state = 'ok' then 'ok'
        when state in ('error', 'tbd', 'invalid') then 'error'
        when state = 'alarm' then 'alarm'
        when state = 'skipped' then 'skipped'
        else 'alarm'
      end as status,
      case
        when state = 'ok' then split_part(workspace, '//', 2) || ' is healthy.'
        else split_part(workspace, '//', 2) || ' ' || reason || '.'
        end as reason
        ${local.common_dimensions_sql}
    from
      guardrails_control
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/smartProcessRetention'
    order by workspace
  EOQ
}

query "smart_retention" {
  sql = <<-EOQ
    select
      id as resource,
      case 
        when state = 'ok' then 'ok'
        when state in ('error', 'tbd', 'invalid') then 'error'
        when state = 'alarm' then 'alarm'
        when state = 'skipped' then 'skipped'
        else 'alarm'
      end as status,
      case
        when state = 'ok' then split_part(workspace, '//', 2) || ' is healthy.'
        else split_part(workspace, '//', 2) || ' ' || reason || '.'
        end as reason
      ${local.common_dimensions_sql}
    from
      guardrails_control
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/smartRetention'
    order by workspace
  EOQ
}

query "workspace_health_control" {
  sql = <<-EOQ
    select
      id as resource,
      case 
        when state in ('tbd', 'invalid') then 'info'
        else state
      end as status,
      case
        when state = 'ok' then split_part(workspace, '//', 2) || ' is healthy.'
        else split_part(workspace, '//', 2) || ' ' || reason || '.'
        end as reason
        ${local.common_dimensions_sql}
    from
      guardrails_control
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/workspaceHealthControl'
    order by workspace
  EOQ
}
