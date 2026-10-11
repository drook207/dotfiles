#!/usr/bin/env bash
# Install the "Kanagawa Wave" Firefox theme into the default profile and make
# it the active theme. Takes effect the next time Firefox starts.
# Re-runs whenever this script changes.
set -euo pipefail

theme_id="{7efc2a80-496f-49b1-88db-4ddd7d312757}"
theme_url="https://addons.mozilla.org/firefox/downloads/file/4847676/kanagawa_wave_dark_theme-2.5.xpi"
theme_sha256="57da9fe43e2c37a5e9eeaaf350128e94c373869e04a345acb85dc91372824953"

root=""
for dir in "${XDG_CONFIG_HOME:-$HOME/.config}/mozilla/firefox" "$HOME/.mozilla/firefox"; do
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

xpi="$profile_dir/extensions/$theme_id.xpi"
if ! echo "$theme_sha256  $xpi" | sha256sum -c --status 2>/dev/null; then
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' EXIT
    curl -fsSL -o "$tmp" "$theme_url"
    echo "$theme_sha256  $tmp" | sha256sum -c --status
    mkdir -p "$profile_dir/extensions"
    install -m 644 "$tmp" "$xpi"
fi

# user.js is applied on every start: select the theme, and don't auto-disable
# add-ons placed in the profile's extensions folder (scope 1) so the theme loads.
userjs="$profile_dir/user.js"
touch "$userjs"
set_pref() {
    local name="$1" value="$2"
    sed -i "/user_pref(\"$name\",/d" "$userjs"
    echo "user_pref(\"$name\", $value);" >>"$userjs"
}
set_pref extensions.activeThemeID "\"$theme_id\""
set_pref extensions.autoDisableScopes 14
