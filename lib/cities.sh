#!/usr/bin/env bash

# Random city name generation for git-wt worktrees

# World cities for random worktree names (lowercase, single-word)
CITIES=(
    # Africa
    accra addis algiers cairo casablanca dakar harare kampala kigali lagos
    lusaka maputo nairobi rabat tunis
    # Asia
    amman ankara baghdad baku bangkok beijing busan chengdu chennai colombo
    delhi dhaka dubai hanoi jakarta jeddah kabul karachi kathmandu kolkata
    kuala kyoto lahore manila mumbai osaka seoul shanghai shenzhen singapore
    taipei tehran tokyo ulaanbaatar yangon
    # Europe
    amsterdam athens barcelona belgrade berlin bern brussels bucharest
    budapest copenhagen dublin edinburgh florence geneva glasgow helsinki
    istanbul kyiv lisbon london madrid marseille milan minsk moscow munich
    naples oslo paris prague riga rome sofia stockholm tallinn vienna
    vilnius warsaw zagreb zurich
    # North America
    atlanta boston calgary chicago dallas denver detroit edmonton houston
    lasvegas miami montreal nashville newyork ottawa phoenix portland
    quebec sandiego seattle toronto vancouver
    # Oceania
    adelaide auckland brisbane canberra christchurch darwin hobart melbourne
    perth sydney wellington
    # South America
    asuncion bogota brasilia buenosaires caracas guayaquil lapaz lima
    medellin montevideo quito recife santiago saopaulo
)

# Get names of existing worktrees
get_existing_worktrees() {
    git gtr list --porcelain 2>/dev/null | \
        awk '{print $1}' | \
        xargs -I{} basename {} 2>/dev/null || true
}

# Get list of available (unused) cities
get_available_cities() {
    local existing
    existing=$(get_existing_worktrees)

    for city in "${CITIES[@]}"; do
        if ! echo "$existing" | grep -qx "$city"; then
            echo "$city"
        fi
    done
}

# Pick a random available city
random_city() {
    local available
    available=($(get_available_cities))

    if [[ ${#available[@]} -eq 0 ]]; then
        echo "Error: All city names are in use. Consider removing some worktrees." >&2
        return 1
    fi

    local index=$((RANDOM % ${#available[@]}))
    echo "${available[$index]}"
}
