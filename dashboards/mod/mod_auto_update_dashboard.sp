dashboard "mod_auto_update_dashboard" {
  title = "Mod Auto Update Dashboard"
  tags  = merge(local.mod_common_tags, {
    type     = "Dashboard"
    category = "Auto Update"
  })
  container {
    card {
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_turbot_level.sql
      href  = dashboard.mod_auto_update_turbot_level_report.url_path
    }
    card {
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_mod_level.sql
      href  = dashboard.mod_auto_update_mod_level_report.url_path
    }
    card {
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_schedule.sql
      href  = dashboard.mod_auto_update_turbot_level_schedules_report.url_path
    }
    card {
      width = 2
      type  = "info"
      sql   = query.mod_auto_update_schedule.sql
      href  = dashboard.mod_auto_update_mod_level_schedules_report.url_path
    }
  }
}

query "mod_auto_update_mod_level" {
  sql   = <<EOQ
select count(*) as "Turbot level Auto Update"
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title not like 'Turbot';
EOQ
}

query "mod_auto_update_turbot_level" {
  sql   = <<EOQ
select count(*) as "Turbot level Auto Update"
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title  like 'Turbot';
EOQ
}