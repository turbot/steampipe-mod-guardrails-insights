dashboard "turbot_control_dashboard" {
  title = "Turbot Controls Dashboard"
  documentation = file("./dashboards/control/docs/control_dashboard.md")
  tags = merge(local.control_common_tags, {
    type     = "Dashboard"
    category = "Control"
  })

  container {

    card {
      sql   = query.turbot_control_error_count.sql
      width = 2
      type = "alert"
      href  = dashboard.turbot_control_error_report.url_path
    }

    card {
      sql   = query.turbot_control_alarm_count.sql
      width = 2
      type = "alert"
      href  = dashboard.turbot_control_alarm_report.url_path
    }

    card {
      sql   = query.turbot_control_invalid_count.sql
      width = 2
      type = "alert"
      href = dashboard.turbot_control_invalid_report.url_path
    }

    chart {
      type  = "column"
      title = "Highest number of controls in Alarm by service"
      sql   = query.turbot_control_highest_alarm_count.sql
      axes {
        y {
          title {
            value   = "Count"
            display = "always"
          }
        }
      }
    }

  }
}

query "turbot_control_error_count" {
  sql = <<-EOQ
    select 
      count(*) as value,
      'Error' as label
    from 
      turbot_control 
    where state='error';
  EOQ
}

query "turbot_control_alarm_count" {
  sql = <<-EOQ
    select 
      count(*) as value,
      'Alarm' as label
    from 
      turbot_control 
    where state='alarm';
  EOQ
}

query "turbot_control_invalid_count" {
  sql = <<-EOQ
    select 
      count(*) as value,
      'Invalid' as label
    from 
      turbot_control 
    where state='invalid';
  EOQ
}

query "turbot_control_highest_alarm_count" {
  sql = <<-EOQ
    with alarm_controls as (
      select
        control_type_uri,
        workspace
      from 
        turbot_control
      where
        state='alarm'
    )
    select
      replace(split_part(control_type_uri,'/',2),'#','') as "Control Type",
      workspace as "Workspace",
      count(*) as "Count"
    from
      alarm_controls
    group by
      control_type_uri, workspace
    order by
      "Count" desc;
  EOQ
}