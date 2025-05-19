# BTC Rate CLI

A Bash-based CLI tool to interact with Bitcoin price data via the CoinGecko API.

## Features

- ✅ Show current BTC rates in one or more fiat currencies
- ✅ Convert BTC or sats to fiat
- ✅ Convert fiat to BTC and sats
- ✅ Get historical BTC price for a specific date
- ✅ Supports comma-separated fiat currencies (with or without spaces)
- ✅ Proper number formatting with commas
- ✅ Logs all actions to `btc_rate.log`

---

## Usage

Make the script executable:

```bash
chmod +x btc_rate.sh
./btc_rate.sh
```

---

## Menu Options

### 1. Show BTC Rates

Enter fiat currency/currencies (e.g. `usd`, `usd, mxn, eur`) and get the latest BTC price.

**Example:**
```
Enter fiat currency (e.g. USD): usd, mxn
BTC in USD: 105,085
BTC in MXN: 2,036,153
```

---

### 2. Convert BTC/sats to Fiat

Converts your BTC or satoshis to fiat currencies.

**Example:**
```
Enter amount (e.g. 0.01 or 50000): 0.03
Is this in BTC or sats? btc
Enter fiat currency (e.g. USD): usd, mxn
0.03 BTC = 3,152.55 USD
0.03 BTC = 61,084.59 MXN
```

---

### 3. Convert Fiat to BTC/sats

Convert fiat to BTC and sats.

**Example:**
```
Enter amount: 1000
Enter fiat currency (e.g. USD): usd
1000 USD = 0.009517 BTC = 951,700 sats
```

---

### 4. BTC Historical Price by Date

Shows BTC price for a given date and fiat currency. (History limited by CoinGecko's API)

**Example:**
```
Enter date (YYYY-MM-DD): 2024-10-05
Enter fiat currency (e.g. USD): usd
BTC price on 2024-10-05: 62,103.01 USD
```

---

## Logging

All actions are logged with timestamps to `btc_rate.log`.

---

## Requirements

- `jq`
- `awk`
- `curl`

Make sure all are installed for full functionality.