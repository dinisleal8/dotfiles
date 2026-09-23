#!/usr/bin/env bash
#
# Dotfiles bootstrap for a Laravel development setup on Omarchy/Arch.
#
#   ./install.sh            install packages + tools, symlink configs
#   ./install.sh --link     only (re)create the config symlinks
#   ./install.sh --packages only install packages and tools
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DO_LINK=1
DO_PACKAGES=1

case "${1:-}" in
  --link) DO_PACKAGES=0 ;;
  --packages) DO_LINK=0 ;;
  --help | -h)
    sed -n '2,9p' "$0"
    exit 0
    ;;
  "") ;;
  *)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
esac

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }

backup() {
  local target="$1"
  local rel="${target#"$HOME"/}"
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  mv "$target" "$BACKUP_DIR/$rel"
  warn "backed up $target -> $BACKUP_DIR/$rel"
}

# Symlink every file under $1 into $2, preserving relative paths.
link_tree() {
  local src_root="$1" dest_root="$2" src rel dest
  while IFS= read -r -d '' src; do
    rel="${src#"$src_root"/}"
    dest="$dest_root/$rel"
    mkdir -p "$(dirname "$dest")"
    if [[ -L $dest && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      continue
    fi
    if [[ -e $dest || -L $dest ]]; then
      backup "$dest"
    fi
    ln -sfn "$src" "$dest"
  done < <(find "$src_root" -type f -print0)
}

install_packages() {
  local pacman_pkgs=() aur_pkgs=()
  mapfile -t pacman_pkgs < <(grep -vE '^\s*(#|$)' "$DOTFILES/packages/pacman.txt")
  mapfile -t aur_pkgs < <(grep -vE '^\s*(#|$)' "$DOTFILES/packages/aur.txt")

  if ! command -v pacman >/dev/null 2>&1; then
    warn "pacman not found - skipping package install (not an Arch/Omarchy system?)"
    return
  fi

  log "Installing official repo packages"
  sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"

  if ((${#aur_pkgs[@]})); then
    if ! command -v yay >/dev/null 2>&1; then
      log "Installing yay (AUR helper)"
      local tmp
      tmp="$(mktemp -d)"
      git clone https://aur.archlinux.org/yay.git "$tmp/yay"
      (cd "$tmp/yay" && makepkg -si --noconfirm)
      rm -rf "$tmp"
    fi
    log "Installing AUR packages"
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
  fi

  if command -v mise >/dev/null 2>&1; then
    log "Installing mise-managed runtimes (node, ...)"
    mise install || warn "mise install failed - run 'mise install' manually"
  fi

  if command -v yerd >/dev/null 2>&1; then
    log "Bootstrapping yerd (PHP 8.4 + MySQL)"
    yerd install php 8.4 || warn "run 'yerd install php 8.4' manually"
    yerd service start mysql || warn "run 'yerd service start mysql' manually"
  fi
}

link_configs() {
  log "Linking ~/.config"
  link_tree "$DOTFILES/config" "$HOME/.config"

  log "Linking home dotfiles"
  link_tree "$DOTFILES/home" "$HOME"

  log "Linking lock screen background"
  ln -sfn "$DOTFILES/assets/lock-background.jpeg" "$HOME/.config/omarchy/lock-background"

  if command -v omarchy >/dev/null 2>&1; then
    log "Applying Omarchy theme and reloading the shell"
    omarchy theme set vantablack || warn "theme set failed"
    omarchy plugin enable leal.lock >/dev/null 2>&1 || true
    omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
    omarchy restart shell >/dev/null 2>&1 || true
  fi
}

if ((DO_PACKAGES)); then
  install_packages
fi
if ((DO_LINK)); then
  link_configs
fi

log "Done."
if [[ -d $BACKUP_DIR ]]; then
  log "Backups saved in $BACKUP_DIR"
fi
