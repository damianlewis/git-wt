#!/usr/bin/env bash

# Help formatting functions for git-wt scripts

# Format an option line in standard format
# Usage: format_option "short" "long" "arg" "description"
# Examples:
#   format_option "-e" "--editor" "" "Open in editor"
#   format_option "" "--from" "<ref>" "Create from ref"
format_option() {
    local short="$1"
    local long="$2"
    local arg="$3"
    local desc="$4"

    local option=""
    if [ -n "$short" ] && [ -n "$long" ]; then
        option="$short, $long"
    elif [ -n "$short" ]; then
        option="$short"
    else
        option="$long"
    fi

    if [ -n "$arg" ]; then
        option="$option $arg"
    fi

    printf "    %-24s%s\n" "$option" "$desc"
}

# Extract and reformat options from gtr help for a command
# Usage: get_gtr_options <command>
get_gtr_options() {
    local cmd="$1"
    local in_options=0

    git gtr help 2>/dev/null | while IFS= read -r line; do
        # Start capturing when we hit the command
        if [[ "$line" =~ ^"  $cmd " ]] || [[ "$line" =~ ^"  $cmd|" ]]; then
            in_options=1

            # Parse inline options from the command line itself (e.g., "list [--porcelain]")
            # Extract all [--option] patterns
            local remaining="$line"
            while [[ "$remaining" =~ \[--([a-zA-Z-]+)\] ]]; do
                local opt="${BASH_REMATCH[1]}"
                format_option "" "--$opt" "" ""
                # Remove the matched pattern to continue searching
                remaining="${remaining#*\[--$opt\]}"
            done

            continue
        fi

        # Stop at empty line or next command
        if [ "$in_options" -eq 1 ]; then
            if [ -z "$line" ] || [[ "$line" =~ ^"  "[a-z] ]]; then
                break
            fi

            # Parse option lines (they contain --)
            if [[ "$line" =~ -- ]]; then
                # Remove leading whitespace
                line="${line#"${line%%[![:space:]]*}"}"

                # Parse format: "-s, --long <arg>: description" or "--long: description"
                local short="" long="" arg="" desc=""

                # Extract description (after colon with space)
                if [[ "$line" == *": "* ]]; then
                    desc="${line#*: }"
                    line="${line%%: *}"
                fi

                # Extract short option (-e, --editor format)
                if [[ "$line" =~ ^(-[a-zA-Z]),\ +(--[a-zA-Z-]+) ]]; then
                    short="${BASH_REMATCH[1]}"
                    long="${BASH_REMATCH[2]}"
                    line="${line#*$long}"
                    line="${line# }"
                    arg="$line"
                # Extract long option only
                elif [[ "$line" =~ ^(--[a-zA-Z-]+) ]]; then
                    long="${BASH_REMATCH[1]}"
                    line="${line#$long}"
                    line="${line# }"
                    arg="$line"
                fi

                format_option "$short" "$long" "$arg" "$desc"
            fi
        fi
    done
}

# Format an example line
# Usage: format_example "command" "description"
format_example() {
    local cmd="$1"
    local desc="$2"
    printf "    %-36s# %s\n" "$cmd" "$desc"
}
