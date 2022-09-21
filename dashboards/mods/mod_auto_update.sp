dashboard "mod_auto_update" {
  title = "Mod Auto Update Report"

  container {
    card {
      title = "Turbot level Mod Auto Update"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_turbot_level.sql
    }
    card {
      title = "Mod level Update Settings"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_mod_level.sql
    }
    card {
      title = "Mod Update Schedules Set"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_schedule.sql
    }
  }
  container {
    table {
      title = "Turbot Level Auto Update Settings"
      query = query.mod_auto_update_turbot_level_list
      column "policy_id" {
        display = "none"
      }
      column "Mod Auto Update" {
        href = <<EOT
{{ ."Workspace" }}/apollo/policies/settings/{{.'policy_id' | @uri}}
        EOT
      }
    }
    table {
      title = "Mods level Auto Update Settings"
      query = query.mod_auto_update_mod_level_list
      column "policy_id" {
        display = "none"
      }
      column "Mod Auto Update" {
        href = <<EOT
{{ ."Workspace" }}/apollo/policies/settings/{{.'policy_id' | @uri}}
        EOT
      }
    }
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

## COUNT
query "mod_auto_update_turbot_level" {
  title = ""
  sql   = <<EOQ
select count(*)
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title  like 'Turbot'
;
EOQ
}

query "mod_auto_update_mod_level" {
  title = ""
  sql   = <<EOQ
select count(*)
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title not like 'Turbot'
;
EOQ

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

## LIST
query "mod_auto_update_turbot_level_list" {
  title = ""
  sql   = <<EOQ
select 'Mod Auto Update' as "Mod Auto Update", id as policy_id, value as "Setting", workspace as "Workspace"
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title like 'Turbot'
;
EOQ

}

query "mod_auto_update_mod_level_list" {
  title = ""
  sql   = <<EOQ
select 'Mod Auto Update' as "Mod Auto Update", id as policy_id, value as "Setting", workspace as "Workspace"
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title not like 'Turbot'
;
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