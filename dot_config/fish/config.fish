if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a pi sudo pacman -S
abbr -a pss pacman -Ss
abbr -a pr sudo pacman -R
abbr -a pu sudo pacman -Syu
abbr -a lg lazygit
abbr -a n nvim
abbr -a gst git status
abbr -a grep rg
abbr -a ls eza
abbr -a ll eza -al
abbr -a find fd
set -gx EDITOR nvim
# mise first: on Fedora/WSL it provides starship, lazygit and yazi
command -q mise; and mise activate fish | source
starship init fish | source
zoxide init --cmd cd fish | source

# User-installed tools (pipx, herdr, ...); no-op if already on the PATH
fish_add_path -g ~/.local/bin
