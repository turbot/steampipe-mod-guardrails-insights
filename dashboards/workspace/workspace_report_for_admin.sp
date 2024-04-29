dashboard "workspace_report_admin" {

  title         = "Turbot Guardrails Workspace Report for Admin"
  documentation = file("./dashboards/workspace/docs/workspace_report_for_admin.md")

  tags = merge(local.workspace_common_tags, {
    type     = "Report"
    category = "Summary"
  })

  # Analysis
  container {
    card {
      sql   = query.workspaces_count.sql
      width = 2
      href  = dashboard.workspace_report.url_path
    }

    card {
      sql   = query.accounts_total.sql
      width = 2
      href  = dashboard.workspace_account_report.url_path
    }

    card {
      sql   = query.resources_count.sql
      width = 2
    }
  }

  container {
    title = "Stacks Summary"
    table {
      width = 8
      sql   = query.stacks_aggregate.sql
    }
  }

  container {
    title = "Policy Values Summary"
    table {
      width = 8
      sql   = query.policies_summary.sql
    }
  }

  container {
    title = "Controls Summary"
    table {
      width = 8
      sql   = query.controls_summary.sql
    }
  }

}

query "stacks_aggregate" {
  sql = <<-EOQ
    select
      case 
      when control_type_uri = 'tmod:@turbot/aws#/control/types/accountStack' then 'AWS > Account > Stack'
      when control_type_uri = 'tmod:@turbot/aws-iam#/control/types/iamStack' then 'AWS > IAM > Stack'
      when control_type_uri = 'tmod:@turbot/aws#/control/types/regionStack' then 'AWS > Region > Stack'
      when control_type_uri = 'tmod:@turbot/aws-vpc-core#/control/types/vpcStack' then 'AWS > VPC > VPC > Stack'
      end as "Stack",
      count(*) as "Total",
      sum(
        case
          when state in ('error') then 1
          else 0
        end
      ) as "Error",
      sum(
        case
          when state in ('invalid') then 1
          else 0
        end
      ) as "Invalid",
      sum(
        case
          when state in ('tbd') then 1
          else 0
        end
      ) as "TBD"

    from
    guardrails_control as c
    where
      control_type_uri IN (
        'tmod:@turbot/aws#/control/types/accountStack',
        'tmod:@turbot/aws-iam#/control/types/iamStack',
        'tmod:@turbot/aws#/control/types/regionStack',
        'tmod:@turbot/aws-vpc-core#/control/types/vpcStack'
      )
    group by
    "Stack";
  EOQ
}

query "policies_summary" {
  sql = <<-EOQ
    select
      'Count' as "Policy Values",
      sum((output ->  'total' -> 'metadata' -> 'stats' -> 'total')::int) as "Total",
      sum((output ->  'error' -> 'metadata' -> 'stats' -> 'total')::int) as "Error",
      sum((output ->  'invalid' -> 'metadata' -> 'stats' -> 'total')::int) as "Invalid",
      sum((output ->  'tbd' -> 'metadata' -> 'stats' -> 'total')::int) as "TBD"
    from
      guardrails_query
    where
      query = '{
      total: policyValues {
        metadata {
          stats {
            total
          }
        }
      }
      error: policyValues(filter: "state:error") {
        metadata {
          stats {
            total
          }
        }
      }
      invalid: policyValues(filter: "state:invalid") {
        metadata {
          stats {
            total
          }
        }
      }
      tbd: policyValues(filter: "state:tbd timestamp:<=T-1h") {
        metadata {
          stats {
            total
          }
        }
      }
    }';
  EOQ
}

query "controls_summary" {
  sql = <<-EOQ
  select    
    'Count' as "Controls",
    sum((controls -> 'summary' -> 'control' ->> 'total')::int) as "Total",
    sum((controls -> 'summary' -> 'control' ->> 'error')::int) as "Error",
    sum((controls -> 'summary' -> 'control' ->> 'invalid')::int) as "Invalid",
    sum((controls -> 'summary' -> 'control' ->> 'tbd')::int) as "TBD"
  from
    guardrails_query,
    jsonb_array_elements(output -> 'controlSummariesByResource' -> 'items') as controls
  where
    query = '{
    controlSummariesByResource {
      items {
        summary {
          control {
            total
            error
            invalid
            tbd
          }
        }
      }
    }
    }'
  EOQ
}
