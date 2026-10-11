# Kanagawa Paper Ink fish colors, mapped from the palette of
# https://github.com/thesimonho/kanagawa-paper.nvim (no upstream fish extra)
set -l foreground DCD7BA normal
set -l selection 363646 brblack
set -l comment 727169 brblack
set -l red c4746e red
set -l orange b6927b brred
set -l yellow c4b28a yellow
set -l green 699469 green
set -l purple 938AA9 magenta
set -l cyan 8ea49e cyan
set -l pink a292a3 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# fzf (used by fzf.fish), from extras/fzf/kanagawa-paper-ink.rc
set -gx FZF_DEFAULT_OPTS "--color=bg:-1,bg+:#2A2A37,fg:-1,fg+:#DCD7BA,hl:#938AA9,hl+:#c4746e --color=header:#b6927b,info:#658594,pointer:#7AA89F --color=marker:#7AA89F,prompt:#c4746e,spinner:#8ea49e"
