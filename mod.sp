mod "guardrails_insights" {
  # Hub metadata
  title         = "Turbot Guardrails Insights"
  description   = "Create dashboards and reports for your Turbot Guardrails resources using Powerpipe and Steampipe."
  color         = "#FCC119"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/guardrails-insights.svg"
  categories    = ["guardrails", "dashboard", "security"]

  opengraph {
    title       = "Powerpipe Mod for Turbot Guardrails Insights"
    description = "Create dashboards and reports for your Turbot Guardrails resources using Powerpipe and Steampipe."
    image       = "/images/mod/turbot/guardrails-insights-social-graphic.png"
  }

  require {
    plugin "guardrails" {
      min_version = "0.11.1"
    }
  }
}
