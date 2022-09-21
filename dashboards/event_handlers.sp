
# dashboard "turbot_event_handlers_detail" {

#   title = "Real-Time Events - Policy Values"
#   # documentation
#   # tags

#   container {

#     card {
#       sql   = query.aws_event_handler_count.sql
#       width = 2
#     }

#     card {
#       sql   = query.aws_event_poller_count.sql
#       width = 2
#     }


#     card {
#       sql   = query.azure_event_handler_count.sql
#       width = 2
#     }

#     card {
#       sql   = query.azure_event_poller_count.sql
#       width = 2
#     }

#     card {
#       sql   = query.gcp_event_handler_count.sql
#       width = 2
#     }

#     card {
#       sql   = query.gcp_event_poller_count.sql
#       width = 2
#     }

#   }
# }

# query "aws_event_handler_count" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enforce: Configured' then 1 else 0 end) || '/' || count(value) as "AWS Event Handlers"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/aws#/policy/types/eventHandlers level:self';
#   EOQ 
# }

# query "aws_event_poller_count" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enabled' then 1 else 0 end) || '/' || count(value) as "AWS Event Poller"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/aws#/policy/types/eventPoller level:self';
#   EOQ 
# }


# query "azure_event_handler_count" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enforce: Configured' then 1 else 0 end) || '/' || count(value) as "Azure Event Handlers"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/azure#/policy/types/eventHandlers level:self';
#   EOQ 
# }

# query "azure_event_poller_count" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enabled' then 1 else 0 end) || '/' || count(value) as "Azure Event Poller"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/azure#/policy/types/eventPoller level:self';
#   EOQ 
# }

# query "gcp_event_handler_count" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enforce: Configured' then 1 else 0 end) || '/' || count(value) as "GCP Event Handlers"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/gcp#/policy/types/eventHandlersPubSub level:self';
#   EOQ 
# }

# query "gcp_event_poller_count" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enabled' then 1 else 0 end) || '/' || count(value) as "GCP Event Poller"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/gcp#/policy/types/eventPoller level:self';
#   EOQ 
# }
