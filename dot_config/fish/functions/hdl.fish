# Herdr Dev Layout: editor (left), AI (right), terminal (bottom 15 %).
# Port of Omarchy's hdl (default/bash/fns/herdr).
# Usage: hdl <ai> [<second_ai>]     e.g. hdl claude
function hdl --description 'Herdr layout: editor, AI and terminal'
    if test (count $argv) -lt 1
        echo "Usage: hdl <ai> [<second_ai>]" >&2
        return 1
    end
    _herdr_require hdl; or return 1

    set -l dir $PWD
    set -l editor_pane $HERDR_PANE_ID
    herdr tab rename $HERDR_TAB_ID (path basename $dir) >/dev/null

    # top 85 % editor + AI, bottom 15 % terminal
    _herdr_split $editor_pane down 0.85 $dir >/dev/null
    # AI on the right 30 %
    set -l ai_pane (_herdr_split $editor_pane right 0.7 $dir)

    if set -q argv[2]
        set -l ai2_pane (_herdr_split $ai_pane down 0.5 $dir)
        herdr pane run $ai2_pane $argv[2] >/dev/null
    end
    herdr pane run $ai_pane $argv[1] >/dev/null
    herdr pane run $editor_pane "$EDITOR ." >/dev/null
end
