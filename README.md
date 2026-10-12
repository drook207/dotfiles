# dotfiles

My CachyOS + Hyprland desktop, managed with [chezmoi](https://www.chezmoi.io/).
Everything is themed with **Kanagawa Paper Ink** and uses **JetBrains Mono Nerd Font**.

| Area | Tool |
|---|---|
| Compositor | Hyprland (Lua config) via uwsm |
| Shell / bar / launcher / lock screen | noctalia |
| Terminal | ghostty |
| Terminal workspaces | herdr |
| Shell | fish + starship, zoxide, fzf, eza |
| Editor | Neovim (LazyVim) |
| File manager (terminal) | yazi; `y` starts it and cds to where you left off |
| Browser | Firefox, themed via Pywalfox |

## New machine

On a fresh CachyOS install (`noctalia` and `swash` come from the CachyOS repos),
in a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/drook207/dotfiles/main/install.sh | bash
```

`install.sh` installs git and chezmoi, clones this repo to `~/dotfiles`, applies
everything (packages via pacman/paru, configs, system files; it asks for sudo,
and paru for reviewing AUR build scripts), then fetches the age key from
1Password (document "chezmoi age key") to decrypt the secrets. It's safe to run
again. Afterwards: log out and back in, start Firefox twice (installs
Pywalfox), and run `gh auth login` / `glab auth login`.

### Ubuntu 26.04

The same command works on Ubuntu 26.04 (`run_onchange_after_00-install-packages-ubuntu.sh.tmpl`,
package list in `.chezmoidata/ubuntu.toml`). It adds the APT sources Ubuntu
lacks: `ppa:cppiber/hyprland` (Hyprland 0.56; resolute only has 0.53, without
the Lua config), noctalia's repo, 1Password and mise. The Nerd Font, lazydocker
and LocalSend come pinned from GitHub, herdr from its installer; `fd`/`bat`
are linked to Ubuntu's `fdfind`/`batcat`. Log in via GDM with the
"Hyprland (uwsm-managed)" session.

Differences from Arch:

- No screen recording (`ALT+PRINT`): gpu-screen-recorder isn't packaged.
- noctalia copies screenshots to the clipboard instead of opening swash.
- Firefox is a snap: Pywalfox installs, but noctalia's native messaging host
  can't reach a snap Firefox, so the Paper Ink colors don't apply there.
- snapper, btrfs scrub and kernel-modules-hook are Arch/btrfs-only and skipped.

### Fedora 45 in WSL2 (Windows)

The same command inside WSL sets up the terminal environment only: chezmoi
detects WSL (Microsoft kernel) and skips Hyprland, noctalia, ghostty and the
desktop scripts. Packages come from dnf
(`run_onchange_after_00-install-packages-fedora.sh.tmpl`, list in
`.chezmoidata/fedora.toml`); starship, lazygit and yazi via `mise use -g`;
herdr via its installer. In WSL:

- Windows Terminal gets the Kanagawa Paper Ink scheme and JetBrains Mono Nerd
  Font as defaults for all profiles (`run_onchange_after_windows-terminal`, files
  in `windows/`); the font is installed for the Windows user if missing.
  Restart Windows Terminal afterwards.
- The age key comes from the Windows 1Password app via `op.exe`
  (`winget install AgileBits.1Password.CLI`, CLI integration enabled).
- Commits are signed through 1Password's `op-ssh-sign-wsl.exe`; without it,
  signing is off in WSL.
- `DOTFILES_FORCE_WSL=1` forces WSL mode, e.g. for tests.

## Day to day

```sh
chezmoi edit ~/.config/ghostty/config  # or edit the file in the repo
chezmoi diff                           # preview
chezmoi apply                          # write to ~
chezmoi re-add <file>                  # copy a file changed in ~ back into the repo
```

## Layout

| Path | Contents |
|---|---|
| `dot_config/` | Everything under `~/.config` |
| `dot_local/share/wallpapers/` | Wallpaper (pixel-art castle) |
| `.chezmoidata/packages.toml` | Packages the configs need (repo + AUR), system services to enable and ufw rules |
| `.chezmoiexternal.toml` | Repos chezmoi clones (ghostty cursor shaders) |
| `run_onchange_after_00-install-packages.sh.tmpl` | Installs missing packages with pacman/paru, enables the services, adds the ufw rules |
| `run_onchange_after_gtk-qt-settings.sh` | GTK/Qt font and cursor settings that live outside `~/.config` files |
| `run_onchange_after_firefox-theme.sh.tmpl` | Installs Pywalfox into the default Firefox profile |
| `run_onchange_after_snapper-home.sh.tmpl` | Hourly snapper snapshots of `/home` (10 hourly, 7 daily, 4 weekly) |
| `system/` + `run_onchange_after_10-system-files.sh.tmpl` | Files installed under `/` with sudo (resolved, smartd), services restarted on change |
| `run_onchange_after_noctalia-reload.sh.tmpl` | Reloads noctalia after its config or palette changes |
| `run_onchange_after_docker-localhost.sh.tmpl` | Publishes Docker container ports on 127.0.0.1 by default (Docker bypasses ufw) |
| `run_onchange_after_battery-charge-limit.sh.tmpl` | Charge battery to 75-80 % where supported (ThinkPads); no-op elsewhere |

## Theme

The Kanagawa Paper Ink palette is defined once for noctalia in
`dot_config/noctalia/palettes/KanagawaPaperInk.json`. noctalia applies it to the
bar, lock screen, GTK, Qt, btop and kitty, and pushes it to Firefox through
Pywalfox. ghostty, Neovim, lazygit, fzf, fish, starship, herdr, yazi and the Hyprland
borders set the same colors in their own configs.

## Keybindings

Hyprland follows Omarchy's defaults (`dot_config/hypr/config/binds.lua`):

| Keys | Action |
|---|---|
| `SUPER+Return` | Terminal (ghostty) |
| `SUPER+CTRL+Return` | herdr |
| `SUPER+Space` | Launcher |
| `SUPER+W` | Close window |
| `SUPER+1..5` / `SUPER+SHIFT+1..5` | Go to / move window to workspace |
| `SUPER+T` / `SUPER+F` | Float / fullscreen |
| `SUPER+SHIFT+B` / `SUPER+SHIFT+F` / `SUPER+SHIFT+N` | Browser / files / Neovim |
| `SUPER+CTRL+L` | Lock |
| `SUPER+K` | Searchable list of all keybindings |
| `ALT+PRINT` / `SUPER+CTRL+PRINT` | Screen recording on/off / copy text from a region (OCR) |
| `SUPER+SHIFT+D` | lazydocker (asks for sudo; no docker group, like Omarchy) |
| `SUPER+ESCAPE` | Session menu |
| `PRINT` | Screenshot |

herdr uses Omarchy's tmux-style keys with `Ctrl+Space` as prefix
(`dot_config/herdr/config.toml`).
Inside herdr, the fish functions `hdl <ai>`, `hds [ai]`, `hdlm <ai>` and
`hsl <n> <cmd>` open Omarchy's dev layouts (editor, AI, terminal, lazygit).

## Things that aren't obvious

- **noctalia settings override this repo.** Changes made in noctalia's settings
  window go to `~/.local/state/noctalia/settings.toml`, which wins over
  `config.toml`. Put lasting changes in `dot_config/noctalia/config.toml` and
  remove the matching keys from `settings.toml`.
- **`fish_variables` isn't tracked.** fish rewrites it at runtime, so it's in
  `.chezmoiignore`.
- **`chezmoi apply` fails while packages are missing** if no terminal is
  attached. The install script stops with a list instead of skipping, so it
  runs again next time. `starship` and `herdr` count as installed when their
  command is already on the PATH (e.g. from their own install scripts).
- **The laptop panel is pinned to scale 1** (`eDP-1` in
  `hypr/config/monitors.lua`). Hyprland's automatic scaling would pick 1.5× on
  14" and smaller 1080p panels.
- **`~/.local/bin` is on the session PATH** through `uwsm/env` (uwsm takes PATH
  from the login environment and overrides `environment.d`), effective after
  the next login. Hyprland bindings call own scripts by full path anyway.
- **Firefox native messaging manifests** live in
  `~/.mozilla/native-messaging-hosts/` even when the profile is in
  `~/.config/mozilla/`. Firefox only switches to the old layout when
  `~/.mozilla/firefox` exists.
- **Neovim plugin versions are pinned** by the tracked `lazy-lock.json`. After
  `:Lazy update`, run `chezmoi re-add ~/.config/nvim/lazy-lock.json` and commit,
  otherwise `chezmoi verify` reports drift.
- **Idle:** the screen locks after 10 minutes and turns off after 11.
  `SUPER+CTRL+I` toggles caffeine (stay awake).
