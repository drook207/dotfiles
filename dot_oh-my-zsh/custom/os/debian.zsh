# Change this once content is there
echo "Disable gnome-keyring to act as ssh agent. At least on ubuntu that is an issue. Various bugs are present for this"
gnome-keyring-daemon --replace --daemonize --components=pkcs11,secrets,gpg
