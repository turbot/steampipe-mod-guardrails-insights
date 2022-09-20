dashboard "turbot_controls_state" {
  title = "Turbot controls state"

  tags = merge(local.controls_common_tags, {
    type     = "Report"
    category = "Controls"
  })

  container {

    card {
      sql   = query.turbot_controls_error_count.sql
      width = 2
      type = "alert"
    }

    card {
      sql   = query.turbot_control_oldest_error_age.sql
      width = 2
    }

    card {
      sql   = query.turbot_controls_alarm_count.sql
      width = 2
      type = "alert"
    }

    card {
      sql   = query.turbot_control_oldest_alarm_age.sql
      width = 2
    }

    card {
      sql   = query.turbot_controls_invalid_count.sql
      width = 2
      type = "alert"
    }

    card {
      sql   = query.turbot_control_oldest_invalid_age.sql
      width = 2
    }
    
    table {
      title = "Oldest control in Error"
      sql = query.turbot_controls_oldest_error.sql
    }

    table {
      title = "Oldest control in Alarm"
      sql = query.turbot_controls_oldest_alarm.sql
    }

    table {
      title = "Oldest control in Invalid"
      sql = query.turbot_controls_oldest_invalid.sql
    }

    chart {
      type  = "bar"
      title = "Highest number of controls in Alarm"
      sql = query.turbot_controls_highest_alarm_count.sql
      axes {
        x {
          title {
            value = "Count"
            display = "always"
          }
        }
      }
    }

    table {
      title = "Resource types with most Alarms"
      sql = query.turbot_controls_resource_with_most_alarms.sql
    }

  }
}

query "turbot_controls_error_count" {
  sql = <<-EOQ
    select 
      count(*) as value,
      'Error' as label
    from 
      turbot_control 
    where state='error';
  EOQ
}

query "turbot_control_oldest_error_age" {
  sql = <<-EOQ
    select
      now()::date - update_timestamp::date as value,
      'Oldest Error (Days)' as label
    from 
      turbot_control
    where 
      state='error'
    order by
      value DESC
    limit 1;
  EOQ
}

query "turbot_controls_oldest_error" {
  sql = <<-EOQ
    select 
      now()::date - update_timestamp::date as "Age in Days",
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Title"
    from 
      turbot_control
    where 
      state='error'
    order by
      "Age in Days" DESC
    limit 10;
  EOQ
}

query "turbot_controls_alarm_count" {
  sql = <<-EOQ
    select 
      count(*) as value,
      'Alarm' as label
    from 
      turbot_control 
    where state='alarm';
  EOQ
}

query "turbot_control_oldest_alarm_age" {
  sql = <<-EOQ
    select
      now()::date - update_timestamp::date as value,
      'Oldest Alarm (Days)' as label
    from 
      turbot_control
    where 
      state='alarm'
    order by
      value DESC
    limit 1;
  EOQ
}

query "turbot_controls_oldest_alarm" {
  sql = <<-EOQ
    select 
      now()::date - update_timestamp::date as "Age in Days",
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Title"
    from 
      turbot_control
    where 
      state='alarm'
    order by
      "Age in Days" DESC
    limit 10;
  EOQ
}

query "turbot_controls_invalid_count" {
  sql = <<-EOQ
    select 
      count(*) as value,
      'Invalid' as label
    from 
      turbot_control 
    where state='invalid';
  EOQ
}

query "turbot_control_oldest_invalid_age" {
  sql = <<-EOQ
    select
      now()::date - update_timestamp::date as value,
      'Oldest Invalid (Days)' as label
    from 
      turbot_control
    where 
      state='invalid'
    order by
      value DESC
    limit 1;
  EOQ
}

query "turbot_controls_oldest_invalid" {
  sql = <<-EOQ
    select 
      now()::date - update_timestamp::date as "Age in Days",
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Title"
    from 
      turbot_control
    where 
      state='invalid'
    order by
      "Age in Days" DESC
    limit 10;
  EOQ
}

query "turbot_controls_highest_alarm_count" {
  sql = <<-EOQ
    select
      concat(split_part(control_type_uri,'/',2),'/', split_part(control_type_uri,'/',5)) as "Control Type",
      count(*) as"Count"
    from turbot_control
    where 
      state='alarm'
    group by
      control_type_uri
    order by
      "Count" asc;
  EOQ
}

query "turbot_controls_resource_with_most_alarms" {
  sql = <<-EOQ
    with alarm_controls as (
      select
        resource_type_uri,
        count(*) as alarm_count
      from
        turbot_control
      where
        state='alarm'
      group by
        resource_type_uri
    ),
    ok_controls as (
      select
        resource_type_uri,
        count(*) as ok_count
      from
        turbot_control
      where
        state='ok'
      group by
        resource_type_uri
    )
    select
      ac.resource_type_uri as "Resource Type",
      ac.alarm_count as "Alarm Count",
      oc.ok_count as "Ok Count"
      -- ac.alarm_count::decimal / oc.ok_count::decimal as "Ratio"
    from
      alarm_controls as ac
      left join ok_controls oc on ac.resource_type_uri = oc.resource_type_uri
    order by
      ac.alarm_count desc
    limit 10;
  EOQ
}