benchmark "workspace_activity" {
  title = "Turbot Guardrails Workspace Activity"
  documentation = file("./dashboards/workspace/docs/workspace_activity.md")
  tags = merge(local.workspace_common_tags, {
    type     = "Benchmark"
    category = "Health"
  })

  description = "Turbot Guardrails Workspace Activity"
  children = [
    control.guardrails_workspace_user_activity,
    control.guardrails_workspace_mod_auto_update,
    control.guardrails_workspace_retention,
    control.guardrails_workspace_activity_retention,
  ]
}

control "guardrails_workspace_user_activity" {
  title       = "Turbot > User Login History"
  description = "Check User Login activity in customer workspaces"
  query       = query.guardrails_workspace_user_activity
}

control "guardrails_workspace_mod_auto_update" {
  title       = "Turbot > Workspace > Auto Update"
  description = "Check the policy values for guardrails mod auto updates"
  query       = query.guardrails_mod_auto_update
}

control "guardrails_workspace_retention" {
  title       = "Turbot > Workspace > Retention"
  description = "Check the policy values for guardrails workspace retention"
  query       = query.guardrails_retention
}

control "guardrails_workspace_activity_retention" {
  title       = "Turbot > Workspace > Retention > Activity Retention"
  description = "Check the policy values for guardrails workspace activity retention"
  query       = query.guardrails_activity_retention
}

query "guardrails_workspace_user_activity" {
  sql = <<-EOQ
    select
        g.workspace,
        g.workspace as resource,
        case
            when count(
                case
                    when (n.notifications ->> 'email') not like '%@turbot.com'
                    then 1
                    else null
                end
            ) = 0 then 'alarm'
            else 'ok'
        end as status,
        case
            when count(
                case
                    when (n.notifications ->> 'email') not like '%@turbot.com'
                    then 1
                    else null
                end
            ) = 0 then 'Workspace is Inactive. No User Login for 30 Days.'
            else 'Workspace is Active.'
        end as reason
    from
        guardrails_query g
    left join lateral
        jsonb_array_elements(g.output -> 'notifications' -> 'items') as n(notifications) ON TRUE
    where
        g.query = '{
          notifications: resources(
            filter: "resourceTypeId:tmod:@turbot/turbot-iam#/resource/types/profile,tmod:@turbot/turbot-iam#/resource/types/groupProfile,tmod:@turbot/aws-iam#/resource/types/instanceProfile $.lastLoginTimestamp:>=T-30d"
          ) {
            items {
              email: get(path:"email")
              lastLoginTimestamp: get(path: "lastLoginTimestamp")
              trunk {
                title
              }
              turbot {
                akas
              }
            }
          }
        }'
    group by
        g.workspace;
  EOQ
}

query "guardrails_mod_auto_update" {
  sql = <<-EOQ
    select
      resource_trunk_title,
      workspace,
      workspace as resource,
      case
        when value = 'Enforce within Mod Change Window' then 'ok'
        else 'alarm'
      end as status,
      case
        when value = 'Enforce within Mod Change Window' then 'Policy recommendation met'
        else 'Policy recommendation not met'
      end as reason
    from
      guardrails_policy_setting
    where
      policy_type_uri = 'tmod:@turbot/turbot#/policy/types/modAutoUpdate'
    order by
      workspace;
  EOQ
}

query "guardrails_retention" {
  sql = <<-EOQ
    select
      workspace,
      id as resource,
      case
        when value = 'Enforce: Enable purging via Smart Retention' then 'ok'
        else 'alarm'
      end as status,
      case
        when value = 'Enforce: Enable purging via Smart Retention' then 'Policy recommendation met'
        else 'Policy recommendation not met'
      end as reason
    from
      guardrails_policy_setting
    where
      policy_type_uri = 'tmod:@turbot/turbot#/policy/types/retention'
    order by
      workspace;
  EOQ
}

query "guardrails_activity_retention" {
  sql = <<-EOQ
    select
      ws.workspace,
      ps.id as resource,
      case
        when ps.value is null or ps.value = '' then 'alarm'
        when ps.value = 'None' then 'alarm'
        else 'ok'
      end as status,
      case
        when ps.value is null or ps.value = '' then 'Policy recommendation not met'
        when ps.value = 'None' then 'Policy recommendation not met'
        else 'ok'
      end as reason
    from
      (select distinct workspace from guardrails_policy_setting) ws
    left join
      guardrails_policy_setting ps
    on
      ws.workspace = ps.workspace
      and ps.policy_type_uri = 'tmod:@turbot/turbot#/policy/types/activityRetention'
    order by
      ws.workspace;
  EOQ
}
