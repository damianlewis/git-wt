# git-wt

A git worktree helper that simplifies worktree management by automatically assigning random names for easy identification.

## Overview

`git-wt` is a wrapper around [git-gtr](https://github.com/coderabbitai/git-worktree-runner) that adds automatic random name generation for worktrees. Instead of thinking up branch names, just run `git wt add` and get a memorable name like `swift-falcon`, `golden-harbor`, or `misty-canyon`.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/damianlewis/git-wt.git ~/.git-wt
   ```

2. Add the `bin` directory to your PATH:
   ```bash
   export PATH="$HOME/.git-wt/bin:$PATH"
   ```

3. Ensure [git-gtr](https://github.com/coderabbitai/git-worktree-runner) is installed and available in your PATH.

## Usage

```bash
git wt <command> [options]
```

### Commands

#### add

Add a new worktree with an auto-generated random name:

```bash
git wt add                    # Creates worktree with random name (e.g., swift-falcon)
git wt add my-feature         # Creates worktree named "my-feature"
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
git wt remove swift-falcon
git wt rm swift-falcon        # Alias for remove
```

If you're inside a worktree, the command will detect it and guide you to run from the main repository.

#### move (mv)

Rename a worktree and its branch:

```bash
git wt move swift-falcon bold-cedar
git wt mv swift-falcon bold-cedar   # Alias for move
```

If you're inside a worktree, only the new name is needed:

```bash
git wt move bold-cedar           # Renames current worktree to "bold-cedar"
```

#### reset-names

Clear the name history, making all names available again:

```bash
git wt reset-names
```

## How It Works

- Generates random adjective-noun names (e.g., `swift-falcon`, `misty-canyon`)
- 400 adjectives × 400 nouns = 160,000 unique combinations
- Tracks used names globally in `~/.config/git-wt/used-names` so names are never reused, even after worktrees are deleted
- Use `git wt reset-names` to clear the history if needed

## Requirements

- Bash 4.0+
- [git-gtr](https://github.com/coderabbitai/git-worktree-runner)

## License

MIT
