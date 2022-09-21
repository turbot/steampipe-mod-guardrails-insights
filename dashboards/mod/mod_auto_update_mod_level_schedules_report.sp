dashboard "mod_auto_update_mod_level_schedules_report" {
  title = "Mod Level Auto Update Schedules Report"
  tags  = merge(local.mod_common_tags, {
    type     = "Report"
    category = "Auto Update"
  })
  container {
    table {
      title = "Mod Auto Update Schedules by Workspace"
      query = query.mod_auto_update_schedule_list
      column "policy_id" {
        display = "none"
      }
      column "Update Schedule" {
        href = <<EOT
{{ ."Workspace" }}/apollo/policies/settings/{{.'policy_id' | @uri}}
        EOT
      }
    }
  }
}

query "mod_auto_update_schedule" {
  title = ""
  sql   = <<EOQ
select count(*)
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modChangeWindowSchedule" level:self'
and resource_trunk_title not like 'Turbot';
EOQ
}

query "mod_auto_update_schedule_list" {
  title = "Mod Auto Update Schedules"
  sql   = <<EOQ
select 'Update Schedule' as "Update Schedule", id as policy_id, value_source::json #>> '{0,description}' as "Schedule", workspace as "Workspace"
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modChangeWindowSchedule" level:self';
EOQ
}