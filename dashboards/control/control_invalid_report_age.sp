dashboard "turbot_control_invalid_report_age" {
  title         = "Controls Invalid Age Report"
  documentation = file("./dashboards/control/docs/control_invalid_report_age.md")
  tags = merge(local.control_common_tags, {
    type     = "Report"
    category = "Control"
  })

  container {

    card {
      query = query.turbot_control_invalid_total_count
      width = 2
      type  = "alert"
      label = "Count"
    }

    card {
      query = query.turbot_control_invalid_24_hours_count
      width = 2
      type  = "alert"
      label = "< 24 hours"
    }

    card {
      query = query.turbot_control_invalid_between_1_30_days
      width = 2
      type  = "alert"
      label = "1-30 Days"
    }

    card {
      query = query.turbot_control_invalid_between_30_90_days
      width = 2
      type  = "alert"
      label = "30-90 Days"
    }

    card {
      query = query.turbot_control_invalid_between_90_365_days
      width = 2
      type  = "alert"
      label = "90-365 Days"
    }

    card {
      query = query.turbot_control_invalid_after_1_year
      width = 2
      type  = "alert"
      label = "> 1 Year"
    }

    table {
      title = "Controls"
      query = query.turbot_control_invalid_oldest

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


query "turbot_control_invalid_total_count" {
  sql = <<-EOQ
    select
      count(*) as value,
      'Count' as label 
    from
      turbot_control 
    where
      state = 'invalid';
  EOQ
}

query "turbot_control_invalid_24_hours_count" {
  sql = <<-EOQ
    with less_than_24_hours_invalid_changed as 
    (
      select
        now()::date - update_timestamp::date as days 
      from
        turbot_control 
      where
        update_timestamp > now() - '1 days' :: interval 
        and state = 'invalid' 
    )
    select
      count(*) as value,
      '< 24 hours' as label 
    from
      less_than_24_hours_invalid_changed;
  EOQ
}

query "turbot_control_invalid_between_1_30_days" {
  sql = <<-EOQ
    with between_1_30_days as 
    (
      select
        now()::date - update_timestamp::date as days 
      from
        turbot_control 
      where
        update_timestamp between symmetric now() - '1 days' :: interval and now() - '30 days' :: interval 
        and state = 'invalid' 
    )
    select
      count(*) as value,
      '1-30 Days' as label 
    from
      between_1_30_days;
  EOQ
}

query "turbot_control_invalid_between_30_90_days" {
  sql = <<-EOQ
    with between_30_90_days as 
    (
      select
        now()::date - update_timestamp::date as days 
      from
        turbot_control 
      where
        update_timestamp between symmetric now() - '30 days' :: interval and now() - '90 days' :: interval 
        and state = 'invalid' 
    )
    select
      count(*) as value,
      '30-90 Days' as label 
    from
      between_30_90_days;
  EOQ
}

query "turbot_control_invalid_between_90_365_days" {
  sql = <<-EOQ
    with between_90_365_days as 
    (
      select
        now()::date - update_timestamp::date as days 
      from
        turbot_control 
      where
        update_timestamp between symmetric (now() - '90 days'::interval) and 
        (
          now() - '365 days'::interval
        )
        and state = 'invalid' 
    )
    select
      count(*) as value,
      '90-365 Days' as label 
    from
      between_90_365_days;
  EOQ
}

query "turbot_control_invalid_after_1_year" {
  sql = <<-EOQ
    with after_1_year as 
    (
      select
        now()::date - update_timestamp::date as days 
      from
        turbot_control 
      where
        update_timestamp <= now() - '1 year' :: interval 
        and state = 'invalid' 
    )
    select
      count(*) as value,
      '> 1 Year' as label 
    from
      after_1_year;
  EOQ
}

query "turbot_control_invalid_oldest" {
  sql = <<-EOQ
    select
      id,
      workspace,
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Trunk Title",
      now()::date - update_timestamp::date as "Age in Days",
      _ctx ->> 'connection_name' as "Connection Name" 
    from
      turbot_control 
    where
      state = 'invalid' 
    order by
      "Age in Days" desc;
  EOQ
}
