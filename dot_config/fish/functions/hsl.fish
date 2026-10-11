# Herdr Swarm Layout: tile <count> panes in a grid and run the same command in
# each (e.g. several AI agents). Port of Omarchy's hsl.
# Usage: hsl <pane_count> <command>     e.g. hsl 4 claude
function hsl --description 'Grid of herdr panes running the same command'
    if test (count $argv) -lt 2
        echo "Usage: hsl <pane_count> <command>" >&2
        return 1
    end
    _herdr_require hsl; or return 1

    set -l count $argv[1]
    set -l cmd $argv[2..-1]
    set -l dir $PWD
    herdr tab rename $HERDR_TAB_ID (path basename $dir) >/dev/null

    # ceil(sqrt(count)) columns
    set -l cols 1
    while test (math "$cols * $cols") -lt $count
        set cols (math $cols + 1)
    end

    # Split the rightmost column off at 1/(n-k+1) each time so columns are even
    # and stay in left-to-right order
    set -l columns $HERDR_PANE_ID
    for k in (seq 1 (math $cols - 1))
        set -a columns (_herdr_split $columns[-1] right (math -s4 "1 / ($cols - $k + 1)") $dir)
    end

    # Split each column into its share of rows, evenly and top to bottom
    set -l panes
    for index in (seq 0 (math $cols - 1))
        set -l col $columns[(math $index + 1)]
        set -l rows (math "floor($count / $cols)")
        test $index -lt (math "$count % $cols"); and set rows (math $rows + 1)
        set -a panes $col
        set -l last $col
        for j in (seq 1 (math $rows - 1))
            set last (_herdr_split $last down (math -s4 "1 / ($rows - $j + 1)") $dir)
            set -a panes $last
        end
    end

    for pane in $panes
        herdr pane run $pane "$cmd" >/dev/null
    end
end
