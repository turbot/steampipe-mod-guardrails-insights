dashboard "mod_auto_update_turbot_level_schedules_report" {
  title = "Turbot Level Mod Auto Update Schedules Report"
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
