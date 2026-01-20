# git-wt

A git worktree helper that simplifies worktree management by automatically assigning random city names for easy identification.

## Overview

`git-wt` is a wrapper around [git-gtr](https://github.com/nicholasdille/git-gtr) that adds automatic random city name generation for worktrees. Instead of thinking up branch names, just run `git wt add` and get a memorable city name like `tokyo`, `paris`, or `seattle`.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/wt-scripts.git ~/.git-wt
   ```

2. Add the `bin` directory to your PATH:
   ```bash
   export PATH="$HOME/.git-wt/bin:$PATH"
   ```

3. Ensure [git-gtr](https://github.com/nicholasdille/git-gtr) is installed and available in your PATH.

## Usage

```bash
git wt <command> [options]
```

### Commands

#### add

Add a new worktree with an auto-generated random city name:

```bash
git wt add                    # Creates worktree with random city name
git wt add tokyo              # Creates worktree named "tokyo"
git wt add --from main        # Creates from specific branch
```

#### list (ls)

List all worktrees:

```bash
git wt list
git wt ls                     # Alias for list
```

#### remove (rm)

Remove a worktree:

```bash
git wt remove tokyo
git wt rm tokyo               # Alias for remove
```

If you're inside a worktree, the command will detect it and guide you to run from the main repository.

## How It Works

- Maintains a list of 100+ world city names (single-word, lowercase)
- Automatically excludes cities already in use by existing worktrees
- Falls back to manual naming if all cities are exhausted

## Requirements

- Bash 4.0+
- [git-gtr](https://github.com/nicholasdille/git-gtr)

## License

MIT
