# Turbot Guardrails Insights Mod

Create dashboards and reports for your Guardrails resources using Powerpipe.

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

## Documentation

- **[Dashboards →](https://hub.powerpipe.io/mods/turbot/guardrails_insights/dashboards)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [Guardrails plugin](https://hub.steampipe.io/plugins/turbot/guardrails) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install guardrails
```

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-guardrails-insights
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Guardrails Insights Mod](https://github.com/turbot/steampipe-mod-guardrails-insights/labels/help%20wanted)
