#!/usr/bin/sh
set -e

OPTSTRING="b:r:"

while getopts ${OPTSTRING} opt; do
        case ${opt} in
                b)
                        echo "Chezmoi will try to use the given branch ${OPTARG} upon init."
                        CHEZMOI_GITBRANCH="${OPTARG}"
                        ;;
                r)
                        echo "Chezmoi will try to use the given repo specifier ${OPTARG} upon init."
                        CHEZMOI_REPOSITORY_SPECIFIER="${OPTARG}"
                        ;;
    :)
      echo "Option -${OPTARG} requires an argument."
      exit 1
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

######################################################################################################
# Thank you, https://ohmyz.sh/ for this part of the script
######################################################################################################

command_exists() {
        command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
        # Check if sudo is installed
        command_exists sudo || return 1
        # Termux can't run sudo, so we can detect it and exit the function early.
        case "$PREFIX" in
        *com.termux*) return 1 ;;
        esac
        # The following command has 3 parts:
        #
        # 1. Run `sudo` with `-v`. Does the following:
        #    • with privilege: asks for a password immediately.
        #    • without privilege: exits with error code 1 and prints the message:
        #      Sorry, user <username> may not run sudo on <hostname>
        #
        # 2. Pass `-n` to `sudo` to tell it to not ask for a password. If the
        #    password is not required, the command will finish with exit code 0.
        #    If one is required, sudo will exit with error code 1 and print the
        #    message:
        #    sudo: a password is required
        #
        # 3. Check for the words "may not run sudo" in the output to really tell
        #    whether the user has privileges or not. For that we have to make sure
        #    to run `sudo` in the default locale (with `LANG=`) so that the message
        #    stays consistent regardless of the user's locale.
        #
        ! LANG='' sudo -n -v 2>&1 | grep -q "may not run sudo"
}

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd "$USER" 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~"$USER")}"

# Check if user has sudo privileges
#
# Defines two sudo placeholders. One for regular sudo, one that will force password input by using the `-k` option.
if user_can_sudo; then
        SUDO_FORCE_PASSWORD="sudo -k && sudo" # -K forces the password prompt
        SUDO="sudo" # remembers password
fi

######################################################################################################
# End of oh-my-zsh code
######################################################################################################
echo "Installing requirements..."
# first sudo in the script always forces the password
$SUDO_FORCE_PASSWORD apt-get update && $SUDO apt-get -y install curl git zsh nano locales

echo "Ensuring at least one locale en_US.UTF-8 is available by adding it to /etc/locale.gen"
$SUDO sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen

echo "Generating locales"
$SUDO locale-gen

if command_exists gnome-terminal; then
        echo "Installing selenized color scheme for gnome-terminal. Old Profile will be saved as Default_backup"
        tempdir=$(mktemp -d)
        git clone https://github.com/darkmattercoder/selenized "$tempdir"
        "$tempdir"/terminals/gnome-terminal/install.sh -s selenized-black -p Default
        rm -rf "$tempdir"
fi

echo "Installing github cli"
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

echo "Installing oh-my-zsh. Since we want to do additional install steps afterwards, we won't start a zsh shell automatically."
RUNZSH=no CHSH=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Getting chezmoi..."

if [ -z "$CHEZMOI_REPOSITORY_SPECIFIER" ]; then
        echo "Using github repository https://github.com/darkmattercoder/dotfiles.git"
        CHEZMOI_REPOSITORY_SPECIFIER=darkmattercoder
else
        echo "Using git specifier $CHEZMOI_REPOSITORY_SPECIFIER"
fi

if [ -n "$CHEZMOI_GITBRANCH" ]; then
        echo "Using specific branch $CHEZMOI_GITBRANCH"
        CHEZMOI_BRANCH="--branch $CHEZMOI_GITBRANCH"
fi

# Cannot get the branch argument parsed when quoted. So for f***s sake, just use it unqoted, because that works
# shellcheck disable=SC2086
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/bin init --apply $CHEZMOI_BRANCH "$CHEZMOI_REPOSITORY_SPECIFIER"

exec zsh -l
