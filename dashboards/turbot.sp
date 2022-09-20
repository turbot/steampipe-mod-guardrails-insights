dashboard "turbot_workspace_dashboard" {

  title = "*** Turbot Workspace Health Dashboard ***"
  # documentation = file("./dashboards/aws/docs/aws_account_report.md")

  #  tags = merge(local.aws_common_tags, {
  #    type     = "Report"
  #    category = "Accounts"
  #  })

  container {
    title = "Workspace Stats and Settings"

    # Analysis
    card {
      sql   = query.turbot_workspace_count.sql
      width = 2
      href  = dashboard.turbot_workspace_report.url_path
    }

    # Analysis
    card {
      sql   = query.turbot_account_count.sql
      width = 2
      href  = dashboard.turbot_account_report.url_path
    }

    # Analysis
    card {
      sql   = query.turbot_resource_count.sql
      width = 2
      href  = dashboard.turbot_resource_detail.url_path
    }


    # Assessments
    # card {
    #   sql   = query.turbot_event_handlers_secret_rotation.sql
    #   width = 2
    #   href  = dashboard.turbot_workspace_webhook_secret_rotation.url_path
    # }

    # Assessments
    # card {
    #   sql   = query.turbot_directories_unique.sql
    #   width = 2
    #   href  = dashboard.turbot_directories_detail.url_path
    # }
  }

  # container {
  #   title = "Real Time Events"

  #   # Assessments
  #   card {
  #     sql   = query.turbot_event_handlers_policy_enforced.sql
  #     width = 2
  #     href  = dashboard.turbot_event_handlers_detail.url_path
  #   }

  #   # Assessments
  #   card {
  #     sql   = query.turbot_event_pollers_policy_enabled.sql
  #     width = 2
  #     href  = dashboard.turbot_event_handlers_detail.url_path
  #   }

  #   # Assessments
  #   card {
  #     sql   = query.turbot_event_handlers_control_alert.sql
  #     width = 2
  #     # href  = dashboard.turbot_event_handlers_detail.url_path
  #   }

  #   # Assessments
  #   card {
  #     sql   = query.turbot_event_handlers_poller_alert.sql
  #     width = 2
  #     # href  = dashboard.turbot_event_handlers_detail.url_path
  #   }
  # }
}

##################################################################################################################################
##################################################################################################################################

query "turbot_workspace_count" {
  sql = <<-EOQ
    select
      count(workspace) as "Workspaces"
    from
      turbot_resource
    where
      resource_type_uri = 'tmod:@turbot/turbot#/resource/types/turbot';
  EOQ
}

query "turbot_account_count" {
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

query "turbot_resource_count" {
  sql = <<-EOQ
    select
      count(*) as "Resources"
    from
      turbot_resource
    where 
      filter = 'resourceTypeId:tmod:@turbot/aws#/resource/types/aws,tmod:@turbot/azure#/resource/types/azure,tmod:@turbot/gcp#/resource/types/gcp,tmod:@turbot/kubernetes#/resource/types/kubernetes,tmod:@turbot/turbot#/resource/types/folder,tmod:@turbot/turbot#/resource/types/file,tmod:@turbot/turbot#/resource/types/smartFolder'
  EOQ
}

# query "turbot_event_handlers_policy_enforced" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enforce: Configured' then 1 else 0 end) || '/' || count(value) as "Event Handlers Enforced"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:tmod:@turbot/aws#/policy/types/eventHandlers,tmod:@turbot/azure#/policy/types/eventHandlers,tmod:@turbot/gcp#/policy/types/eventHandlersPubSub level:self';
#   EOQ 
# }

# query "turbot_event_pollers_policy_enabled" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enabled' then 1 else 0 end) || '/' || count(value) as "Event Pollers Enabled"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:"tmod:@turbot/aws#/policy/types/eventPoller,tmod:@turbot/azure#/policy/types/eventPoller,tmod:@turbot/gcp#/policy/types/eventPoller" level:self';
#   EOQ 
# }

# query "turbot_event_handlers_control_alert" {
#   sql = <<-EOQ
#     select
#       sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end)   || '/' ||  count(*) as "Event Handler Control Alerts"
#     from
#       turbot_control as c
#     where
#       control_type_uri in ('tmod:@turbot/aws#/control/types/eventHandlers','tmod:@turbot/azure#/control/types/eventHandlers','tmod:@turbot/gcp#/control/types/pubSub')
#   EOQ 
# }

# query "turbot_event_handlers_poller_alert" {
#   sql = <<-EOQ
#     select
#       sum(case when state in ('alarm', 'error', 'invalid') then 1 else 0 end)   || '/' ||  count(*) as "Event Poller Control Alerts"
#     from
#       turbot_control as c
#     where
#       control_type_uri in ('tmod:@turbot/aws#/control/types/accountEventPoller','tmod:@turbot/azure#/control/types/eventPoller','tmod:@turbot/gcp#/control/types/projectEventPoller')
#   EOQ 
# }

# query "turbot_event_handlers_secret_rotation" {
#   sql = <<-EOQ
#     select
#       sum(case when value = 'Enforce: Rotate webhook secret' then 1 else 0 end) as value,
#       'Rotation Not Enforced' as label,
#       case when sum(case when value != 'Enforce: Rotate webhook secret' then 1 else 0 end) != 0 then 'ok' else 'alert'
#       end as "type"
#     from
#       turbot_policy_value
#     where
#       filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/webhookSecretRotation" level:self'
#     group by value,poliy_type_trunk_title;
#   EOQ 
# }

# query "turbot_directories_list" {
#   sql = <<-EOQ
#     select
#       count(*) as "Directories"
#     from
#       turbot_resource
#     where
#       resource_type_uri in (
#         'tmod:@turbot/turbot-iam#/resource/types/googleDirectory',
#         'tmod:@turbot/turbot-iam#/resource/types/localDirectory',
#         'tmod:@turbot/turbot-iam#/resource/types/samlDirectory',
#         'tmod:@turbot/turbot-iam#/resource/types/turbotDirectory'
#       );
#   EOQ
# }
