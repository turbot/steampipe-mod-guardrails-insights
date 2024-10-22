dashboard "workspace_account_report" {

  title         = "Turbot Guardrails Workspace Account Report"
  documentation = file("./dashboards/workspace/docs/workspace_account_report.md")

  tags = merge(local.workspace_common_tags, {
    type     = "Report"
    category = "Summary"
  })

  # Analysis
  container {

    card {
      sql   = query.accounts_count.sql
      width = 3
    }

    card {
      sql   = query.workspaces_count.sql
      width = 3
      href  = dashboard.workspace_report.url_path
    }

    table {
      column "id" {
        display = "none"
      }

      column "External ID" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/resources/{{.'id' | @uri}}/detail
        EOT
      }

      column "Resources" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/resources/{{.'id' | @uri}}/reports
        EOT
      }

      column "Policy Settings" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/policy-settings-by-resource?filter=resourceId%3A%27{{.'id' | @uri}}%27
        EOT
      }

      column "Alerts" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/alerts-by-control-type?filter=resourceId%3A%27{{.'id' | @uri}}%27
        EOT
      }

      column "Active Controls" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/controls-by-resource?filter=resourceId%3A%27{{.'id' | @uri}}%27+state%3Aactive
        EOT
      }

      column "Total Controls" {
        href = <<-EOT
          {{ .'Workspace' }}/apollo/reports/controls-by-resource?filter=resourceId%3A%27{{.'id' | @uri}}%27
        EOT
      }

      sql = query.workspace_account_detail.sql
    }

  }
}

query "workspace_account_detail" {
  sql = <<-EOQ
    select
      accountables -> 'turbot' ->> 'id' as "id",
      case
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/aws#/resource/types/account' then accountables -> 'data' ->> 'Id'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/azure#/resource/types/subscription' then accountables -> 'data' ->> 'subscriptionId'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/gcp#/resource/types/project' then accountables -> 'data' ->> 'projectId'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/servicenow#/resource/types/instance' then accountables -> 'data' ->> 'instance_id'
      end
      as "External ID",
      case
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/aws#/resource/types/account' then accountables -> 'data' ->> 'AccountAlias'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/azure#/resource/types/subscription' then accountables -> 'data' ->> 'displayName'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/gcp#/resource/types/project' then accountables -> 'data' ->> 'name'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/servicenow#/resource/types/instance' then accountables -> 'data' ->> 'instance_id'
      end
      as "Name",
      case
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/aws#/resource/types/account' then 'AWS'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/azure#/resource/types/subscription' then 'Azure'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/gcp#/resource/types/project' then 'GCP'
        when accountables -> 'type' ->> 'uri' = 'tmod:@turbot/servicenow#/resource/types/instance' then 'ServiceNow'
      end
      as "Provider", workspace as "Workspace",
      (accountables -> 'descendants' -> 'metadata' -> 'stats' -> 'total')::int as "Resources",
      (accountables -> 'policySettings' -> 'metadata' -> 'stats' ->> 'total')::int as "Policy Settings",
      (accountables -> 'alerts' -> 'metadata' -> 'stats' ->> 'total')::int as "Alerts",
      (accountables -> 'activeControls' -> 'metadata' -> 'stats' ->> 'total')::int as "Active Controls"
    from
      guardrails_query, jsonb_array_elements(output -> 'resources' -> 'items') as accountables
    where
      query = '{
      resources(
        filter: "resourceTypeId:tmod:@turbot/turbot#/resource/interfaces/accountable level:self limit:5000"
      ) {
        metadata {
          stats {
            total
          }
        }
        items {
          data
          turbot {
            id
          }
          type {
            uri
          }
          descendants {
            metadata {
              stats {
                total
              }
            }
          }
          policySettings {
            metadata {
              stats {
                total
              }
            }
          }
          alerts: controls(filter: "state:alarm,invalid,error") {
            metadata {
              stats {
                total
              }
            }
          }
          activeControls: controls(filter: "state:active") {
            metadata {
              stats {
                total
              }
            }
          }
        }
      }
    }'
    order by
      "Workspace", "Resources" desc;
  EOQ
}
