#!/bin/bash
# Remove a worktree with auto-detection
set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/help.sh"

# Show help
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat <<EOF
Usage: git wt remove [<worktree>] [OPTIONS...]
       git wt rm [<worktree>] [OPTIONS...]

Remove a git worktree. (rm is an alias for remove)

If no worktree name is provided and you're inside a worktree, the script
will detect the name and guide you to run the command from the main repo.

Options:
EOF
    get_gtr_options "rm"
    format_option "-h" "--help" "" "Show this help message"
    cat <<EOF

Note: Run this command from the main repository, not from inside the
worktree you want to remove.
EOF
    exit 0
fi

# Get the main repository path
get_main_repo() {
    git worktree list 2>/dev/null | head -1 | awk '{print $1}'
}

# Detect if we're in a worktree and get its name
detect_worktree_name() {
    local main_worktree
    main_worktree=$(get_main_repo)

    local current_dir
    current_dir=$(pwd)

    if [[ -n "$main_worktree" && "$current_dir" != "$main_worktree" ]]; then
        basename "$current_dir"
    else
        echo ""
    fi
}

# Find worktree name in args
find_worktree_name() {
    for arg in "$@"; do
        case "$arg" in
            -*)
                ;;
            *)
                echo "$arg"
                return 0
                ;;
        esac
    done
    echo ""
}

main_repo=$(get_main_repo)
if [[ -z "$main_repo" ]]; then
    echo "Error: Could not determine main repository path" >&2
    exit 1
fi

worktree=$(find_worktree_name "$@")

if [[ -z "$worktree" ]]; then
    worktree=$(detect_worktree_name)
    if [[ -z "$worktree" ]]; then
        echo "Error: No worktree name provided" >&2
        echo "Usage: git wt remove <worktree-name>" >&2
        exit 1
    fi
    echo "Detected worktree: $worktree" >&2
    echo "Error: Cannot remove worktree while inside it" >&2
    echo "" >&2
    echo "Run these commands:" >&2
    echo "  cd $main_repo" >&2
    echo "  git wt remove $worktree" >&2
    exit 1
fi

(cd "$main_repo" && exec git gtr rm "$@")
