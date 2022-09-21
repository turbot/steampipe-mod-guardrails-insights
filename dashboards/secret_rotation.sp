# dashboard "turbot_workspace_webhook_secret_rotation" {

#   title = "Webhook Secret Rotation"
#   #   documentation = file("./dashboards/s3/docs/s3_bucket_report_lifecycle.md")

#   #   tags = merge(local.s3_common_tags, {
#   # type     = "Report"
#   # category = "Lifecycle"
#   #   })

#   container {

#     card {
#       sql   = query.turbot_workspace_count.sql
#       width = 2
#     }

#     card {
#       sql   = query.turbot_event_handlers_secret_rotation.sql
#       width = 2
#     }

#   }

#   table {
#     # column "Account ID" {
#     #   display = "none"
#     # }

#     # column "ARN" {
#     #   display = "none"
#     # }

#     # column "Name" {
#     #   href = "${dashboard.aws_s3_bucket_detail.url_path}?input.bucket_arn={{.ARN | @uri}}"
#     # }

#     sql = query.turbot_event_handlers_secret_rotation_detail.sql
#   }

# }

# # query "turbot_workspace_count" {
# #   sql = <<-EOQ
# #     select
# #       count(distinct(workspace)) as "Workspaces"
# #     from
# #       turbot_policy_setting;
# #   EOQ
# # }

# query "turbot_event_handlers_secret_rotation_detail" {
#   sql = <<-EOQ
#     select
#     policy_type_title as "Policy Title",
#     state as "State",
#     value as "Value",
#     workspace as "Workspace",
#     _ctx ->> 'connection_name' as "Connection"
#     from
#     turbot_policy_value
#     where
#     filter = 'policyTypeId:tmod:@turbot/turbot#/policy/types/webhookSecretRotation level:self'
#   EOQ 
# }

# # query "aws_s3_bucket_versioning_mfa_disabled_count" {
# #   sql = <<-EOQ
# #     select
# #       count(*) as value,
# #       'Versioning MFA Disabled' as label,
# #       case count(*) when 0 then 'ok' else 'alert' end as "type"
# #     from
# #       aws_s3_bucket
# #     where
# #       not versioning_mfa_delete;
# #   EOQ
# # }

# # query "aws_s3_bucket_lifecycle_table" {
# #   sql = <<-EOQ
# #     select
# #       b.name as "Name",
# #       case when b.versioning_enabled then 'Enabled' else null end as "Versioning",
# #       case when b.versioning_mfa_delete then 'Enabled' else null end as "Versioning MFA Delete",
# #       a.title as "Account",
# #       b.account_id as "Account ID",
# #       b.region as "Region",
# #       b.arn as "ARN"
# #     from
# #       aws_s3_bucket as b,
# #       aws_account as a
# #     where
# #       b.account_id = a.account_id
# #     order by
# #       b.name;
# #   EOQ
# # }
