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
| Browser | Firefox, themed via Pywalfox |

## New machine

Assumes CachyOS: `noctalia` and `swash` come from the CachyOS repos.

```sh
sudo pacman -S chezmoi
chezmoi init --apply https://github.com/drook207/dotfiles.git
```

Run it in a terminal: installing packages needs sudo, and paru asks you to
review AUR build scripts. Then log out and back in.

To keep the repo in `~/dotfiles` instead of `~/.local/share/chezmoi`, clone it
there and create `~/.config/chezmoi/chezmoi.toml` with `sourceDir = "~/dotfiles"`
before running `chezmoi apply`.

**Firefox:** start it, close it, and start it once more. Firefox installs the
Pywalfox extension on the first start but only runs it after the second, then
noctalia pushes the colors.

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
| `run_onchange_after_docker-localhost.sh.tmpl` | Publishes Docker container ports on 127.0.0.1 by default (Docker bypasses ufw) |
| `run_onchange_after_battery-charge-limit.sh.tmpl` | Charge battery to 75-80 % where supported (ThinkPads); no-op elsewhere |

## Theme

The Kanagawa Paper Ink palette is defined once for noctalia in
`dot_config/noctalia/palettes/KanagawaPaperInk.json`. noctalia applies it to the
bar, lock screen, GTK, Qt, btop and kitty, and pushes it to Firefox through
Pywalfox. ghostty, Neovim, lazygit, fzf, fish, starship, herdr and the Hyprland
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
- **`~/.local/bin` is on the session PATH** through
  `environment.d/10-local-bin.conf`, so apps launched from Hyprland find
  user-installed tools.
- **Firefox native messaging manifests** live in
  `~/.mozilla/native-messaging-hosts/` even when the profile is in
  `~/.config/mozilla/`. Firefox only switches to the old layout when
  `~/.mozilla/firefox` exists.
- **Neovim plugin versions are pinned** by the tracked `lazy-lock.json`. After
  `:Lazy update`, run `chezmoi re-add ~/.config/nvim/lazy-lock.json` and commit,
  otherwise `chezmoi verify` reports drift.
- **Idle:** the screen locks after 10 minutes and turns off after 11.
  `SUPER+CTRL+I` toggles caffeine (stay awake).
