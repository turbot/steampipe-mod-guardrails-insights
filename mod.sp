mod "turbot_insights" {
  # hub metadata
  title         = "Turbot Insights"
  description   = "Create dashboards and reports for your Turbot resources using Steampipe."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/turbot-insights.svg"
  categories    = ["turbot", "dashboard", "security"]

  opengraph {
    title       = "Steampipe Mod for Turbot Insights"
    description = "Create dashboards and reports for your Turbot resources using Steampipe."
    image       = "/images/mod/turbot/turbot-insights-social-graphic.png"
  }

  require {
    steampipe = "0.20.8"
    plugin "turbot" {
      version = "0.10.0"
    }
  }
}
