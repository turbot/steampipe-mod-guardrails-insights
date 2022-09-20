dashboard "turbot_account_report" {

  title = "Accounts Report"
  text {
    # value = "This is a fancy report for Accounts in the workspaces"
  }
  # documentation = 

  # tags 

  container {
    title = "Analysis"

    chart {
      title = "Accounts by Workspace"
      sql   = <<-EOQ
        select
        _ctx -> 'connection_name' as "Workspace",
        --resource_type_uri,
        case
          when resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' then 'AWS'
          when resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' then 'Azure'
          when resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' then 'GCP'
        end as "Account Type",
        count(id)
        from
        turbot_resource
        --turbot_resource
        where
        resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
        )
        group by
        _ctx,resource_type_uri
        order by count(id) desc
      EOQ
      type  = "column"
      width = 12
    }
  }

  container {

    text {
      value = "List of accounts across the workspaces. Click on the resource to nagivate to the respective Turbot Console."
    }

    card {
      sql   = query.turbot_account_count.sql
      width = 2
    }

    card {
      sql   = query.turbot_aws_count.sql
      width = 2
    }

    card {
      sql   = query.turbot_azure_count.sql
      width = 2
    }

    card {
      sql   = query.turbot_gcp_count.sql
      width = 2
    }

    table {

      column "id" {
        display = "none"
      }

      column "Account Id" {
        href = <<EOT
{{ ."Workspace" }}/apollo/resources/{{.'id' | @uri}}/reports
        EOT
      }
      sql = query.turbot_account_detail.sql

    }
  }
}


query "turbot_aws_count" {
  sql = <<-EOQ
    select
      count(*) as "AWS"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/aws#/resource/types/account'
  EOQ
}

query "turbot_azure_count" {
  sql = <<-EOQ
    select
      count(*) as "Azure"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription'
  EOQ
}

query "turbot_gcp_count" {
  sql = <<-EOQ
    select
      count(*) as "GCP"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project'
  EOQ
}

query "turbot_account_detail" {
  sql = <<-EOQ
    select
      id,
      case
        when resource_type_uri = 'tmod:@turbot/aws#/resource/types/account' then data ->> 'Id'
        when resource_type_uri = 'tmod:@turbot/azure#/resource/types/subscription' then data ->> 'subscriptionId'
        when resource_type_uri = 'tmod:@turbot/gcp#/resource/types/project' then data ->> 'projectId'
      end as "Account Id",
      title as "Title",
      trunk_title as "Trunk Title",
      workspace as "Workspace"
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
      )
    order by
      workspace,
      trunk_title;
  EOQ
}

