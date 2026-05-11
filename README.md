# multiregnskab — Claude Code plugin

A Claude Code plugin for working with [multiregnskab.dk](https://www.multiregnskab.dk) directly from your Claude session.

This plugin relies on the [cli-multiregnskab](https://github.com/holmconsulting-dk/cli-multiregnskab) command line tool, which is downloaded automatically on first use.

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

Then describe what you want in plain language — in Danish or English. Examples:

> Opret privatkunden Hans Andersen, Markvejen 20, 8000 Århus, med 14 dages kredit

> Opret en faktura til Hans Andersen, han har købt 25 konsulenttimer

## Updating

```bash
claude plugin marketplace update holmconsulting-dk-claude-multiregnskab
claude plugin update multiregnskab@holmconsulting-dk-claude-multiregnskab
```

Then restart Claude Code to download the updated `mr` binary.

## License

[AGPL-3.0](LICENSE)
