# multiregnskab — Claude Code plugin

A Claude Code plugin for working with [multiregnskab.dk](https://www.multiregnskab.dk) directly from your Claude session.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [gh CLI](https://cli.github.com) installed and authenticated — used to download the `mr` binary on first use

## Installation

```
/plugin marketplace add holmconsulting-dk/claude-multiregnskab
/plugin install multiregnskab@holmconsulting-dk-claude-multiregnskab
```

The `mr` CLI binary is downloaded automatically when your session starts.

## First-time setup

Log in to your multiregnskab.dk account:

```
mr user login
```

## Usage

```
/multiregnskab:multiregnskab
```

Then describe what you want in plain language — create an invoice, list customers, check bank balances, and so on.

## License

[AGPL-3.0](LICENSE)
