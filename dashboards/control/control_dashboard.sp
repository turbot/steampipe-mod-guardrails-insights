dashboard "turbot_control_dashboard" {
  title         = "Controls Dashboard"
  documentation = file("./dashboards/control/docs/control_dashboard.md")
  tags = merge(local.control_common_tags, {
    type     = "Dashboard"
    category = "Control"
  })

  container {

    card {
      sql   = query.turbot_control_alarm_count.sql
      width = 2
      type  = "alert"
      href  = dashboard.turbot_control_alarm_report_age.url_path
    }

    card {
      sql   = query.turbot_control_error_count.sql
      width = 2
      type  = "alert"
      href  = dashboard.turbot_control_error_report_age.url_path
    }

    card {
      sql   = query.turbot_control_invalid_count.sql
      width = 2
      type  = "alert"
      href  = dashboard.turbot_control_invalid_report_age.url_path
    }

    container {
      title = "Control states by workspaces"

      chart {
        type  = "column"
        title = "Alarm"
        width = 4
        sql   = <<-EOQ
          select
            _ctx ->> 'connection_name' as "Connection Name",
            count(state) as "Count"
          from
            turbot_control 
          where
            state = 'alarm' 
          group by
            _ctx 
          order by
            "Count" desc;
        EOQ
      }

      chart {
        type  = "column"
        title = "Error"
        width = 4
        sql   = <<-EOQ
          select
            _ctx ->> 'connection_name' as "Connection Name",
            count(state) as "Count" 
          from
            turbot_control 
          where
            state = 'error' 
          group by
            _ctx 
          order by
            "Count" desc;
        EOQ
      }

      chart {
        type  = "column"
        title = "Invalid"
        width = 4
        sql   = <<-EOQ
          select
            _ctx ->> 'connection_name' as "Connection Name",
            count(state) as "Count" 
          from
            turbot_control 
          where
            state = 'invalid' 
          group by
            _ctx 
          order by
            "Count" desc;
        EOQ
      }
    }

    table {
      title = "Top 20 Alerts by Control Type URI across workspaces"
      sql   = query.turbot_control_top_20_alerts.sql
    }
  }
}

query "turbot_control_error_count" {
  sql = <<-EOQ
    select
      case when count(*) > 0 then count(*) else '0' end as value,
      'Error' as label,
      case when count(*) = 0 then 'ok' else 'alert' end as "type"
    from
      turbot_control 
    where
      state = 'error';
  EOQ
}

query "turbot_control_alarm_count" {
  sql = <<-EOQ
    select
      case when count(*) > 0 then count(*) else '0' end as value,
      'Alarm' as label,
      case when count(*) = 0 then 'ok' else 'alert' end as "type"
    from
      turbot_control 
    where
      state = 'alarm';
  EOQ
}

query "turbot_control_invalid_count" {
  sql = <<-EOQ
    select
      case when count(*) > 0 then count(*) else '0' end as value,
      'Invalid' as label,
      case when count(*) = 0 then 'ok' else 'alert' end as "type"
    from
      turbot_control 
    where
      state = 'invalid';
  EOQ
}

query "turbot_control_top_20_alerts" {
  sql = <<-EOQ
    select
      control_type_trunk_title as "Control Type Trunk Title", control_type_uri as "Control Type URI",
      count(control_type_uri) as "Count" 
    from
      turbot_control 
    where
      state in 
      (
        'alarm',
        'error',
        'invalid'
      )
    group by
      control_type_uri, control_type_trunk_title 
    order by
      "Count" desc limit 20
  EOQ
}
