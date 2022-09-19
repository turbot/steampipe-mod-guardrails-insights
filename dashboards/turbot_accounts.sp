dashboard "turbot_accountable_detail" {

  title = "Accounts Report"
  # documentation = 

  # tags 

  container {

    card {
      sql   = query.turbot_accountable_count.sql
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
      column "ARN" {
        display = "none"
      }

      sql = query.turbot_accountable_detail.sql
    }

    # table {
    #   column "ARN" {
    #     display = "none"
    #   }

    #   sql = query.turbot_aws_detail.sql
    # }

  }

}


query "turbot_aws_count" {
  sql = <<-EOQ
    select
      count(*) as "AWS"
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account'
      );
  EOQ
}

query "turbot_azure_count" {
  sql = <<-EOQ
    select
      count(*) as "Azure"
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/azure#/resource/types/subscription'
      );
  EOQ
}

query "turbot_gcp_count" {
  sql = <<-EOQ
    select
      count(*) as "GCP"
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/gcp#/resource/types/project'
      );
  EOQ
}

query "turbot_accountable_detail" {
  sql = <<-EOQ
    select
        id,
        title,
        create_timestamp,
        metadata
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account',
        'tmod:@turbot/azure#/resource/types/subscription',
        'tmod:@turbot/gcp#/resource/types/project'
      );
  EOQ
}

query "turbot_aws_detail" {
  sql = <<-EOQ
    select
      *
    from
      turbot_resource
    where
      resource_type_uri in (
        'tmod:@turbot/aws#/resource/types/account'
      );
  EOQ
}
