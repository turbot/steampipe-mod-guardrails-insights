#dashboard "mod_versions_report" {
#  title = "Mod Versions Report"
#    tags  = merge(local.mods_common_tags, {
#    type     = "Report"
#    category = "Out of Date"
#  })
#  container {
#    card {
#      title = "Mods not on recommended version"
#    }
#  }
#  container {
#    table {
#      title = "Mods List not on Recommended Version"
##      query = query.mods_behind_recommended_list
#    }
#  }
#}
#
#query "mods_behind_recommended" {
#
#}
#
#query "mods_behind_recommended_list" {
#
#}