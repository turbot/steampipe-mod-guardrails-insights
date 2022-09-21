dashboard "mods_installed_azure" {
  title = "Mods Installed - Azure"
  container {
    table {
      title = "Azure Mods List"
      query = query.installed_azure_mods_list
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