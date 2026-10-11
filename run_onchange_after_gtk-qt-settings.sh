#!/usr/bin/env bash
# Apply JetBrains Mono Nerd Font to GTK and Qt (qt6ct) and the default Adwaita
# cursor to GTK, whose settings live outside the dotfiles. Re-runs whenever
# this script changes.
set -euo pipefail

font="JetBrainsMono Nerd Font"
size=11
cursor="Adwaita"

if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface font-name "$font $size"
    gsettings set org.gnome.desktop.interface document-font-name "$font $size"
    gsettings set org.gnome.desktop.interface monospace-font-name "$font $size"
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
fi

gtk3="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
if [ -f "$gtk3" ]; then
    if grep -q '^gtk-font-name=' "$gtk3"; then
        sed -i "s/^gtk-font-name=.*/gtk-font-name=$font $size/" "$gtk3"
    else
        sed -i "/^\[Settings\]/a gtk-font-name=$font $size" "$gtk3"
    fi
    sed -i "s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor/" "$gtk3"
fi

qt6ct="${XDG_CONFIG_HOME:-$HOME/.config}/qt6ct/qt6ct.conf"
if [ -f "$qt6ct" ]; then
    qfont="\"$font,$size,-1,5,400,0,0,0,0,0,0,0,0,0,0,1\""
    sed -i '/^\[Fonts\]/,/^\[/{/^\(fixed\|general\)=/d}' "$qt6ct"
    if ! grep -q '^\[Fonts\]' "$qt6ct"; then
        printf '\n[Fonts]\n' >>"$qt6ct"
    fi
    sed -i "/^\[Fonts\]/a fixed=$qfont\ngeneral=$qfont" "$qt6ct"
fi
