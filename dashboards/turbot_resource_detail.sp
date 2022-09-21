dashboard "turbot_resource_detail" {
  title = "Turbot Resources Report"
  # documentation = ""
  # tags = 

  container {
    text {
      value = "The workspace report, gives you a detailed analysis of all the Turbot Workspace you are connected to along with the TE Version they are on."
      # width = "4"
    }

    chart {
      type  = "bar"
      width = 6
      title = "Top 25 Resource Types"

      legend {
        display  = "auto"
        position = "top"
      }
      axes {
        x {
          title {
            value = "Regions"
          }
          labels {
            display = "auto"
          }
        }
        y {
          title {
            value = "Totals"
          }
          labels {
            display = "show"
          }
          min = 0
          max = 100
        }
      }

      sql = <<-EOQ
        select
        resource_type_uri as "URI",
        count(*)
        from
        turbot_resource
        where
        resource_type_uri not like 'tmod:@turbot/turbot%'
        group by
        resource_type_uri
        order by
        count ASC
        limit
        25
    EOQ

    }
  }

}
