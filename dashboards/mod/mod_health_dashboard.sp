dashboard "mod_health_dashboard" {
  title = "Turbot Mod Health Dashboard"
    tags = merge(local.mods_common_tags, {
    type     = "Dashboard"
    category = "Health"
  })
  container {
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
      href = dashboard.mod_mod_installed_errors_report.url_path
    }
    card {
      title = "Type Installed Errors"
      width = 2
      sql   = query.type_installed_controls_error.sql
      type  = "alert"
      href = dashboard.mod_type_installed_errors_report.url_path
    }
  }

}
