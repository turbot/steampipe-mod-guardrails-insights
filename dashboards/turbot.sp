dashboard "turbot_workspace_report" {

  title = "Turbot Workspace Report"
  # documentation = file("./dashboards/aws/docs/aws_account_report.md")

  #  tags = merge(local.aws_common_tags, {
  #    type     = "Report"
  #    category = "Accounts"
  #  })

  container {

    # Analysis
    # card {
    #   sql   = query.turbot_accountable_count.sql
    #   width = 2
    # }

    # Assessments
    card {
      sql   = query.turbot_accountable_count.sql
      width = 2
      href  = dashboard.turbot_accountable_detail.url_path
    }

    # Assessments
    card {
      sql   = query.turbot_resources_count.sql
      width = 2
      # href  = dashboard.turbot_accountable_detail.url_path
    }

  }

  # table {
  #   column "ARN" {
  #     display = "none"
  #   }

  #   sql = query.aws_account_table.sql
  # }

}

# query "aws_account_count" {
#   sql = <<-EOQ
#     select
#       count(*) as "Accounts"
#     from
#       aws_account;
#   EOQ
# }

query "turbot_accountable_count" {
  sql = <<-EOQ
    select
      count(*) as "Accounts"
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

query "turbot_resources_count" {
  sql = <<-EOQ
    select
      count(*) as "Resources"
    from
      turbot_resource;
  EOQ
}
