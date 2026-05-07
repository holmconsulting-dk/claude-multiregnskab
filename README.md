# multiregnskab — Claude Code plugin

A Claude Code plugin for working with [multiregnskab.dk](https://www.multiregnskab.dk) directly from your Claude session.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed

## Installation

Run these commands in your terminal:

```bash
claude plugin marketplace add holmconsulting-dk/claude-multiregnskab
claude plugin install multiregnskab@holmconsulting-dk-claude-multiregnskab
claude
```

Starting a session with `claude` triggers the download of the `mr` CLI binary. If you are not logged in to multiregnskab.dk you will be told at this point.

## First-time setup

Log in to your multiregnskab.dk account. Run this directly in your terminal — it is interactive and cannot be run through Claude:

```
mr user login
```

You only need to do this once. The token is stored locally and refreshed automatically.

## Usage

```
/multiregnskab:multiregnskab
```

Then describe what you want in plain language — create an invoice, list customers, check bank balances, and so on.

## License

[AGPL-3.0](LICENSE)
