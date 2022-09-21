dashboard "mod_auto_update_turbot_level_report" {
  title = "Mod Level Mod Auto Update Report"
  tags  = merge(local.mods_common_tags, {
    type     = "Report"
    category = "Auto Update"
  })
  container {

    table {
      title = "Mods level Auto Update Settings"
      query = query.mod_auto_update_mod_level_list
      column "policy_id" {
        display = "none"
      }
      column "Mod Auto Update Policy" {
        href = <<EOT
{{ ."Workspace" }}/apollo/policies/settings/{{.'policy_id' | @uri}}
        EOT
      }
    }
  }
}

query "mod_auto_update_turbot_level_list" {
  title = ""
  sql   = <<EOQ
select 'Mod Auto Update' as "Mod Auto Update Policy",
id as policy_id,
value as "Setting",
workspace as "Workspace"
from turbot_policy_setting
where filter = 'policyTypeId:"tmod:@turbot/turbot#/policy/types/modAutoUpdate" level:self'
and resource_trunk_title like 'Turbot'
;
EOQ
}