# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/ben/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# color theme switching
iterm-profile() { echo -e "\033]50;SetProfile=$1\a" }
alias light="iterm-profile \"Solarized light fixed\""
alias dark="iterm-profile \"Solarized Dark Fixed\""

# Here we do some fancy things so that we can quickly navigate the filesystem using 'marks'
export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}

function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}

function unmark {
    rm -i $MARKPATH/$1
}

function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

# git aliases
alias gs="git status"
alias gap="git add -p"
alias gm="git commit -m"
alias gcan="git commit --amend --no-edit"
alias gpr="git pull --rebase"
alias master="git checkout master"

function gnb() {
    upstream=$(git remote | egrep -o "(upstream|origin)" | tail -1)
    headbranch=$(git remote show ${upstream} | awk '/HEAD branch/ {print $NF}')
    git checkout -t origin/${2:-${headbranch}} -b $1
}

function rel-notes() {
    git log --pretty=oneline head...$1 | pbcopy
}

function nextstep() {
    git log --reverse --pretty=%H master | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout
}

function prevstep() {
    git checkout HEAD^1
}

# enhancements
alias lh="ls -lah"
alias hig="history | grep"

# apply hub
alias git=hub

# create squash merge branch
function squashPr {
    branchName=$(git rev-parse --abbrev-ref HEAD)
    prefix="-merge-pr"
    newBranchName="$branchName$prefix"
    echo "creating $newBranchName branch from $branchName"
    git branch -m $newBranchName
    git pull --rebase
    git rebase -i
    git push origin master +$newBranchName
    git pull-request
}

# notify
alias notify="osascript -e 'beep 3'"

# GO PATH
export GOPATH=/Users/ben/Development/repos/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Enable IEx Shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Google Cloud SDK
export PATH="$PATH:$HOME/google-cloud-sdk/bin"
