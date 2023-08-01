dashboard "mod_type_installed_errors_report" {
  title = "Guardrails Type Installed Errors Report"
  tags = merge(local.mod_common_tags, {
    type     = "Report"
    category = "Installation Errors"
  })
  container {
    text {
      value = "These types have some problem that prevents them from installing or updating properly. These should be resolved as soon as possible."
    }
    card {
      title = "Number of Type Installed Errors"
      sql   = query.type_installed_controls_error.sql
      width = "2"
    }
  }
  container {
    table {
      title = "Types in Error"
      query = query.type_installed_controls_error_list
      column "Control Id" {
        href = <<-EOT
{{ .'workspace' }}/apollo/controls/{{.'Control Id' | @uri}}
        EOT
      }
      column "workspace" {
        display = "none"
      }
    }
  }
}

query "type_installed_controls_error" {
  title = "Mod Installed Control Errors"
  sql   = <<-EOQ
    select
      case when count(*) > 0 then count(*) else '0' end as value,
      'Type Installed Errors' as label,
      case when count(*) = 0 then 'ok' else 'alert' end as "type"
    from
      guardrails_control 
    where
      filter = 'state:error controlTypeId:"tmod:@turbot/turbot#/control/types/controlInstalled" level:self';
EOQ
}

query "type_installed_controls_error_list" {
  title = "Type Installed Control Errors List"
  sql   = <<-EOQ
    select
      id as "Control Id",
      workspace,
      resource_trunk_title as "Trunk Title",
      reason as "Reason",
      _ctx ->> 'connection_name' as "Connection Name" 
    from
      guardrails_control 
    where
      control_type_uri = 'tmod:@turbot/turbot#/control/types/controlInstalled' 
      and state = 'error' 
    order by
      workspace,
      resource_trunk_title;
EOQ
}
