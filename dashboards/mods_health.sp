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
      href = dashboard.mod_installed_errors.url_path
    }
    card {
      title = "Type Installed Errors"
      width = 2
      sql   = query.type_installed_controls_error.sql
      type  = "alert"
      href = dashboard.type_installed_errors.url_path
    }
  }

}
