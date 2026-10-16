# dotfiles

Personal dotfiles for a Laravel development setup on **Omarchy** (Arch Linux +
Hyprland + the Omarchy Quickshell shell).

Everything is applied by one bootstrap script that installs the packages and
tools and symlinks the configs into place.

## Quick start

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

- `./install.sh` — install packages/tools **and** link configs
- `./install.sh --packages` — only install packages and tools
- `./install.sh --link` — only (re)create the config symlinks

Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before being
replaced with symlinks, so nothing is lost.

## What it installs

**Packages** (`packages/pacman.txt`, `packages/aur.txt`)

- `yerd` (AUR) — Laravel Herd-style local PHP environment: PHP versions,
  `.test` sites, MySQL/Redis/Postgres services, mail catcher, TLS
- `composer`, `bun`, `docker` + `docker-compose`, `mariadb-libs`,
  `postgresql-libs`, `php-gd`, `php-sqlite`
- `mise` for runtimes (Node, and the AI CLIs)
- `neovim`, `tmux`, `git`, `github-cli`, `lazygit`, `lazydocker`,
  `ripgrep`, `fd`, `fzf`, `jq`, `bat`, `eza`, `zoxide`, `starship`

**Tools** — `install.sh` also runs `mise install`, then sets up yerd with PHP
8.4 and a MySQL service.

## Layout

```
config/            -> symlinked file-by-file into ~/.config
  hypr/            Hyprland personal overrides (incl. input.lua: us/pt layouts)
  omarchy/         shell.json, Vantablack theme overlay, lock plugin, hooks
  alacritty/ foot/ ghostty/ kitty/ tmux/
  nvim/            LazyVim config
  btop/ git/ mise/ yerd/ opencode/ fcitx5/ zed/ starship.toml
home/              -> symlinked into ~  (.bashrc, .bash_profile, .XCompose)
scripts/           helper scripts
assets/            lock screen background
packages/          package lists
```

## Keyboard layouts

Layout switching is configured in `config/hypr/input.lua`:

```lua
kb_layout = "us,pt",
kb_options = "compose:caps,shift:both_capslock_cancel,grp:alt_shift_toggle",
```

Switch with **Alt+Shift**, or run `scripts/switch-keyboard-layout.sh`.

## Notes

- Secrets (SSH keys, GPG, browser profiles, tokens) are intentionally **not**
  tracked. `.gitignore` excludes them.
- The lock screen uses a cloned shell plugin (`config/omarchy/plugins/leal.lock`)
  so the lock image differs from the desktop wallpaper. The image is
  `assets/lock-background.jpeg`, linked to `~/.config/omarchy/lock-background`.
  Swap it by replacing that file.
- Because the lock plugin is a user clone, it will not receive upstream Omarchy
  lock-screen updates automatically.
# dotfiles
# dotfiles
# dotfiles
