dashboard "mod_auto_update_dashboard" {
  title = "Mod Auto Update Dashboard"
  tags  = merge(local.mod_common_tags, {
    type     = "Dashboard"
    category = "Auto Update"
  })
  container {
    card {
      title = "Turbot level Auto Update"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_turbot_level.sql
      href  = dashboard.mod_auto_update_turbot_level_report.url_path
    }
    card {
      title = "Mod level Auto Update"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_mod_level.sql
      href  = dashboard.mod_auto_update_mod_level_report.url_path
    }
    card {
      title = "Turbot level Update Schedules"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_schedule.sql
      href  = dashboard.mod_auto_update_turbot_level_schedules_report.url_path
    }
    card {
      title = "Mod level Update Schedules"
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_schedule.sql
      href  = dashboard.mod_auto_update_mod_level_schedules_report.url_path
    }
  }
}

query "mod_auto_update_mod_level" {
  title = "Count of Mod Auto Update policies set on individual mods"
  sql   = <<EOQ
select count(*)
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title not like 'Turbot';
EOQ
}

query "mod_auto_update_turbot_level" {
  title = "Count of Mod Auto Update policies set at the Turbot level"
  sql   = <<EOQ
select count(*)
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title  like 'Turbot';
EOQ
}