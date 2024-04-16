#!/usr/bin/sh

echo "Installing requirements..."
sudo apt-get update && sudo -y apt-get install git zsh

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Getting chezmoi..."
if [ -z $1 ]; then
	echo "Using github username *darkmattercoder* for cloning"
	REPOSITORY_SPECIFIER=darkmattercoder
else
	echo "Using git remote $1"
	REPOSITORY_SPECIFIER=$1
fi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/bin init --apply $REPOSITORY_SPECIFIER
