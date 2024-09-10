# Some dotfiles for chezmoi dotfile manager

Run the following command. Use on your own responsibility. The script might burn your RAM, shatter your microwave to pieces, tormenting children in the US or Russia, cause further climate change or even let nuclear explosions happen...

```bash
sh -c "$(wget https://raw.githubusercontent.com/darkmattercoder/dotfiles/main/bin/executable_bootstrap.sh -O -)"
```

if you have no wget, just use this oneliner:

```bash
apt update && apt install wget && sh -c "$(wget https://raw.githubusercontent.com/darkmattercoder/dotfiles/main/bin/executable_bootstrap.sh -O -)" 
```

## Overwriting the github repo for chezmoi initialization

By default, chezmoi will simply use my hardcoded github username as argument to the contained chezmoi install call:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/bin init --apply darkmattercoder
```

By passing arguments to the bootstrap call, you can change this behaviour. The supported arguments are `-b <branchname>` and `-r <repo specifier>`.

A few examples:

```bash
# The default branch of an arbitrary github repository named `githubrepo` of user `githubusername` is used
sh -c "$(wget https://raw.githubusercontent.com/darkmattercoder/dotfiles/main/bin/executable_bootstrap.sh -O -)" -- -r githubusername/githubrepo
# The default branch of a github repository called `dotfiles` of user `githubusername` is used
sh -c "$(wget https://raw.githubusercontent.com/darkmattercoder/dotfiles/main/bin/executable_bootstrap.sh -O -)" -- -r githubusername
# Some different branch than the default branch of a github repo called `dotfiles` of user `githubusername` is used
sh -c "$(wget https://raw.githubusercontent.com/darkmattercoder/dotfiles/main/bin/executable_bootstrap.sh -O -)" -- -b mybranch -r githubusername
# An absolutely addressed remote repository is used with a specific branch
sh -c "$(wget https://raw.githubusercontent.com/darkmattercoder/dotfiles/main/bin/executable_bootstrap.sh -O -)" -- -b mybranch -r https://git.my.domain/user/repo.git
```
