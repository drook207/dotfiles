# Fail with a message unless running inside a herdr pane
function _herdr_require
    if not set -q HERDR_PANE_ID
        echo "You must start herdr to use $argv[1]." >&2
        return 1
    end
end
