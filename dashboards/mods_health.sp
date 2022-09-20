dashboard "turbot_mods_health" {
  title = "Turbot Mods Health"
  container {
    title = "Identify if Mods are installed properly"
    card {
      title = "Mods Installed"
      sql   = query.installed_mods_count.sql
      width = 2
    }
    card {
      title = "Mod Installed Errors"
      width = 2
      sql   = query.mod_installed_controls_error.sql
      type  = "alert"
    }
    card {
      title = "Type Installed Errors"
      width = 2
      sql   = query.type_installed_controls_error.sql
      type  = "alert"
    }
  }
  container {

    table {
      title = "Mods in Error"
      query = query.mod_installed_controls_error_list
      #      width = 6
      column "Mod Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/controls/{{.'control_id' | @uri}}
        EOT
      }
      column "control_id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "resource_id" {
        display = "none"
      }

    }
    table {
      title = "Types in Error"
      query = query.type_installed_controls_error_list
      column "Type Installed Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/controls/{{.'control_id' | @uri}}
        EOT
      }
      column "control_id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "resource_id" {
        display = "none"
      }
    }
  }
}


query "mod_installed_controls_error" {
  title = "Mod Installed Controls Errors"
  sql   = <<EOQ
select count(*) as "Mod Installed Errors"
from turbot_control
where  filter = 'state:error controlTypeId:"tmod:@turbot/turbot#/control/types/modInstalled" level:self';
EOQ
}

query "mod_installed_controls_error_list" {
  title = "Mod Installed Controls Errors List"
  sql   = <<EOQ
with controls_list as (select id                                              as control_id,
                              state                                           as control_state,
                              reason                                          as control_reason,
                              details #>> '{0,value}'                         as control_details,
                              resource_id                                     as resource_id,
                              substring(workspace from 'https://([a-z]+)(.)') as "Workspace",
                              workspace                                       as "Workspace URL"
                       from turbot_control
                       where filter =
                             'state:error controlTypeId:"tmod:@turbot/turbot#/control/types/modInstalled" level:self'),

     mods_resources as (select substr(title
         , 9)                                                                  as mod_name


                             , id                                              as resource_id
                        from turbot_resource
                        where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self')
select mr.mod_name as "Mod Name", con.control_id, con.control_reason as "Reason", con.control_details as "Detail", mr.resource_id, con."Workspace", con."Workspace URL"
       from controls_list con
left join mods_resources mr on con.resource_id=mr.resource_id;

EOQ
}

query "type_installed_controls_error" {
  title = "Mod Installed Control Errors"
  sql   = <<EOQ
select count(*) as "Type Installed Errors"
from turbot_control
where  filter = 'state:error controlTypeId:"tmod:@turbot/turbot#/control/types/controlInstalled" level:self';
EOQ
}

query "type_installed_controls_error_list" {
  title = "Type Installed Control Errors List"
  sql = <<EOQ
with controls_list as (select id                                              as control_id,
                              state                                           as control_state,
                              reason                                          as control_reason,
                              details #>> '{0,value}'                         as control_details,
                              resource_id                                     as resource_id,
                              substring(workspace from 'https://([a-z]+)(.)') as "Workspace",
                              workspace                                       as "Workspace URL"
                       from turbot_control
                       where state like 'error' and
                             filter =
                             'controlTypeId:"tmod:@turbot/turbot#/control/types/controlInstalled" level:self'),
     mods_resources as (select substr(title, 9) as mod_name,
                               title            as mod_title,
                               id               as resource_id
                        from turbot_resource
                        where filter = 'resourceTypeId:"tmod:@turbot/turbot#/resource/types/mod" level:self')
select con.control_id,
       con.control_reason,
       con.control_details,
       mr.mod_name,
       mr.resource_id
from controls_list con
         left join mods_resources mr on con.resource_id = mr.resource_id;
EOQ
}
