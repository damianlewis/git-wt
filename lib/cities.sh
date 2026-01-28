#!/usr/bin/env bash

# Random city name generation for git-wt worktrees

# World cities for random worktree names (lowercase, single-word)
CITIES=(
    # Africa
    abidjan abuja accra addis algiers antananarivo bamako bengazi blantyre
    cairo capetown casablanca conakry dakar douala durban freetown gaborone
    harare johannesburg kampala khartoum kigali kinshasa lagos lilongwe
    lome luanda lusaka luxor maputo marrakech mombasa nairobi ndola oran
    ouagadougou portlouis pretoria rabat tangier tripoli tunis windhoek
    # Asia
    ahmedabad almaty amman ankara astana baghdad baku bangalore bangkok
    beijing bengaluru bishkek busan cebu changsha chengdu chennai chittagong
    chongqing colombo delhi dhaka dushanbe guangzhou guilin hangzhou hanoi
    hiroshima hochiminhcity hongkong hyderabad incheon islamabad istanbul
    jakarta jaipur jeddah jerusalem kabul karachi kathmandu kochi kolkata
    kualalumpur kuwait kyoto lahore lucknow macau makassar malacca mandalay
    manila mecca medina mumbai muscat nagoya nagpur nanjing osaka peshawar
    phnom pune phuket pyongyang qingdao quezon riyadh saigon sapporo seoul
    shanghai shenzhen singapore surabaya surat taipei tashkent tbilisi tehran
    tianjin tokyo ulaanbaatar vientiane wuhan xian yangon yerevan yokohama
    # Europe
    amsterdam antwerp athens barcelona basel belfast belgrade bergen berlin
    bern bilbao birmingham bologna bordeaux bratislava bremen bristol bruges
    brussels bucharest budapest cardiff cologne copenhagen cork cracow dublin
    dusseldorf edinburgh eindhoven essen florence frankfurt gdansk geneva
    genoa ghent glasgow gothenburg graz hamburg hannover helsinki innsbruck
    krakow leeds leipzig liege lille lisbon liverpool ljubljana london
    luxembourg lyon madrid malaga manchester marseille milan minsk monaco
    moscow munich nantes naples nice nicosia nuremberg oslo palermo paris
    porto prague reykjavik riga rome rotterdam salzburg sarajevo seville
    sofia split stockholm strasbourg stuttgart tallinn thessaloniki toulouse
    turin valencia valletta venice verona vienna vilnius warsaw wroclaw
    zagreb zaragoza zurich
    # North America
    albuquerque anchorage atlanta austin baltimore boston calgary charlotte
    chicago cincinnati cleveland columbus dallas denver detroit edmonton
    elpaso fortworth guadalajara halifax hamilton havana honolulu houston
    indianapolis jacksonville kansascity kingston lasvegas louisville memphis
    mexicocity miami milwaukee minneapolis mississauga monterrey montreal
    nashville neworleans newyork oakland oklahoma omaha orlando ottawa
    philadelphia phoenix pittsburgh portland puebla raleigh sacramento
    saltlake sanantonio sandiego sanfrancisco sanjose sanjuan seattle
    stlouis tampa tijuana toronto tucson tulsa vancouver vegas victoria
    winnipeg
    # Oceania
    adelaide auckland brisbane cairns canberra christchurch darwin dunedin
    geelong goldcoast hamilton hobart melbourne newcastle perth queenstown
    sunshine suva sydney tauranga townsville waikato wellington
    # South America
    arequipa asuncion barranquilla belem belo bogota brasilia bucaramanga
    buenosaires cali callao caracas cartagena cordoba curitiba cusco
    florianopolis fortaleza georgetown guayaquil lapaz lima manaus maracaibo
    medellin mendoza montevideo paramaribo portoalegre quito recife rio
    rosario salvador santacruz santiago santodomingo saopaulo sucre
    valparaiso
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
