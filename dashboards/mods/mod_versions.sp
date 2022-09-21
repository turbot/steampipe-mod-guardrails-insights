dashboard "mod_versions" {
  title = "Mod Versions Report"
  container {
    card {
      title = "Mods not on recommended version"
    }
  }
  container {
    table {
      title = "Mods List not on Recommended Version"
#      query = query.mods_behind_recommended_list
    }
  }
}

query "mods_behind_recommended" {

}

query "mods_behind_recommended_list" {

}