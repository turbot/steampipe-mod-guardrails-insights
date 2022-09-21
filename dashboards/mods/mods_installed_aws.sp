dashboard "mods_installed_aws" {
  title = "Mods Installed - AWS"
  container {
    table {
      title = "AWS Mods List"
      query = query.installed_aws_mods_list
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