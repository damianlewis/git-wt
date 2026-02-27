#!/bin/bash
# Move (rename) a worktree with auto-detection
set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/help.sh"

# Show help
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat <<EOF
Usage: git wt move <old> <new> [OPTIONS...]
       git wt mv <old> <new> [OPTIONS...]

Rename a git worktree and its branch. (mv is an alias for move)

If only one name is provided and you're inside a worktree, the current
worktree is used as the source.

Options:
EOF
    get_gtr_options "mv"
    format_option "-h" "--help" "" "Show this help message"
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

# Count positional arguments (non-flag args)
count_positional_args() {
    local count=0

    for arg in "$@"; do
        case "$arg" in
            -*)
                ;;
            *)
                count=$((count + 1))
                ;;
        esac
    done

    echo "$count"
}

main_repo=$(get_main_repo)
if [[ -z "$main_repo" ]]; then
    echo "Error: Could not determine main repository path" >&2
    exit 1
fi

positional_count=$(count_positional_args "$@")

# If only one positional arg, auto-detect current worktree as the source
if [[ "$positional_count" -eq 1 ]]; then
    worktree=$(detect_worktree_name)
    if [[ -z "$worktree" ]]; then
        echo "Error: Two worktree names required when not inside a worktree" >&2
        echo "Usage: git wt move <old> <new>" >&2
        exit 1
    fi
    echo "Detected worktree: $worktree" >&2
    (cd "$main_repo" && exec git gtr mv "$worktree" "$@")
elif [[ "$positional_count" -lt 1 ]]; then
    echo "Error: New worktree name required" >&2
    echo "Usage: git wt move <old> <new>" >&2
    exit 1
else
    (cd "$main_repo" && exec git gtr mv "$@")
fi
