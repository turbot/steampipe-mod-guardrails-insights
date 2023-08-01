mod "guardrails_insights" {
  # hub metadata
  title         = "Guardrails Insights"
  description   = "Create dashboards and reports for your Guardrails resources using Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/guardrails-insights.svg"
  categories    = ["guardrails", "dashboard", "security"]

  opengraph {
    title       = "Steampipe Mod for Guardrails Insights"
    description = "Create dashboards and reports for your Guardrails resources using Steampipe."
    image       = "/images/mod/turbot/guardrails-insights-social-graphic.png"
  }

  require {
    steampipe = "0.20.9"
    plugin "guardrails" {
      version = "0.11.1"
    }
  }
}
