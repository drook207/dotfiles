# Run hdl in one tab per subdirectory of the current directory, and name the
# workspace after it. Port of Omarchy's hdlm.
# Usage: hdlm <ai> [<second_ai>]
function hdlm --description 'hdl in one herdr tab per subdirectory'
    if test (count $argv) -lt 1
        echo "Usage: hdlm <ai> [<second_ai>]" >&2
        return 1
    end
    _herdr_require hdlm; or return 1

    set -l base $PWD
    herdr workspace rename $HERDR_WORKSPACE_ID (path basename $base) >/dev/null

    set -l hdl_command hdl (string escape -- $argv)
    set -l first true
    for dir in $base/*/
        set dir (string trim --right --chars=/ -- $dir)
        if test $first = true
            # reuse the current tab for the first project
            herdr pane run $HERDR_PANE_ID "cd "(string escape -- $dir)" && $hdl_command" >/dev/null
            set first false
        else
            set -l pane (herdr tab create --workspace $HERDR_WORKSPACE_ID --cwd $dir --no-focus |
                jq -r '.result.root_pane.pane_id')
            herdr pane run $pane "$hdl_command" >/dev/null
        end
    end
end
