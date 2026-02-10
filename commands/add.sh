#!/bin/bash
# Add a new worktree with random city name
set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/help.sh"
source "$SCRIPT_DIR/lib/cities.sh"

# Show help
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat <<EOF
Usage: git wt add [<branch>] [OPTIONS...]

Add a new git worktree. If no branch name is provided, a random city name
is generated automatically.

Options:
EOF
    get_gtr_options "new"
    format_option "-h" "--help" "" "Show this help message"
    exit 0
fi

# Check if a branch name (positional argument) is present in the args
has_branch_name() {
    local skip_next=false

    for arg in "$@"; do
        if $skip_next; then
            skip_next=false
            continue
        fi

        case "$arg" in
            --from|--track|--name|--folder)
                skip_next=true
                ;;
            --from-current|--no-copy|--no-fetch|--yes|--force|-e|--editor|-a|--ai)
                ;;
            -*)
                ;;
            *)
                return 0
                ;;
        esac
    done

    return 1
}

args=("$@")

if ! has_branch_name "${args[@]+"${args[@]}"}"; then
    city=$(random_city) || exit 1
    echo "Using random city: $city"
    args=("$city" "${args[@]+"${args[@]}"}")
fi

exec git gtr new "${args[@]}"
