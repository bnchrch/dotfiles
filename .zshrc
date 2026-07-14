export ZSH="$HOME/.oh-my-zsh"

# Warp renders the prompt; Oh My Zsh supplies plugins and shell behavior.
ZSH_THEME=""

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

plugins=(
  git
  brew
  macos
  mise
  ngrok
  npm
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 -- "Oh My Zsh is not installed. Run the dotfiles bootstrap."
fi

# Cursor is the default interactive editor.
export EDITOR="cursor --wait"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

# Git and utility aliases retained from the previous configuration.
alias gs="git status"
alias gap="git add -p"
alias gcan="git commit --amend --no-edit"
alias gpr="git pull --rebase"
alias lh="ls -lah"
alias notify="osascript -e 'beep 3'"

# Persistent history shared across interactive shells.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups

# Named filesystem locations.
export MARKPATH="$HOME/.marks"

jump() {
  local name="${1:?usage: jump <mark>}"
  local target="$MARKPATH/$name"

  if [[ ! -e "$target" ]]; then
    print -u2 -- "No such mark: $name"
    return 1
  fi

  builtin cd -P -- "$target"
}

mark() {
  local name="${1:?usage: mark <name>}"

  mkdir -p -- "$MARKPATH"
  ln -sfn -- "$PWD" "$MARKPATH/$name"
}

unmark() {
  local name="${1:?usage: unmark <name>}"
  local target="$MARKPATH/$name"

  if [[ ! -L "$target" ]]; then
    print -u2 -- "No such mark: $name"
    return 1
  fi

  rm -i -- "$target"
}

marks() {
  local entry

  for entry in "$MARKPATH"/*(N); do
    printf '%-24s -> %s\n' "${entry:t}" "${entry:A}"
  done
}
