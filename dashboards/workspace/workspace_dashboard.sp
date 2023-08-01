dashboard "workspace_dashboard" {
  title         = "Guardrails Workspace Dashboard"
  documentation = file("./dashboards/workspace/docs/workspace_dashboard.md")
  tags = merge(local.workspace_common_tags, {
    type     = "Dashboard"
    category = "Summary"
  })

  # Analysis
  container {
    title = "Workspace Statistics"

    card {
      sql   = query.workspace_count.sql
      width = 2
      href  = dashboard.workspace_report.url_path
    }

    card {
      sql   = query.workspace_account_count.sql
      width = 2
      href  = dashboard.workspace_account_report.url_path
    }
  }

  # Analysis
  container {
    title = "Account Statistics"

    chart {
      title = "Accounts by Workspace"
      type  = "column"
      width = 6

      legend {
        display  = "auto"
        position = "top"
      }

      axes {
        x {
          title {
            value = "Guardrails Workspace"
          }
          labels {
            display = "auto"
          }
        }
        y {
          title {
            value = "Total Accounts"
          }
          labels {
            display = "auto"
          }
        }
      }

      sql = <<-EOQ
        select
          _ctx ->> 'connection_name' as "Connection Name",
          case
            when
              resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' 
            then
              'AWS' 
            when
              resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' 
            then
              'Azure' 
            when
              resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' 
            then
              'GCP' 
          end
          as "Account Type", count(resource_type_uri) 
        from
          guardrails_resource 
        where
          resource_type_uri in 
          (
            'tmod:@turbot/aws#/resource/types/account', 'tmod:@turbot/azure#/resource/types/subscription', 'tmod:@turbot/gcp#/resource/types/project' 
          )
        group by
          _ctx, resource_type_uri 
        order by
          count(resource_type_uri) desc;
      EOQ
    }

    chart {
      type  = "column"
      title = "Accounts by Platform"
      width = 6

      axes {
        x {
          title {
            value = "Cloud Platform"
          }
          labels {
            display = "auto"
          }
        }
        y {
          title {
            value = "Total Accounts"
          }
          labels {
            display = "auto"
          }
        }
      }

      sql = <<-EOQ
        select
          case
            when
              resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' 
            then
              'AWS' 
            when
              resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' 
            then
              'Azure' 
            when
              resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' 
            then
              'GCP' 
          end
          as "Account Type", count(resource_type_uri) 
        from
          guardrails_resource 
        where
          resource_type_uri in 
          (
            'tmod:@turbot/aws#/resource/types/account', 'tmod:@turbot/azure#/resource/types/subscription', 'tmod:@turbot/gcp#/resource/types/project' 
          )
        group by
          resource_type_uri;
      EOQ
    }

  }
}

query "workspace_count" {
  sql = <<-EOQ
    select
      count(workspace) as "Workspaces" 
    from
      guardrails_resource 
    where
      resource_type_uri = 'tmod:@turbot/turbot#/resource/types/turbot';
  EOQ
}

query "workspace_account_count" {
  sql = <<-EOQ
    select
      count(id) as "Accounts" 
    from
      guardrails_resource 
    where
      resource_type_uri in 
      (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project' 
      )
    ;
  EOQ
}
