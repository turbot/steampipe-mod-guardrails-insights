# dashboard "turbot_directories_detail" {

#   title = "Directory Details"
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
#       # sql   = query.turbot_directories_unique.sql
#       sql   = <<-EOQ
#         with blaaa as (
#         select
#         workspace,
#         count(distinct(resource_type_uri)) < 2 as least_dirs
#         from
#         turbot_resource
#         where
#         resource_type_uri in (
#         'tmod:@turbot/turbot-iam#/resource/types/googleDirectory',
#         'tmod:@turbot/turbot-iam#/resource/types/localDirectory',
#         'tmod:@turbot/turbot-iam#/resource/types/samlDirectory',
#         'tmod:@turbot/turbot-iam#/resource/types/turbotDirectory'
#         ) group by workspace
#         )
#         select
#         least_dirs as "Minimum Directories",
#         case
#           when sum(case when least_dirs then 1 else 0 end) < 2 then 'ok'
#         else 'alert'
#         end as "type"
#         from
#         turbot_resource , blaaa
#         where 
#         resource_type_uri = 'tmod:@turbot/turbot#/resource/types/turbot' and blaaa.workspace = turbot_resource.workspace group by least_dirs
#         EOQ
#       type  = "alert"
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

#     sql = query.turbot_directories_count.sql
#   }

# }


# query "turbot_directories_count" {
#   sql = <<-EOQ
#   select
#     *
#   from
#     turbot_resource
#   where
#     resource_type_uri in (
#       'tmod:@turbot/turbot-iam#/resource/types/googleDirectory',
#       'tmod:@turbot/turbot-iam#/resource/types/localDirectory',
#       'tmod:@turbot/turbot-iam#/resource/types/samlDirectory',
#       'tmod:@turbot/turbot-iam#/resource/types/turbotDirectory'
#     )
#   order by
#     workspace;
#   EOQ 
# }



# query "turbot_directories_unique" {
#   sql = <<-EOQ
#     with distinct_workspaces as (
#       select
#         workspace,
#         count(distinct(resource_type_uri)) > 1 as least_dirs
#       from
#         turbot_resource
#       where
#         resource_type_uri in (
#           'tmod:@turbot/turbot-iam#/resource/types/googleDirectory',
#           'tmod:@turbot/turbot-iam#/resource/types/localDirectory',
#           'tmod:@turbot/turbot-iam#/resource/types/samlDirectory',
#           'tmod:@turbot/turbot-iam#/resource/types/turbotDirectory'
#         )
#       group by
#         workspace
#     )
#     select
#       sum(
#         case
#           when distinct_workspaces.least_dirs then 0
#           else 1
#         end
#       ) as value,
#       '2 Distint Directories' as label,
#       case
#         when sum(
#           case
#             when distinct_workspaces.least_dirs then 1
#             else 0
#           end
#         ) > 1 then 'ok'
#         else 'alert'
#       end as "type"
#     from
#       distinct_workspaces;    
#   EOQ 
# }
