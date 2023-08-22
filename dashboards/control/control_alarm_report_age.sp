dashboard "control_alarm_report_age" {
  title         = " Turbot Guardrails Controls Alarm Age Report"
  documentation = file("./dashboards/control/docs/control_alarm_report_age.md")
  tags = merge(local.control_common_tags, {
    type     = "Report"
    category = "Control"
  })

  container {

    card {
      query = query.guardrails_control_alarm_total_count
      width = 2
      type  = "alert"
      label = "Count"
    }

    card {
      query = query.guardrails_control_alert_24_hours_count
      width = 2
      type  = "alert"
      label = "< 24 hours"
    }

    card {
      query = query.guardrails_control_alert_between_1_30_days
      width = 2
      type  = "alert"
      label = "1-30 Days"
    }

    card {
      query = query.guardrails_control_alert_between_30_90_days
      width = 2
      type  = "alert"
      label = "30-90 Days"
    }

    card {
      query = query.guardrails_control_alert_between_90_365_days
      width = 2
      type  = "alert"
      label = "90-365 Days"
    }

    card {
      query = query.guardrails_control_alert_after_1_year
      width = 2
      type  = "alert"
      label = "> 1 Year"
    }

    table {
      title = "Controls"
      query = query.guardrails_control_alert_oldest

      column "id" {
        display = "none"
      }

      column "workspace" {
        display = "none"
      }

      column "Control Title" {
        href = <<-EOT
          {{ ."workspace" }}/apollo/controls/{{."id" | @uri}}
        EOT
      }
    }

  }
}


query "guardrails_control_alarm_total_count" {
  sql = <<-EOQ
    select
      count(*) as value,
      'Count' as label
    from
      guardrails_control
    where
      state = 'alarm';
  EOQ
}

query "guardrails_control_alert_24_hours_count" {
  sql = <<-EOQ
    with less_than_24_hours_alert_changed as
    (
      select
        now()::date - update_timestamp::date as days
      from
        guardrails_control
      where
        update_timestamp > now() - '1 days' :: interval
        and state = 'alarm'
    )
    select
      count(*) as value,
      '< 24 hours' as label
    from
      less_than_24_hours_alert_changed;
  EOQ
}

query "guardrails_control_alert_between_1_30_days" {
  sql = <<-EOQ
    with between_1_30_days as
    (
      select
        now()::date - update_timestamp::date as days
      from
        guardrails_control
      where
        update_timestamp between symmetric now() - '1 days' :: interval and now() - '30 days' :: interval
        and state = 'alarm'
    )
    select
      count(*) as value,
      '1-30 Days' as label
    from
      between_1_30_days;
  EOQ
}

query "guardrails_control_alert_between_30_90_days" {
  sql = <<-EOQ
    with between_30_90_days as
    (
      select
        now()::date - update_timestamp::date as days
      from
        guardrails_control
      where
        update_timestamp between symmetric now() - '30 days' :: interval and now() - '90 days' :: interval
        and state = 'alarm'
    )
    select
      count(*) as value,
      '30-90 Days' as label
    from
      between_30_90_days;
  EOQ
}

query "guardrails_control_alert_between_90_365_days" {
  sql = <<-EOQ
    with between_90_365_days as
    (
      select
        now()::date - update_timestamp::date as days
      from
        guardrails_control
      where
        update_timestamp between symmetric (now() - '90 days'::interval) and
        (
          now() - '365 days'::interval
        )
        and state = 'alarm'
    )
    select
      count(*) as value,
      '90-365 Days' as label
    from
      between_90_365_days;
  EOQ
}

query "guardrails_control_alert_after_1_year" {
  sql = <<-EOQ
    with after_1_year as
    (
      select
        now()::date - update_timestamp::date as days
      from
        guardrails_control
      where
        update_timestamp <= now() - '1 year' :: interval
        and state = 'alarm'
    )
    select
      count(*) as value,
      '> 1 Year' as label
    from
      after_1_year;
  EOQ
}

query "guardrails_control_alert_oldest" {
  sql = <<-EOQ
    select
      id,
      workspace,
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Trunk Title",
      now()::date - update_timestamp::date as "Age in Days",
      _ctx ->> 'connection_name' as "Connection Name"
    from
      guardrails_control
    where
      state = 'alarm'
    order by
      "Age in Days" desc;
  EOQ
}
