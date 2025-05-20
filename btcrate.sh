#!/bin/bash

COINGECKO_API="https://api.coingecko.com/api/v3"
LOGFILE="btc_rate.log"

log() {
    echo "$1" | tee -a "$LOGFILE"
}

log "--------------------------------------"
log "Welcome to BTC Rate CLI"
log "Run at: $(date)"
echo "1) Show BTC rates"
echo "2) Convert BTC/sats to fiat"
echo "3) Convert fiat to BTC/sats"
echo "4) BTC historical price by date"
read -p "Enter choice: " choice

case $choice in
    1)
        read -p "Enter fiat currency (e.g. USD or USD, MXN): " fiat_input
        fiat_input=$(echo "$fiat_input" | tr '[:upper:]' '[:lower:]' | tr -d ' ')
        response=$(curl -s "$COINGECKO_API/simple/price?ids=bitcoin&vs_currencies=$fiat_input")
        log "BTC in $fiat_input: $response"
        echo "$response" | jq
        ;;
    2)
        read -p "Enter amount (e.g. 0.01 or 50000): " amount
        read -p "Is this in BTC or sats? " unit
        read -p "Enter fiat currency (e.g. USD or USD, MXN): " fiat_input
        fiat_input=$(echo "$fiat_input" | tr '[:upper:]' '[:lower:]' | tr -d ' ')
        IFS=',' read -ra fiat_list <<< "$fiat_input"

        if [[ "$unit" == "sats" ]]; then
            btc=$(awk "BEGIN {printf \"%.8f\", $amount / 100000000}")
        elif [[ "$unit" == "btc" ]]; then
            btc=$amount
        else
            log "Invalid unit: $unit"
            exit 1
        fi

        for fiat in "${fiat_list[@]}"; do
            rate=$(curl -s "$COINGECKO_API/simple/price?ids=bitcoin&vs_currencies=$fiat" | jq -r ".bitcoin.$fiat")
            if [[ "$rate" == "null" || -z "$rate" ]]; then
                log "Could not fetch rate for $fiat"
            else
                fiat_upper=$(echo "$fiat" | tr '[:lower:]' '[:upper:]')
                fiat_value=$(awk "BEGIN {printf \"%.2f\", $btc * $rate}")
                log "$btc BTC = $fiat_value $fiat_upper"
            fi
        done
        ;;
    3)
        read -p "Enter amount: " amount
        read -p "Enter fiat currency (e.g. USD): " fiat
        fiat=$(echo "$fiat" | tr '[:upper:]' '[:lower:]' | tr -d ' ')
        rate=$(curl -s "$COINGECKO_API/simple/price?ids=bitcoin&vs_currencies=$fiat" | jq -r ".bitcoin.$fiat")

        if [[ "$rate" == "null" || -z "$rate" ]]; then
            log "Could not fetch rate for $fiat"
            exit 1
        fi

        btc=$(awk "BEGIN {printf \"%.8f\", $amount / $rate}")
        sats=$(awk "BEGIN {printf \"%.0f\", $btc * 100000000}")
        log "$amount $fiat = $btc BTC = $sats sats"
        ;;
    4)
        read -p "Enter date (YYYY-MM-DD): " date
        read -p "Enter fiat currency (e.g. USD or USD, MXN): " fiat_input
        fiat_input=$(echo "$fiat_input" | tr '[:upper:]' '[:lower:]' | tr -d ' ')
        formatted_date=$(date -d "$date" '+%d-%m-%Y' 2>/dev/null)

        if [[ -z "$formatted_date" ]]; then
            log "Invalid date format."
            exit 1
        fi

        IFS=',' read -ra fiat_list <<< "$fiat_input"
        for fiat in "${fiat_list[@]}"; do
            result=$(curl -s "$COINGECKO_API/coins/bitcoin/history?date=$formatted_date" | jq -r ".market_data.current_price.$fiat")
            if [[ "$result" == "null" || -z "$result" ]]; then
                log "No data found for $date in $fiat"
            else
                formatted_result=$(awk "BEGIN {printf \"%.2f\", $result}")
                log "BTC price on $date: $formatted_result $fiat"
            fi
        done
        ;;
    *)
        log "Invalid choice"
        ;;
esac
