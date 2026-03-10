#!/bin/bash
# Reset the used names history
set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/help.sh"
source "$SCRIPT_DIR/lib/words.sh"

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat <<EOF
Usage: git wt reset-names [OPTIONS...]

Reset the name history, making all names available again.
Names currently in use by active worktrees will remain unavailable.

Options:
EOF
    format_option "-h" "--help" "" "Show this help message"
    exit 0
fi

history_file=$(get_history_file)

if [[ -f "$history_file" ]]; then
    rm "$history_file"
    echo "Name history cleared."
else
    echo "No name history found. Nothing to reset."
fi
