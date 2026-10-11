#!/usr/bin/env bash
# Bootstrap these dotfiles on a fresh CachyOS/Arch install:
#
#   curl -fsSL https://raw.githubusercontent.com/drook207/dotfiles/main/install.sh | bash
#
# Clones the repo to ~/dotfiles, applies everything with chezmoi (packages,
# configs, system files), fetches the age key from 1Password and decrypts the
# secrets. Safe to run again: every step skips what's already done.
set -euo pipefail

repo="https://github.com/drook207/dotfiles.git"
source_dir="$HOME/dotfiles"
age_key="$HOME/.config/chezmoi/key.txt"
age_key_item="chezmoi age key"   # Document in 1Password

# Piped from curl, stdin is the script itself: read prompts (sudo, paru, ours)
# from the terminal instead. The chezmoi scripts also need a terminal.
if [ ! -t 0 ]; then
    exec </dev/tty
fi

say() { printf '\n\033[1;33m==> %s\033[0m\n' "$*"; }

if ! command -v pacman >/dev/null; then
    echo "This needs an Arch-based system (pacman)." >&2
    exit 1
fi
if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as your normal user, not root (it uses sudo where needed)." >&2
    exit 1
fi

say "Installing git, chezmoi and build tools"
sudo pacman -S --needed git chezmoi base-devel

if [ -d "$source_dir/.git" ]; then
    say "Updating $source_dir"
    git -C "$source_dir" pull --ff-only
else
    say "Cloning $repo to $source_dir"
    chezmoi --source "$source_dir" init "$repo"
fi
# Writes ~/.config/chezmoi/chezmoi.toml (sourceDir, age settings) from the repo
chezmoi --source "$source_dir" init

say "Applying everything except encrypted files (packages, configs, system files)"
chezmoi apply --exclude=encrypted

if [ ! -s "$age_key" ]; then
    say "Fetching the age key from 1Password"
    cat <<EOF
The secrets (e.g. ~/.ssh/id_homeserver) are encrypted with an age key that is
stored in 1Password as the document "$age_key_item".

  1. Start 1Password (installed just now) and sign in.
  2. Settings -> Developer -> enable "Integrate with 1Password CLI".

Or copy key.txt from another machine to $age_key yourself.
EOF
    while [ ! -s "$age_key" ]; do
        read -r -p "Press Enter to fetch the key with op, or type 's' to skip: " answer
        [ "$answer" = s ] && break
        mkdir -p "$(dirname "$age_key")"
        (umask 077 && op document get "$age_key_item" --out-file "$age_key") ||
            echo "op couldn't fetch it - is 1Password running, signed in, with CLI integration on?"
    done
fi

if [ -s "$age_key" ]; then
    chmod 600 "$age_key"
    say "Applying encrypted files"
    chezmoi apply
else
    echo "Skipped secrets. Put the key at $age_key and run 'chezmoi apply' later."
fi

say "Done"
cat <<'EOF'
Next steps:
  - Log out and back in (PATH, cursor, Hyprland and noctalia pick everything up).
  - Firefox: start it, close it, start it again (installs and enables Pywalfox).
  - gh auth login   (GitHub, also needed for pushing these dotfiles)
  - glab auth login (GitLab)
  - 1Password: Settings -> Developer -> enable the SSH agent.
EOF
