---
name: multiregnskab
description: Work with multiregnskab.dk accounting — list companies, manage customers, create invoices, check bank balances, and work with products. Use when the user asks about their accounts, invoices, customers, or financial data in multiregnskab.
user-invocable: true
allowed-tools:
  - Bash(mr *)
  - Write(/tmp/*)
argument-hint: [task description]
---

You have access to the `mr` CLI tool for the multiregnskab.dk accounting system.

## CLI structure

`mr` is organised into areas (e.g. `bank`, `invoices`, `products`), each grouping related subcommands. Every area and every subcommand supports an `info` subcommand that describes what it does and what options are available:

```
mr invoices info               # describes the invoices area and lists its subcommands
mr invoices create info        # describes the create subcommand and its options
```

When you are unsure about available options or correct usage for any area or subcommand, run the relevant `info` command rather than guessing.

## Authentication

- `mr user login` — prompts for username and password, stores token locally
- `mr user show` — show current logged-in user
- `mr user logout`

`mr user login` is interactive and **cannot be run by Claude** — it requires the user to type their password directly in the terminal. If a command fails with an auth error, tell the user to open their terminal and run `mr user login` themselves, then retry.

## Companies

Most commands require a company ID (the `--company` flag). Always start by listing companies if the user hasn't specified one:

```
mr companies list
```

Use the company ID (not CVR) for subsequent commands.

## Customers

```
mr customers list --company <xid>
mr customers list --company <xid> "search term"
```

```
mr customers create \
  --company <xid> \
  --name "Hans Andersen" \
  --currency DKK \
  --address1 "Markvejen 20" \
  --zip "8000" \
  --city "Aarhus" \
  --country DK \
  --lang DA \
  --payment-terms NET \
  --private
```

Required: `--name`, `--currency`, `--address1`, `--zip`, `--city`, `--country`, `--lang`, `--payment-terms`.

Key notes:
- Default is business customer. Add `--private` for private persons — omitting it silently creates a business customer instead
- `--lang`: `DA` or `EN`
- `--payment-terms`: `RUNNING_MONTH` | `NET` | `NET_CASH` | `ALREADY_PAID` — this is the type only; use `--payment-days <n>` to set the actual number of days
- For business customers, add `--cvr <number>` with the CVR number
- Electronic invoicing requires all three together: `--einvoice`, `--einvoice-type`, and `--einvoice-address`

## Invoices

Creating an invoice requires knowing the company ID, customer ID, and product type ID upfront. Gather these first before constructing the lines file.

```
# 1. Find company ID (if not known)
mr companies list

# 2. Find or create the customer
mr customers list --company <xid>
mr customers list --company <xid> "search name"

# 3. Find product type ID (required for every invoice line)
mr products product-types --company <xid>

# 3b. Find unit of measure and price (optional, for reference)
mr products list --company <xid>

# 4. Find unit of measure codes (if using quantity/price columns)
mr invoices units-of-measure --lang DA

# 5. Write the lines file, then create the invoice
mr invoices create \
  --company <xid> \
  --customer <xid> \
  --date 2026-05-07 \
  --title "Invoice title" \
  --lines /tmp/mr-lines.json \
  --lines-have-number-and-price
```

Invoices are always created in draft mode. `--title` is recommended.

Lines file (`/tmp/mr-lines.json`):

```json
[
  {
    "lineText": "Equipment rental",
    "amount": "4000",
    "numberOfUnits": 1,
    "unitOfMeasureCode": "DAY",
    "priceEach": "4000",
    "productTypeXid": 5412592426
  }
]
```

Rules:
- Always use `productTypeXid` — never `productXid` alone
- `amount` is always required, even when `priceEach × numberOfUnits` equals it
- `productTypeXid` is a number, not a string
- Use `--lines-have-number-and-price` when lines have quantity and unit price to show those columns on the printed invoice

**Writing the lines file — follow these steps exactly, in order:**
1. Use the **Read tool** to read `/tmp/mr-lines.json` — do this whether or not the file exists, ignoring any error if it does not
2. Use the **Write tool** (NOT Bash, NOT cat, NOT heredoc) to write the JSON to `/tmp/mr-lines.json` — always use this absolute path, never a relative path
3. Run the `mr invoices create` command via Bash as a separate step

Never combine the file write and the mr command into a single Bash call. Never use a different filename.

Optional line fields: `lineNote`, `numberOfUnits`, `unitOfMeasureCode`, `priceEach`.

Other flags: `--credit-note`, `--offer`, `--reverse-charge`, `--lines-have-product-id`.

## Products

```
mr products list --company <xid>
mr products product-types --company <xid>
```

`mr products product-types` gives the `productTypeXid` required on every invoice line — this is NOT the same as the product's own ID from `mr products list`.

`mr products list` shows product ID, name, unit of measure, and price — use it to look up pricing and units, but you still need `product-types` for the `productTypeXid`.

## Bank

```
mr bank accounts --company <xid>
mr bank balances --company <xid>
mr bank postings --company <xid> --account <xid>
mr bank postings --company <xid> --account <xid> --from 2026-01-01 --to 2026-03-31
```

## General guidance

- Always confirm the company with the user if it's ambiguous.
- Inform the user that invoices are created as drafts and must be finalised in the web UI.
- The lines JSON file is always written to `/tmp/mr-lines.json`.
- If `mr` is not found, tell the user the plugin binary may not have downloaded yet and to restart their Claude Code session.
