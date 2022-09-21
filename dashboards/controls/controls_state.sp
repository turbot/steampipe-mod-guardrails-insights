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
      title = "Oldest controls in Error"
      sql = query.turbot_controls_oldest_error.sql
    }

    table {
      title = "Oldest controls in Alarm"
      sql = query.turbot_controls_oldest_alarm.sql
    }

    table {
      title = "Oldest controls in Invalid"
      sql = query.turbot_controls_oldest_invalid.sql
    }

    chart {
      type  = "column"
      title = "Highest number of controls in Alarm by service"
      sql = query.turbot_controls_highest_alarm_count.sql
      axes {
        y {
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
      resource_trunk_title as "Resource Title",
      workspace as "Workspace"
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
      resource_trunk_title as "Resource Title",
      workspace as "Workspace"
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
      resource_trunk_title as "Resource Title",
      workspace as "Workspace"
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

query "turbot_controls_resource_with_most_alarms" {
  sql = <<-EOQ
    with alarm_controls_group as (
      with alarm_controls as (
        select
          resource_type_uri,
          workspace
        from
          turbot_control
        where
          state='alarm'
      )
      select
        resource_type_uri,
        workspace,
        count(*) as alarm_count
      from
        alarm_controls
      group by
        resource_type_uri, workspace
    )
    , ok_controls_group as (
      with ok_controls as (
        select
          resource_type_uri,
          workspace
        from
          turbot_control
        where
          state='ok'
      )
      select
        resource_type_uri,
        workspace,
        count(*) as ok_count
      from
        ok_controls
      group by
        resource_type_uri, workspace
    )
    select
      acg.resource_type_uri as "Resource Type",
      acg.alarm_count as "Alarm Count",
      ocg.ok_count as "Ok Count",
      acg.workspace as "Workspace"
    from
      alarm_controls_group as acg
      left join ok_controls_group ocg on acg.resource_type_uri = ocg.resource_type_uri and acg.workspace = ocg.workspace
    order by
      acg.alarm_count desc
    limit 10;
  EOQ
}