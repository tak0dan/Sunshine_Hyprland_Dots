#!/usr/bin/env bash

pluralize() {
    local value="$1"
    local singular="$2"
    local plural="$3"

    if (( value == 1 )); then
        printf "%s %s" "$value" "$singular"
    else
        printf "%s %s" "$value" "$plural"
    fi
}

color() {
    local code="$1"
    shift
    printf '\033[%sm%s\033[0m' "$code" "$*"
}

JSON="$HOME/.config/fastfetch/custom-info.json"

if [[ ! -f "$JSON" ]]; then
    printf '%s\n' "$(color "35" "│ └󰅙 Missing custom-info.json")"
    exit 1
fi

# Parse JSON using Python (no jq dependency)
mapfile -t entries < <(python3 -c "
import json, sys
try:
    with open('$JSON') as f:
        data = json.load(f)
    for entry in data.get('entries', []):
        print(f\"{entry.get('title', '')}|{entry.get('since', '')}\")
except Exception as e:
    print(f'ERROR|{e}', file=sys.stderr)
    sys.exit(1)
" 2>&1)

if [[ ${#entries[@]} -eq 0 ]]; then
    printf '%s\n' "$(color "35" "│ └󰅙 No entries found")"
    exit 0
fi

for index in "${!entries[@]}"; do
    line="${entries[$index]}"
    IFS='|' read -r title since <<< "$line"

    [[ -z "$title" || -z "$since" ]] && continue

    if ! start=$(date -d "$since" +%s 2>/dev/null); then
        duration="invalid date"
    else
        now=$(date +%s)
        days=$(( (now - start) / 86400 ))

        if (( days < 30 )); then
            duration="$(pluralize "$days" "day" "days")"
        elif (( days < 365 )); then
            months=$((days / 30))
            duration="$(pluralize "$months" "month" "months")"
        else
            years=$((days / 365))
            months=$(((days % 365) / 30))
            duration="$(pluralize "$years" "year" "years")"
            if (( months > 0 )); then
                duration+=" $(pluralize "$months" "month" "months")"
            fi
        fi
    fi

    branch="├"
    detail_prefix="│"
    if (( index == ${#entries[@]} - 1 )); then
        branch="└"
        detail_prefix=" "
    fi

    printf '%s\n' "$(color "38;5;208" "│ ${branch}󰃭 $title")"
    printf '%s\n' "$(color "90" "│ ${detail_prefix} └$duration (since $since)")"
done
