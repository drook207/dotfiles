# Herdr Dev Square: editor | lazygit / terminal | AI, in four equal panes.
# Port of Omarchy's hds, with lazygit and your AI tool instead of hunk/opencode.
# Usage: hds [<ai>]     (default: claude)
function hds --description 'Herdr layout: editor, lazygit, terminal and AI'
    _herdr_require hds; or return 1

    set -l ai claude
    set -q argv[1]; and set ai $argv[1]

    set -l dir $PWD
    set -l editor_pane $HERDR_PANE_ID
    herdr tab rename $HERDR_TAB_ID (path basename $dir) >/dev/null

    set -l terminal_pane (_herdr_split $editor_pane down 0.5 $dir)
    set -l git_pane (_herdr_split $editor_pane right 0.5 $dir)
    set -l ai_pane (_herdr_split $terminal_pane right 0.5 $dir)

    herdr pane run $editor_pane "$EDITOR ." >/dev/null
    herdr pane run $git_pane lazygit >/dev/null
    herdr pane run $ai_pane $ai >/dev/null
end
