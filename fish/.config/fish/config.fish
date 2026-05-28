if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a pi sudo pacman -S
abbr -a ps pacman -Ss
abbr -a pr sudo pacman -R
abbr -a pu sudo pacman -Syu
abbr -a lg lazygit
abbr -a n nvim
abbr -a gst git status
abbr -a grep rg
abbr -a ls exa
abbr -a ll exa -al
abbr -a find fd
starship init fish | source
zoxide init --cmd cd fish | source
