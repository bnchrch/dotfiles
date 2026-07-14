# Homebrew uses different prefixes on Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# OrbStack command-line tools and shell integration.
export PATH="$HOME/.orbstack/bin:$PATH"
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
