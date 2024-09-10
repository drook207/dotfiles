#!/bin/sh
command_exists() {
	command -v "$@" >/dev/null 2>&1
}
command_exists gnome-keyring-daemon || return 0
echo "Disable gnome-keyring to act as ssh agent. At least on ubuntu that is an issue. Various bugs are present for this"
gnome-keyring-daemon --replace --daemonize --components=pkcs11,secrets,gpg
