dashboard "mods_installed_gcp" {
  title = "Mods Installed - GCP"
  container {
    table {
      title = "GCP Mods List"
      query = query.installed_gcp_mods_list
      width = 4
      column "id" {
        display = "none"
      }
      column "Workspace URL" {
        display = "none"
      }
      column "Mod Name" {
        href = <<EOT
{{ ."Workspace URL" }}/apollo/admin/mods/{{.'id' | @uri}}
        EOT
      }
    }
  }
}