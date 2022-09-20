dashboard "turbot_resource_detail" {
  title = "Turbot Resources Report"
  # documentation = ""
  # tags = 

  container {
    text {
      value = "The workspace report, gives you a detailed analysis of all the Turbot Workspace you are connected to along with the TE Version they are on."
      # width = "4"
    }

    table {
      title = "Resource Types By Provider"
      sql   = <<-EOQ
        select
        sum(case when mod_uri like 'tmod:@turbot/aws-%' then 1 else 0 end) as "AWS",
        sum(case when mod_uri like 'tmod:@turbot/azure-%' then 1 else 0 end) as "Azure",
        sum(case when mod_uri like 'tmod:@turbot/gcp-%' then 1 else 0 end) as "GCP",
        count(*) as "Total"
        from
        turbot_resource_type;
      EOQ
      type  = "column"
      width = 6
    }
  }

}
