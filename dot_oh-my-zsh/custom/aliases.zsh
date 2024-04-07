# Custom aliases shared amongst systems

# file system
alias ll="ls -lAh"

# git
alias gap="git add -p"
alias gcm="git commit -m" # overwrites alias gcm='git checkout master'
alias glog='git log --pretty="format:%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s"'
alias glogg="glog --graph"
alias glogga='glogg --all'
alias gmc='git merge --continue'
alias gmm='git fetch origin main:main && git merge main'
alias gpf='git push --force-with-lease --force-if-includes'
alias gsl="git stash list"
alias gspop="git stash pop"
alias gspush="git stash push"
alias gsr="git switch --recurse-submodules"

# network
alias ip="ip -c"

# chezmoi
alias cm=chezmoi
alias cmd="chezmoi diff"
alias cmc="chezmoi cd"
alias cmm="chezmoi merge"
alias cms="chezmoi status"
alias cme="chezmoi edit"
alias cmapl="chezmoi apply"
alias cmadd="chezmoi add"

# docker
alias dcu="docker compose up"
alias dcud="docker compose up -d"
alias dcudl="docker compose up -d && docker compose logs -f"
alias dcd="docker compose down"

# Apt
alias agu="sudo apt update && sudo apt full-upgrade"
