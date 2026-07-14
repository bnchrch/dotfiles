# Ben's macOS dotfiles

This repository describes the reproducible part of the workstation: Homebrew
packages and applications, Zsh and Vim configuration, mise-managed runtimes,
GitHub CLI preferences, and Cursor extensions.

It intentionally does not contain credentials, SSH private keys, browser or app
sessions, 1Password data, Raycast exports, or macOS privacy approvals.

## First-time setup

Install Homebrew from [brew.sh](https://brew.sh), then clone this repository:

```sh
git clone https://github.com/bnchrch/dotfiles.git ~/development/repos/personal/dotfiles
cd ~/development/repos/personal/dotfiles
```

Preview the files that would be linked:

```sh
./bootstrap.zsh --check
```

Apply the setup:

```sh
./bootstrap.zsh --apply
```

Apply mode installs missing Homebrew dependencies without upgrading installed
software. Existing managed files are moved to
`~/.dotfiles-backup/<timestamp>/` before symlinks are created.

## What is managed

- `Brewfile`: command-line tools and macOS applications
- `.zprofile`: Homebrew and OrbStack login-shell initialization
- `.zshrc`: Oh My Zsh, Warp-friendly prompt behavior, Cursor, history, aliases,
  and mark/jump navigation
- `.vimrc`: lightweight Vim defaults
- `.config/mise/config.toml`: Node LTS, Bun, pnpm, Vercel, and Wrangler
- `.config/gh/config.yml`: GitHub CLI preferences without authentication data
- `cursor-extensions.txt`: Cursor extension identifiers

## Manual checklist

Package installation cannot restore application accounts or macOS privacy
permissions. After bootstrap:

1. Sign in to 1Password and enable any desired SSH-agent integration.
2. Sign in to GitHub, Slack, Notion, Superhuman, Granola, Claude, Loom, Spotify,
   and the configured browsers.
3. Grant Accessibility permissions to Raycast, AltTab, and Rectangle Pro when
   macOS requests them.
4. Start OrbStack and confirm `docker context show` reports `orbstack`.
5. Confirm Atlas remains the default browser and Cursor remains the editor.
6. Restore Git identities and signing configuration without copying private keys
   into this repository.

## Validation

```sh
brew bundle check --no-upgrade --file Brewfile
zsh -n .zshrc .zprofile bootstrap.zsh
MISE_CONFIG_FILE="$PWD/.config/mise/config.toml" mise current
```

Verify the shell in a new Warp window:

```sh
node --version
bun --version
pnpm --version
vercel --version
wrangler --version
```

## Updating

Keep the Brewfile curated rather than replacing it with an unreviewed package
dump. Compare the current machine with:

```sh
brew leaves
brew list --cask
brew bundle check --no-upgrade --file Brewfile
```

Refresh the Cursor extension list with:

```sh
cursor --list-extensions | sort > cursor-extensions.txt
```

Homebrew is rolling-release software. Upgrade intentionally with
`brew bundle upgrade --file Brewfile`; normal bootstrap runs do not upgrade
existing software.
