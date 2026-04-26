#!/bin/bash
# Print a random worktree name without creating a worktree
set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/help.sh"
source "$SCRIPT_DIR/lib/words.sh"

# Show help
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat <<EOF
Usage: git wt name

Print a random adjective-noun name, reserved against the history of
previously-used names. Useful for scripting workflows that need to
know the name before calling 'git wt add'.

Options:
    -h, --help              Show this help message
EOF
    exit 0
fi

random_name
