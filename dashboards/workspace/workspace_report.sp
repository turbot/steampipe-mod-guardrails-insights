dashboard "workspace_report" {

  title         = "Turbot Guardrails Workspace Report"
  documentation = file("./dashboards/workspace/docs/workspace_report.md")

  tags = merge(local.workspace_common_tags, {
    type     = "Report"
    category = "Summary"
  })

  # Analysis
  container {

    card {
      sql   = query.workspaces_count.sql
      width = 2
    }

    card {
      sql   = query.accounts_total.sql
      width = 2
    }

    card {
      sql   = query.resources_count.sql
      width = 2
    }

    card {
      sql   = query.policy_settings_total.sql
      width = 2
    }

    card {
      sql   = query.alerts_total.sql
      width = 2
    }

    card {
      sql   = query.active_controls_count.sql
      width = 2
    }

  }

  # Analysis - Workspace stats - Accounts, Resources, Controls, Alerts
  container {
    table {
      width = 12

      column "Accounts" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/accounts?filter=sort%3AtrunkTitle
        EOT
      }

      column "Resources" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/resources-by-resource-type
        EOT
      }

      column "Policy Settings" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/policies/all/settings
        EOT
      }

      column "Active Controls" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/controls-by-resource-type?filter=state%3Aactive+%21resourceTypeId%3A%27tmod%3A%40turbot%2Fturbot%23%2Fresource%2Ftypes%2Fturbot%27
        EOT
      }

      column "Alerts" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/alerts-by-control-type
        EOT
      }

      sql = query.workspace_stats.sql
    }
  }

}

query "accounts_total" {
  sql = <<-EOQ
  select
    sum((output -> 'accounts' -> 'metadata' -> 'stats' ->> 'total')::int) as "Accounts"
  from
    guardrails_query
  where
    query = '{
      accounts: resources(filter: "resourceTypeId:tmod:@turbot/turbot#/resource/interfaces/accountable level:self") {
        metadata {
          stats {
            total
          }
        }
      }
    }'
  EOQ
}

query "alerts_total" {
  sql = <<-EOQ
  select
    sum((output -> 'alerts' -> 'metadata' -> 'stats' ->> 'total')::int) as "Alerts - alarm, invalid, error"
  from
    guardrails_query
  where
    query = '{
      alerts: controls(filter:"state:alarm,invalid,error") {
        metadata {
          stats {
            total
          }
        }
      }
    }'
  EOQ
}

query "policy_settings_total" {
  sql = <<-EOQ
  select
    sum((output -> 'policySettings' -> 'metadata' -> 'stats' ->> 'total')::int) as "Policy Settings"
  from
    guardrails_query
  where
    query = '{
      policySettings: policySettings {
        metadata {
          stats {
            total
          }
        }
      }
    }'
  EOQ
}

query "workspace_stats" {
  sql = <<-EOQ
  select
    workspace as "Workspace",
    (output -> 'accounts' -> 'metadata' -> 'stats' ->> 'total')::int as "Accounts",
    (output -> 'resources' -> 'metadata' -> 'stats' ->> 'total')::int as "Resources",
    (output -> 'policySettings' -> 'metadata' -> 'stats' ->> 'total')::int as "Policy Settings",
    (output -> 'alerts' -> 'metadata' -> 'stats' ->> 'total')::int as "Alerts",
    (output -> 'active_controls' -> 'metadata' -> 'stats' ->> 'total')::int as "Active Controls"
  from
    guardrails_query
  where
    query = '{
      accounts: resources(filter: "resourceTypeId:tmod:@turbot/turbot#/resource/interfaces/accountable level:self") {
        metadata {
          stats {
            total
          }
        }
      }
      resources: resources(filter: "resourceTypeId:tmod:@turbot/aws#/resource/types/aws,tmod:@turbot/azure#/resource/types/azure,tmod:@turbot/gcp#/resource/types/gcp") {
        metadata {
          stats {
            total
          }
        }
      }
      policySettings: policySettings {
        metadata {
          stats {
            total
          }
        }
      }
      alerts: controls(filter:"state:alarm,invalid,error") {
        metadata {
          stats {
            total
          }
        }
      }
      active_controls: controls(
        filter: "state:active resourceTypeId:tmod:@turbot/aws#/resource/types/aws,tmod:@turbot/azure#/resource/types/azure,tmod:@turbot/gcp#/resource/types/gcp"
      ) {
        metadata {
          stats {
            total
          }
        }
      }
    }'
  order by "Workspace"
  EOQ
}
