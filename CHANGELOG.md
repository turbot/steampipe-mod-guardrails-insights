## v0.5 [2024-05-14]

_What's new?_

- New dashboards added:
  - [Turbot Guardrails Workspace Report for Admin](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.workspace_report_admin)
- New benchmark added:
  - [Turbot Guardrails Workspace Health](https://hub.steampipe.io/mods/turbot/guardrails_insights/controls/benchmark.workspace_health)

## v0.4 [2024-04-19]

_Enhancements_

- Updated the `workspace_dashboard` dashboard to include information on the accounts, resources, and active controls across different workspaces. ([#31](https://github.com/turbot/steampipe-mod-guardrails-insights/pull/31))
- Updated the `workspace_account_report` dashboard to display resources, policy settings, alerts, and active controls across workspaces instead of the TE version. ([#31](https://github.com/turbot/steampipe-mod-guardrails-insights/pull/31))

## v0.3 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.2 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#25](https://github.com/turbot/steampipe-mod-guardrails-insights/pull/25))

## v0.1 [2023-08-23]

_What's new?_

- New dashboards added:
  - [Turbot Guardrails Controls Alarm Age Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.control_alarm_report_age)
  - [Turbot Guardrails Controls Dashboard](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.control_dashboard)
  - [Turbot Guardrails Controls Error Age Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.control_error_report_age)
  - [Turbot Guardrails Controls Invalid Age Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.control_invalid_report_age)
  - [Turbot Guardrails Mods Dashboard](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.mod_dashboard)
  - [Turbot Guardrails Mod Installed Errors Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.mod_mod_installed_errors_report)
  - [Turbot Guardrails Type Installed Errors Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.mod_type_installed_errors_report)
  - [Turbot Guardrails Workspace Account Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.workspace_account_report)
  - [Turbot Guardrails Workspace Dashboard](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.workspace_dashboard)
  - [Turbot Guardrails Workspace Report](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards/dashboard.workspace_report)
