---
repository: "https://github.com/turbot/steampipe-mod-guardrails-insights"
---

# Turbot Guardrails Insights Mod

Create dashboards and reports for your Guardrails resources using Steampipe.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-guardrails-insights/main/docs/images/guardrails_workspace_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-guardrails-insights/main/docs/images/guardrails_mod_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-guardrails-insights/main/docs/images/guardrails_controls_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-guardrails-insights/main/docs/images/guardrails_type_installed_error_report.png" width="50%" type="thumbnail"/>

## Overview

Dashboards can help answer questions like:

- How many workspaces do I have?
- What is the TE version on each of these workspaces?
- How many accounts (AWS, Azure, GCP) do I have across all workspaces?
- How many controls are in Alert (error, alarm, invalid) state across all workspaces?
- How many controls have an age of x hours/days?
- How many mods are installed across all workspaces?

## References

[Turbot Guardrails](https://turbot.com/guardrails) is the leading platform for policy-based control and automatic remediation of enterprise clouds.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration, and `dashboards` that organize and display key pieces of information.

## Documentation

- **[Dashboards →](https://hub.steampipe.io/mods/turbot/guardrails_insights/dashboards)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the Guardrails plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install guardrails
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-guardrails-insights.git
cd steampipe-mod-guardrails-insights
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser window at http://localhost:9194. From here, you can view dashboards and reports.

### Credentials

This mod uses the credentials configured in the [Steampipe Turbot Guardrails plugin](https://hub.steampipe.io/plugins/turbot/guardrails).

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional dashboards or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join #steampipe on Slack →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-guardrails-insights/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Guardrails Insights Mod](https://github.com/turbot/steampipe-mod-guardrails-insights/labels/help%20wanted)
