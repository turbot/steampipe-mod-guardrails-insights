dashboard "turbot_control_alarm_report" {
  title = "Turbot Controls in Alarm Report"
  documentation = file("./dashboards/control/docs/control_alarm_report.md")
  tags = merge(local.control_common_tags, {
    type     = "Report"
    category = "Control"
  })

  container {

    card {
      sql   = query.turbot_control_alarm_count.sql
      width = 2
      type = "alert"
    }

    card {
      sql   = query.turbot_control_oldest_alarm_age.sql
      width = 2
      type = "info"
    }
    
    table {
      title = "Top 10 oldest controls in Alarm"
      sql = query.turbot_control_oldest_alarm.sql

      column id {
        display = "none"
      }

      column "Control Title" {
        href = <<-EOT
          {{ ."Workspace" }}/apollo/controls/{{."id" | @uri}}
        EOT
      }
    }

    table {
      title = "Top 10 newest controls in Alarm"
      sql = query.turbot_control_newest_alarm.sql

      column id {
        display = "none"
      }

      column "Control Title" {
        href = <<-EOT
          {{ ."Workspace" }}/apollo/controls/{{."id" | @uri}}
        EOT
      }
    }

    table {
      title = "Resource types with most Alarms"
      sql   = query.turbot_control_resource_with_most_alarms.sql
    }
  }
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
      value desc
    limit 1;
  EOQ
}

query "turbot_control_oldest_alarm" {
  sql = <<-EOQ
    select
      id,
      now()::date - update_timestamp::date as "Age in Days",
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Title",
      workspace as "Workspace"
    from 
      turbot_control
    where 
      state='alarm'
    order by
      "Age in Days" desc
    limit 10;
  EOQ
}

query "turbot_control_newest_alarm" {
  sql = <<-EOQ
    select
      id,
      now()::date - update_timestamp::date as "Age in Days",
      control_type_trunk_title as "Control Title",
      resource_trunk_title as "Resource Title",
      workspace as "Workspace"
    from 
      turbot_control
    where 
      state='alarm'
    order by
      "Age in Days" asc
    limit 10;
  EOQ
}

query "turbot_control_resource_with_most_alarms" {
  sql = <<-EOQ
    with alarm_control_group as (
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
    , ok_control_group as (
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
      ocg.ok_count as "OK Count",
      acg.workspace as "Workspace"
    from
      alarm_control_group as acg
      left join ok_control_group ocg on acg.resource_type_uri = ocg.resource_type_uri and acg.workspace = ocg.workspace
    order by
      acg.alarm_count desc
    limit 10;
  EOQ
}