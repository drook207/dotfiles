#!/usr/bin/env bash
# Install Firefox add-ons into the default profile. Takes effect the next time
# Firefox starts. Re-runs whenever this script changes.
#  - Pywalfox: lets noctalia's built-in firefox-theme host push the active
#    palette (Kanagawa Paper Ink) to Firefox; it re-applies the last colors on
#    startup even when noctalia isn't running
set -euo pipefail

# id url sha256
addons=(
    "pywalfox@frewacom.org https://addons.mozilla.org/firefox/downloads/file/4834767/pywalfox-2.1.1.xpi b7a7a86d1d49a8309758ce1d38492975abe07a61e3788e2d913c70a4d07758b4"
)

# Like Firefox itself: an existing ~/.mozilla/firefox wins over the XDG location.
root=""
for dir in "$HOME/.mozilla/firefox" "${XDG_CONFIG_HOME:-$HOME/.config}/mozilla/firefox"; do
    if [ -f "$dir/profiles.ini" ]; then
        root="$dir"
        break
    fi
done
if [ -z "$root" ]; then
    echo "firefox-theme: no Firefox profile found, skipping" >&2
    exit 0
fi

# The profile Firefox actually launches is the [Install...] Default=; fall back
# to the profile marked Default=1.
profile=$(awk -F= '
    /^\[Install/ { install = 1; next }
    /^\[/ { install = 0 }
    install && $1 == "Default" { print $2; exit }
' "$root/profiles.ini")
if [ -z "$profile" ]; then
    profile=$(awk -F= '
        /^\[Profile/ { path = ""; def = 0 }
        $1 == "Path" { path = $2 }
        $1 == "Default" && $2 == "1" { def = 1 }
        def && path != "" { print path; exit }
    ' "$root/profiles.ini")
fi
case "$profile" in
    /*) profile_dir="$profile" ;;
    *) profile_dir="$root/$profile" ;;
esac
if [ ! -d "$profile_dir" ]; then
    echo "firefox-theme: profile directory $profile_dir not found, skipping" >&2
    exit 0
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
mkdir -p "$profile_dir/extensions"
for addon in "${addons[@]}"; do
    read -r id url sha256 <<<"$addon"
    xpi="$profile_dir/extensions/$id.xpi"
    if ! echo "$sha256  $xpi" | sha256sum -c --status 2>/dev/null; then
        curl -fsSL -o "$tmp" "$url"
        echo "$sha256  $tmp" | sha256sum -c --status
        install -m 644 "$tmp" "$xpi"
    fi
done

# user.js is applied on every start: don't auto-disable add-ons placed in the
# profile's extensions folder (scope 1) so they load.
userjs="$profile_dir/user.js"
touch "$userjs"
set_pref() {
    local name="$1" value="$2"
    sed -i "/user_pref(\"$name\",/d" "$userjs"
    echo "user_pref(\"$name\", $value);" >>"$userjs"
}
# Drop the theme pref set by earlier versions of this script
sed -i '/user_pref("extensions.activeThemeID",/d' "$userjs"
set_pref extensions.autoDisableScopes 14
