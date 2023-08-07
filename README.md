# Turbot Guardrails Insights Mod for Steampipe

A Turbot Guardrails dashboarding tool that can be used to view dashboards and reports across all of your Turbot Guardrails workspaces.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-guardrails-insights/release/v0.1/docs/images/guardrails_workspace_dashboard.png)

## Overview

Dashboards can help answer questions like:

- How many workspaces do I have?
- What is the TE version on each of these workspaces?
- How many accounts(AWS, Azure, GCP) do I have across all workspaces?
- How many controls are in Alert (error, alarm, invalid) state across all workspaces?
- How many controls have an age of x hours/days?
- How many mods are installed across all workspaces?

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the Turbot Guardrails plugin with [Steampipe](https://steampipe.io):

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

If you have an idea for additional dashboards or reports, or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join #steampipe on Slack →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-guardrails-insights/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Guardrails Insights Mod](https://github.com/turbot/steampipe-mod-guardrails-insights/labels/help%20wanted)
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
