dashboard "turbot_control_error_report" {
  title = "Controls in Error Report"
  documentation = file("./dashboards/control/docs/control_error_report.md")
  tags = merge(local.control_common_tags, {
    type     = "Report"
    category = "Control"
  })

  container {

    card {
      sql   = query.turbot_control_error_count.sql
      width = 2
      type = "alert"
    }

    card {
      sql   = query.turbot_control_oldest_error_age.sql
      width = 2
      type = "info"
    }
    
    table {
      title = "Top 10 oldest controls in Error"
      sql = query.turbot_control_oldest_error.sql

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
      title = "Top 10 newest controls in Error"
      sql = query.turbot_control_newest_error.sql

      column id {
        display = "none"
      }

      column "Control Title" {
        href = <<-EOT
          {{ ."Workspace" }}/apollo/controls/{{."id" | @uri}}
        EOT
      }
    }
  }
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
      value desc
    limit 1;
  EOQ
}

query "turbot_control_oldest_error" {
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
      state='error'
    order by
      "Age in Days" desc
    limit 10;
  EOQ
}

query "turbot_control_newest_error" {
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
      state='error'
    order by
      "Age in Days" asc
    limit 10;
  EOQ
}