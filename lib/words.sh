#!/usr/bin/env bash

# Random adjective-noun name generation for git-wt worktrees

# 400 adjectives — short, evocative, git-branch-safe
ADJECTIVES=(
    # Colors & light
    amber ashen auburn azure beige black blond blue brass bronze burnt cerulean
    charcoal cherry chestnut chrome cobalt copper coral cream crimson cyan dark
    dusk ebony emerald faded flame flaxen frosty gilt gold golden gray green
    grey hazel honey indigo ivory jade jet lavender lemon lilac lunar maroon
    midnight mint moonlit navy neon ocher olive onyx opal orange orchid pale
    peach pearl pewter pink plum primrose purple red rose rosy ruby russet
    rust rusty sable saffron sage sapphire scarlet sepia shadow silver
    slate smoky tan tawny teal umber violet white yellow
    # Texture & shape
    angular barbed bent blunt braided bristled broad carved chipped coarse
    coiled cracked curved dappled dense dimpled dusty edged etched feathered
    fibrous fine flat fluted forked frayed gnarled grainy grooved hammered
    jagged knotted layered lean lined lumpy matted narrow notched
    pebbled pliant polished porous ribbed ridged ringed rippled rough rugged
    sculpted serrated sharp sheer silken sleek slim smooth speckled spiny
    split steep stiff stout stranded tapered thick thin thorny tight trimmed
    twisted uneven veined waxed weathered wiry woven
    # Mood & character
    bitter blissful bold brave bright brisk calm cheerful chill clear clever
    cold cool cozy daring deft dire dreamy eager earnest eerie faint fervent
    fierce fiery fond frantic free fresh gentle giddy glib gloomy graceful
    grand grave grim hale happy harsh hasty heavy humble hushed idle jolly
    joyful kind lively lone lost lucid meek merry mild noble patient
    placid plucky proud pure quaint quick quiet rare regal restless
    rich serene shrewd shy sly smug solemn somber sour spartan steady stern
    still stoic strong subtle sure tender tepid terse timid tired
    tough true vague vast vivid warm weary whist whole wild wise witty wry
    # Nature & weather
    alpine arid boreal breezy briny cloudy coastal dewy drifting dry dusky
    earthy foggy frozen glacial gusty hazy humid icy leafy lush marshy misty
    mossy muddy polar rainy shady solar stormy sultry sunny
    swampy tidal tropic verdant wintry windy woody
    # Size, speed & intensity
    ample brief brittle bulky compact covert cryptic dainty deep dwarf elfin
    epic feeble fleet frail gaunt giant gleaming gruff hefty immense lanky
    light lithe little long lusty meager nimble petite plump prime robust scant
    short slight small snug spare squat sturdy supple svelte tall tiny towering
    trim wee wide
    # Time & age
    aged ancient archaic bygone early elder endless eternal fleeting instant
    lasting late modern newfound olden perennial primal primeval pristine
    recent remote timeless vintage young
    # Sound & motion
    clanging crackling dashing darting droning flowing gliding humming lilting
    pulsing purring roaring rumbling singing soaring swaying tapping ticking
    wailing
)

# 400 nouns — short, concrete, git-branch-safe
NOUNS=(
    # Animals
    adder badger bat bear beetle bison bluebird bobcat buck bull bunny buzzard
    cardinal catfish chameleon cheetah clam cobra condor cougar coyote crane
    cricket crow curlew deer dolphin donkey dove dragon eagle eel egret elk
    ermine falcon ferret finch firefly flamingo fox frog gazelle gecko gerbil
    gibbon goat goose goshawk grouse gull hare hawk hedgehog heron hornet
    hound ibis iguana jackal jaguar jay kestrel kingfish kite koala lark lemur
    leopard limpet lion lizard llama lobster locust loon lynx macaw magpie
    mako mantis marlin marmot martin merlin mink mole mongoose moose moth
    mussel newt nightjar ocelot osprey otter owl oyster panther parrot peacock
    pelican penguin perch pigeon pike piper piranha plover pony porcupine
    puffin python quail rabbit raven redwing reindeer robin rooster salmon
    sandpiper seahorse shark shrike skunk snail snake sparrow squid stag
    starling stingray stork swift tern thrush tiger toad tortoise toucan trout
    turtle viper vulture walrus warbler wasp weasel whale wolf wombat woodlark
    wren yak zebra
    # Landscape & places
    arch basin bay beacon bluff bog boulder brook butte canal canyon cape cave
    channel chasm cliff coast cove crater creek crest dale delta den dune
    estuary falls fen fjord forest gap geyser glacier glen gorge grotto grove
    gulf gulch harbor haven heath highland hollow inlet island isthmus jungle
    knoll lagoon lake landing ledge levee marsh meadow mesa moor mound oasis
    ocean outcrop pass peak peninsula pier plain plateau pond prairie ravine
    reef ridge rift river shore sierra slope spring steppe strait stream summit
    swamp terrace tide timber trail tundra vale valley volcano waterfall
    # Objects & artifacts
    anchor anvil arrow axle banner barrel beacon bell blade bolt bow braid
    bridge bristle brooch buckle bugle cable candle cannon chain chalice chisel
    clasp claw cleat coil comb compass cork cradle crown crystal cymbal dagger
    dart dial drum fable feather fiddle flagon flask flint forge fossil funnel
    gavel gem girder goblet gong grain grail hammer harp harness hatchet helm
    hinge hook horn jewel kettle kiln kindle knot lace ladder lamp lance latch
    lathe lens lever locket loom mallet marble mirror mortar mural oar paddle
    pedal pestle pillar plume prism pulley quartz quill rafter reed relic rivet
    rune saddle scepter scroll seal sheath shield sickle signet siren sled
    spindle spoke spool spyglass stake steeple sundial tablet talon thorn
    timber token trellis trident trinket valve vane vault wedge windmill
    # Nature & elements
    acorn bark birch bloom blossom bramble briar cedar clover cypress fern
    heather ivy lichen maple moss nettle oak orchid petal pine sequoia
    spruce willow
)

# Get names of existing worktrees
get_existing_worktrees() {
    git gtr list --porcelain 2>/dev/null | \
        awk '{print $1}' | \
        xargs -I{} basename {} 2>/dev/null || true
}

# Get the history file path
get_history_file() {
    local dir="$HOME/.config/git-wt"
    mkdir -p "$dir"
    echo "$dir/used-names"
}

# Read used names from history file
get_used_names() {
    local history_file
    history_file=$(get_history_file)
    if [[ -f "$history_file" ]]; then
        cat "$history_file"
    fi
}

# Record a name as used
record_name() {
    local name="$1"
    local history_file
    history_file=$(get_history_file)
    echo "$name" >> "$history_file"
}

# Pick a random unique adjective-noun name
random_name() {
    local excluded
    excluded=$({ get_used_names; get_existing_worktrees; } | sort -u)

    local max_attempts=100
    local attempt=0

    while (( attempt < max_attempts )); do
        local adj_index=$((RANDOM % ${#ADJECTIVES[@]}))
        local noun_index=$((RANDOM % ${#NOUNS[@]}))
        local name="${ADJECTIVES[$adj_index]}-${NOUNS[$noun_index]}"

        if ! echo "$excluded" | grep -qx "$name"; then
            record_name "$name"
            echo "$name"
            return 0
        fi

        ((attempt++))
    done

    echo "Error: Could not generate a unique name after $max_attempts attempts." >&2
    echo "Run 'git wt reset-names' to clear the history." >&2
    return 1
}
