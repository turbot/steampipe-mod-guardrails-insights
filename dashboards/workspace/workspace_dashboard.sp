dashboard "workspace_dashboard" {

  title         = "Turbot Guardrails Workspace Dashboard"
  documentation = file("./dashboards/workspace/docs/workspace_dashboard.md")

  tags = merge(local.workspace_common_tags, {
    type     = "Dashboard"
    category = "Summary"
  })

  # Analysis
  container {
    title = "Workspace Statistics"

    card {
      sql   = query.workspaces_count.sql
      width = 3
      href  = dashboard.workspace_report.url_path
    }

    card {
      sql   = query.accounts_count.sql
      width = 3
      href  = dashboard.workspace_account_report.url_path
    }

    card {
      sql   = query.resources_count.sql
      width = 3
    }

    card {
      sql   = query.active_controls_count.sql
      width = 3
    }
  }

  # Analysis
  container {

    chart {
      type  = "donut"
      title = "Accounts by Workspace"
      width = 3
      sql   = query.accounts_by_workspace.sql
    }

    chart {
      type  = "donut"
      title = "Accounts by Provider"
      width = 3
      sql   = query.accounts_by_provider.sql
    }

    chart {
      type  = "donut"
      title = "Resources by Workspace"
      width = 3
      sql   = query.resources_by_workspace.sql
    }

    chart {
      type  = "donut"
      title = "Active Controls by Workspace"
      width = 3
      sql   = query.active_controls_by_workspace.sql
    }

  }
}

query "workspaces_count" {
  sql = <<-EOQ
    select
      count(workspace) as "Workspaces"
    from
      guardrails_resource
    where
      resource_type_uri = 'tmod:@turbot/turbot#/resource/types/turbot';
  EOQ
}

query "accounts_count" {
  sql = <<-EOQ
    select
      sum((output -> 'accounts' -> 'metadata' -> 'stats' ->> 'total')::int) as "Accounts"
    from
      guardrails_query
    where
      query = '{
      accounts: resources(
        filter: "resourceTypeId:tmod:@turbot/turbot#/resource/interfaces/accountable level:self"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }';
  EOQ
}

query "resources_count" {
  sql = <<-EOQ
    select
      sum((output -> 'resources' -> 'metadata' -> 'stats' ->> 'total')::int) as "Resources"
    from
      guardrails_query
    where
      query = '{
      resources: resources(
        filter: "resourceTypeId:tmod:@turbot/aws#/resource/types/aws,tmod:@turbot/azure#/resource/types/azure,tmod:@turbot/gcp#/resource/types/gcp,tmod:@turbot/servicenow#/resource/types/serviceNow,tmod:@turbot/turbot#/resource/types/folder,tmod:@turbot/turbot#/resource/types/file,tmod:@turbot/turbot#/resource/types/smartFolder"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }';
  EOQ
}

query "active_controls_count" {
  sql = <<-EOQ
    select
      sum((output -> 'active_controls' -> 'metadata' -> 'stats' ->> 'total')::int) as "Active Controls"
    from
      guardrails_query
    where
      query = '{
      active_controls: controls(
        filter: "state:active !resourceTypeId:tmod:@turbot/turbot#/resource/types/turbot"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }';
  EOQ
}

query "accounts_by_workspace" {
  sql = <<-EOQ
    select
      _ctx ->> 'connection_name' as "Connection Name",
      sum((output -> 'accounts' -> 'metadata' -> 'stats' ->> 'total')::int) as "Accounts"
    from
      guardrails_query
    where
      query = '{
      accounts: resources(
        filter: "resourceTypeId:tmod:@turbot/turbot#/resource/interfaces/accountable level:self"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }'
    group by
      _ctx ->> 'connection_name';
  EOQ
}

query "accounts_by_provider" {
  sql = <<-EOQ
    select
      case
        when resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' then 'AWS'
        when resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' then 'Azure'
        when resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' then 'GCP'
        when resource_type_uri = 'tmod:@turbot/servicenow#/resource/types/instance' then 'ServiceNow'
      end
      as "Account Type", count(resource_type_uri)
    from
      guardrails_resource
    where
      resource_type_uri in
      (
        'tmod:@turbot/aws#/resource/types/account', 'tmod:@turbot/azure#/resource/types/subscription', 'tmod:@turbot/gcp#/resource/types/project', 'tmod:@turbot/servicenow#/resource/types/instance'
      )
    group by
      resource_type_uri;
  EOQ
}

query "active_controls_by_workspace" {
  sql = <<-EOQ
    select
      _ctx ->> 'connection_name' as "Connection Name",
      sum((output -> 'total_controls' -> 'metadata' -> 'stats' ->> 'total')::int) as "Active Controls"
    from
      guardrails_query
    where
      query = '{
      total_controls: controls(
        filter: "state:active !resourceTypeId:tmod:@turbot/turbot#/resource/types/turbot"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }'
    group by
      _ctx ->> 'connection_name';
  EOQ
}

query "resources_by_workspace" {
  sql = <<-EOQ
    select
      _ctx ->> 'connection_name' as "Connection Name",
      sum((output -> 'accounts' -> 'metadata' -> 'stats' ->> 'total')::int) as "Resources"
    from
      guardrails_query
    where
      query = '{
      accounts: resources(
        filter: "resourceTypeId:tmod:@turbot/aws#/resource/types/aws,tmod:@turbot/azure#/resource/types/azure,tmod:@turbot/gcp#/resource/types/gcp,tmod:@turbot/servicenow#/resource/types/serviceNow,tmod:@turbot/turbot#/resource/types/folder,tmod:@turbot/turbot#/resource/types/file,tmod:@turbot/turbot#/resource/types/smartFolder"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }'
    group by
      _ctx ->> 'connection_name';
  EOQ
}
