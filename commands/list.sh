#!/bin/bash
# List all worktrees
set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/help.sh"

# Show help
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat <<EOF
Usage: git wt list [OPTIONS...]
       git wt ls [OPTIONS...]

List all git worktrees for the current repository. (ls is an alias for list)

Options:
EOF
    get_gtr_options "list"
    format_option "-h" "--help" "" "Show this help message"
    exit 0
fi

exec git gtr list "$@"
