# Campaign Desk v0.4.1 Half-Life Fix — first run

Campaign Desk is a local accounting ledger for IBKR stock and option campaigns. TWS remains the place for live prices, Greeks, the watchlist and order entry. Campaign Desk keeps the history that is easy to lose across rolls: credits, debits, stock capital, fees, basis improvements and lifetime campaign P/L.

The main application and accounting engine are .NET 10. A small localhost Python adapter reads TWS. There is no order-placement endpoint.

## What v0.4 adds

- Lifetime campaign accounting and a separate current-expiry cycle.
- Net option premium, stock cashflow/capital, commissions and manual adjustments as distinct categories.
- Campaign P/L calculated from the complete cash ledger plus the signed market value of current open legs.
- Roll count, cycle count and an execution timeline.
- DTE progress from the current cycle's opening date to expiry, with a single half-life marker at 50% elapsed.
- Live reconciliation of ledger quantities against TWS contract quantities.
- Automatic closed-campaign archive after TWS confirms a campaign is flat on two consecutive snapshots.
- Expiry max profit, max loss and breakevens for supported same-expiry option-only positions.
- Campaign notes and auditable manual corrections that never write to TWS.
- One-click portable ledger backup and restore. Flex credentials and raw Flex reports are excluded.
- A dedicated Campaigns page for open accounting and the closed archive.
- Reviewed IBKR Activity Flex reconstruction for up to 365 days.

Campaign Desk deliberately does not duplicate the Greeks and watchlist already displayed well in TWS.

## What v0.4.1 fixes

- Management timing now follows 50% of each campaign's own current-expiry cycle. The slider uses the cycle's opening date and opening DTE; there is no separate fixed-DTE marker or trigger.
- Campaign cards start collapsed. Cards opened manually stay open through live refreshes, and collapsing every card remains stable.

## Before starting

1. Keep TWS running and signed in.
2. In Global Configuration → API → Settings:
   - enable ActiveX and Socket Clients;
   - use socket port 7497 for the paper account used by this package;
   - keep Read-Only API enabled;
   - trust 127.0.0.1 if TWS asks.
3. Install Python 3.11 or later. The packaged .NET app needs no .NET installation.
4. The first launch needs internet once to install the three bridge packages into a private environment inside this folder.

## Start

Double-click Start-CampaignDesk.cmd. It starts the two local processes and opens:

    http://127.0.0.1:5187

The bridge uses 127.0.0.1:8766 and connects to TWS on 127.0.0.1:7497. These ports stay on the laptop; never expose the TWS socket to the internet.

Use Demo in the top-right corner to inspect the complete accounting workflow without changing local ledger data.

## Upgrading from v0.3 or v0.4.0

Close the earlier Campaign Desk first and extract v0.4.1 into a new folder.

For the first move, copy the complete old data folder into the new package before starting it. v0.4 migrates the ledger format on load and creates safety backups before writes. Once v0.4 is running, use Campaigns → Ledger backup → Export backup for future moves.

A portable backup contains campaign state, execution history, notes, corrections and archive data. It intentionally excludes the Flex token and encryption keys. Enter the Flex token again on a different Windows account or computer.

## Reconstruct Flex history

1. Open History.
2. Enter the numeric Activity Flex Query ID and Flex Web Service token locally. Never paste the token into chat, source code or screenshots.
3. Select Save & preview 365 days.
4. Review the coverage audit.
5. Select Build reconstruction.
6. Select only campaigns with an exact live-position match, tick the confirmation and synchronize them.
7. Return to Today and verify the accounting breakdown and reconciliation.

The reconstruction expires after 30 minutes. Immediately before applying, Campaign Desk verifies that the current TWS position fingerprint still matches. A mismatch blocks the write.

The Flex Query should use XML and include Trades at execution level, Open Positions at lot level, Option Exercises/Assignments/Expirations, Cash Transactions and Corporate Actions.

## How the numbers work

- Sells are positive cashflow; buys are negative.
- Option premium excludes stock principal.
- Stock capital is shown separately so a covered call does not look like a huge option debit.
- Commissions and fees are shown separately.
- Campaign P/L = all complete lifetime cashflows + signed current market value of open legs.
- TWS open-position P/L remains visible at leg level and is not mistaken for lifetime campaign P/L.
- The first live snapshot is a zero-history baseline. Campaign Desk never invents old credits from average cost.
- Flex can convert an eligible baseline into a complete historical ledger.
- IBKR execution IDs are deduplicated.
- A manual correction is an explicit, timestamped local ledger event with a required reason.

A Baseline label means old activity has not been reconstructed. Mismatch means ledger contract quantities do not agree with TWS. Matched means the current contracts reconcile.

## Using the three pages

- Today: management timing, open campaign cards and detailed roll ledgers.
- Campaigns: open accounting table, realized archive and portable backup/restore.
- History: Flex preview, reconstruction review and guarded synchronization.

## Moving between computers

The safest process is:

1. Open Campaigns and export a ledger backup ZIP.
2. Install/extract Campaign Desk on the other computer.
3. Start once, open Campaigns, then restore that ZIP.
4. Re-enter the Flex token if History is needed.
5. Connect TWS and refresh; each complete campaign should reconcile.

You may also copy the full data folder while Campaign Desk is closed. Never copy it while the application is writing.

## Troubleshooting

- Cannot connect to TWS: recheck port 7497, the API checkbox, Read-Only API and the TWS login.
- Client ID already in use: close another local IBKR bridge using client ID 91.
- Python was not found: install Python 3.11+ from python.org and enable Add Python to PATH. Disable the Microsoft Store execution alias if it intercepts the python command.
- Bridge did not start: inspect runtime\bridge-error.log. TWS should remain on port 7497.
- Browser did not open: browse to http://127.0.0.1:5187 while the launcher window remains open.
- Flex token invalid or expired: create a current token in IBKR Flex Web Service Configuration and save it again locally.
- Flex Query ID invalid: use the numeric ID beside the Activity Flex Query, not its name.
- Campaign cannot be selected in History: read its warning; Campaign Desk does not guess through position or lifecycle mismatches.
- Campaign shows Baseline: import reviewed Flex history or keep it as an honest from-now-on ledger.
- Campaign shows Mismatch: compare open quantities in the campaign with TWS before adding corrections.
- Backup restore is rejected: use an unmodified Campaign Desk backup ZIP smaller than 10 MB.

## Rebuilding the source

The source folder contains the .NET server, React/TypeScript client, Python bridge and tests. With .NET 10 SDK, Node.js and Python installed, run scripts\Build-Windows.ps1 from PowerShell. Windows output is written to publish\win-x64.
