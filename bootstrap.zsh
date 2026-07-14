#!/bin/zsh

emulate -LR zsh
setopt err_exit no_unset pipe_fail

readonly repo_dir="${0:A:h}"
readonly mode="${1:---check}"
readonly timestamp="$(date +%Y%m%d-%H%M%S)"
readonly backup_root="$HOME/.dotfiles-backup/$timestamp"

typeset -a managed_paths=(
  ".zshrc"
  ".zprofile"
  ".vimrc"
  ".config/gh/config.yml"
  ".config/mise/config.toml"
)

usage() {
  print -- "usage: ./bootstrap.zsh [--check|--apply]"
}

if [[ "$mode" != "--check" && "$mode" != "--apply" ]]; then
  usage
  exit 64
fi

if ! command -v brew >/dev/null 2>&1; then
  print -u2 -- "Homebrew is required before running this bootstrap."
  print -u2 -- 'Install it from https://brew.sh, start a new shell, and retry.'
  exit 1
fi

print -- "Dotfiles repository: $repo_dir"
print -- "Mode: ${mode#--}"
print

for relative_path in "${managed_paths[@]}"; do
  source_path="$repo_dir/$relative_path"
  target_path="$HOME/$relative_path"

  if [[ ! -f "$source_path" ]]; then
    print -u2 -- "Missing managed source: $source_path"
    exit 1
  fi

  if [[ -L "$target_path" && "${target_path:A}" == "${source_path:A}" ]]; then
    print -- "linked   $target_path"
  elif [[ -e "$target_path" || -L "$target_path" ]]; then
    print -- "replace  $target_path"
  else
    print -- "create   $target_path"
  fi
done

if [[ "$mode" == "--check" ]]; then
  print
  print -- "No changes made. Re-run with --apply to install packages and link files."
  exit 0
fi

print
print -- "Installing Homebrew dependencies without upgrading existing packages..."
brew bundle --no-upgrade --file="$repo_dir/Brewfile"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  print
  print -- "Installing Oh My Zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

typeset -a replaced_paths=()

for relative_path in "${managed_paths[@]}"; do
  source_path="$repo_dir/$relative_path"
  target_path="$HOME/$relative_path"

  if [[ -L "$target_path" && "${target_path:A}" == "${source_path:A}" ]]; then
    continue
  fi

  mkdir -p -- "${target_path:h}"

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    backup_path="$backup_root/$relative_path"
    mkdir -p -- "${backup_path:h}"
    mv -- "$target_path" "$backup_path"
    replaced_paths+=("$relative_path")
  fi

  ln -s -- "$source_path" "$target_path"
done

if (( ${#replaced_paths[@]} > 0 )); then
  print
  print -- "Previous files were backed up to: $backup_root"
fi

print
print -- "Installing mise-managed runtimes and CLIs..."
MISE_CONFIG_FILE="$repo_dir/.config/mise/config.toml" mise install

cursor_command=""
if command -v cursor >/dev/null 2>&1; then
  cursor_command="$(command -v cursor)"
elif [[ -x /Applications/Cursor.app/Contents/Resources/app/bin/cursor ]]; then
  cursor_command="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
fi

if [[ -n "$cursor_command" ]]; then
  print
  print -- "Installing Cursor extensions..."
  while IFS= read -r extension; do
    [[ -z "$extension" || "$extension" == \#* ]] && continue
    "$cursor_command" --install-extension "$extension"
  done < "$repo_dir/cursor-extensions.txt"
else
  print -u2 -- "Cursor is installed, but its command-line launcher was not found."
  print -u2 -- "Install the launcher from Cursor and rerun the extension commands in README.md."
fi

print
print -- "Bootstrap complete. Open a new Warp window, then complete the manual checklist in README.md."
