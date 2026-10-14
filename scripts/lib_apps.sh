#!/usr/bin/env bash
# ==================================================
#  Sunshine Hyprland Dots (2026)
#  Project URL: https://github.com/tak0dan/Sunshine_Hyprland_Dots
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# App enablement and editor selection helpers.

enable_asusctl() {
  local log="$1"
  local cfg_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  if command -v asusctl >/dev/null 2>&1; then
    local target="$cfg_home/hypr/UserConfigs/user_startup.lua"
    if [ -f "$target" ]; then
      if ! grep -q '"rog-control-center"' "$target"; then
        sed -i '/local startup_commands = {/a \  "rog-control-center",' "$target"
        echo "${INFO:-[INFO]} Added rog-control-center to user_startup.lua" 2>&1 | tee -a "$log"
      fi
    fi
  fi
}

enable_blueman() {
  local log="$1"
  local cfg_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  if command -v blueman-applet >/dev/null 2>&1; then
    local target="$cfg_home/hypr/UserConfigs/user_startup.lua"
    if [ -f "$target" ]; then
      if sed -n '/local startup_commands = {/,/}/p' "$target" | grep -q '^[[:space:]]*--[[:space:]]*"blueman-applet"'; then
        sed -i '/local startup_commands = {/,/}/s/^[[:space:]]*--[[:space:]]*\("blueman-applet"\)/\1/' "$target"
        echo "${INFO:-[INFO]} Enabled blueman-applet in user_startup.lua" 2>&1 | tee -a "$log"
      elif ! grep -q '"blueman-applet"' "$target"; then
        sed -i '/local startup_commands = {/a \  "blueman-applet",' "$target"
        echo "${INFO:-[INFO]} Added blueman-applet to user_startup.lua" 2>&1 | tee -a "$log"
      fi
    fi
  fi
}

enable_ags() {
  local log="$1"
  local base="${DOTFILES_DIR:-.}"
  local cfg_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  if command -v ags >/dev/null 2>&1; then
    echo "${INFO:-[INFO]} AGS detected - enabling in startup and refresh scripts" 2>&1 | tee -a "$log"
    local target="$cfg_home/hypr/UserConfigs/user_startup.lua"
    if [ -f "$target" ]; then
      if ! grep -q '"ags"' "$target"; then
        sed -i '/local startup_commands = {/a \  "ags",' "$target"
      fi
    fi
    sed -i '/#ags -q && ags &/s/^#//' "$base/config/hypr/scripts/RefreshNoWaybar.sh" 2>/dev/null || true
    sed -i '/#ags -q && ags &/s/^#//' "$base/config/hypr/scripts/Refresh.sh" 2>/dev/null || true
  fi
}

enable_quickshell() {
  local log="$1"
  local base="${DOTFILES_DIR:-.}"
  if command -v qs >/dev/null 2>&1; then
    echo "${INFO:-[INFO]} Quickshell detected - enabling in refresh scripts" 2>&1 | tee -a "$log"
    sed -i '/#pkill qs && qs &/s/^#//' "$base/config/hypr/scripts/RefreshNoWaybar.sh" 2>/dev/null || true
    sed -i '/#pkill qs && qs &/s/^#//' "$base/config/hypr/scripts/Refresh.sh" 2>/dev/null || true
  fi
}

ensure_keybinds_init() {
  # In Lua mode, keybindings are evaluated dynamically via system_keybinds.lua.
  # KeybindsLayoutInit.sh is obsolete.
  return 0
}

install_terminal_configs() {
  local log="$1"
  local base="${DOTFILES_DIR:-.}"

  # Ghostty
  local GHOSTTY_SRC="$base/config/ghostty/config"
  local GHOSTTY_DIR="${XDG_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}/ghostty"
  local GHOSTTY_DEST="$GHOSTTY_DIR/config"
  if [ -f "$GHOSTTY_SRC" ]; then
    if [ -d "$GHOSTTY_DIR" ]; then
      BACKUP_DIR=$(get_backup_dirname)
      local GHOSTTY_BACKUP="$GHOSTTY_DIR-backup-$BACKUP_DIR"
      if [ ! -d "$GHOSTTY_BACKUP" ]; then
        cp -a "$GHOSTTY_DIR" "$GHOSTTY_BACKUP" 2>&1 | tee -a "$log"
        echo "${NOTE:-[NOTE]} - Backed up Ghostty config to $GHOSTTY_BACKUP." 2>&1 | tee -a "$log"
      fi
    fi
    mkdir -p "$GHOSTTY_DIR"
    install -m 0644 "$GHOSTTY_SRC" "$GHOSTTY_DEST" 2>&1 | tee -a "$log"
    if [ -f "$GHOSTTY_DIR/wallust.conf" ]; then
      sed -i -E 's/^(\\s*palette\\s*=\\s*)([0-9]{1,2}):/\\1\\2=/' "$GHOSTTY_DIR/wallust.conf" 2>&1 | tee -a "$log" || true
    fi

    # Bundled themes: some distros ship Ghostty without its built-in theme
    # collection (share/ghostty/themes), which makes `theme = <name>` fail at
    # launch. Install ours into the user themes dir so the shipped default
    # resolves everywhere. Existing user themes are never overwritten.
    local GHOSTTY_THEMES_SRC="$base/config/ghostty/themes"
    if [ -d "$GHOSTTY_THEMES_SRC" ]; then
      mkdir -p "$GHOSTTY_DIR/themes"
      local theme_file theme_name
      for theme_file in "$GHOSTTY_THEMES_SRC"/*; do
        [ -f "$theme_file" ] || continue
        theme_name="$(basename "$theme_file")"
        if [ -e "$GHOSTTY_DIR/themes/$theme_name" ]; then
          continue
        fi
        cp -f "$theme_file" "$GHOSTTY_DIR/themes/$theme_name" 2>&1 | tee -a "$log" || true
        echo "${OK:-[OK]} - Installed Ghostty theme: ${MAGENTA:-}$theme_name${RESET:-}" 2>&1 | tee -a "$log"
      done
    fi
  else
    echo "${ERROR:-[ERROR]} - $GHOSTTY_SRC not found; skipping Ghostty config install." 2>&1 | tee -a "$log"
  fi

  # WezTerm
  local WEZTERM_SRC="$base/config/wezterm/wezterm.lua"
  local WEZTERM_DIR="${XDG_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}/wezterm"
  local WEZTERM_DEST="$WEZTERM_DIR/wezterm.lua"
  if [ -f "$WEZTERM_SRC" ]; then
    mkdir -p "$WEZTERM_DIR"
    install -m 0644 "$WEZTERM_SRC" "$WEZTERM_DEST" 2>&1 | tee -a "$log"
  else
    echo "${ERROR:-[ERROR]} - $WEZTERM_SRC not found; skipping WezTerm config install." 2>&1 | tee -a "$log"
  fi
}

# Write SUNSHINEDOTS_DEFAULTS.<key> = "<value>" into a user defaults Lua file.
# Replaces an existing uncommented line, or appends one.
set_sunshinedots_default() {
  local file=$1 key=$2 value=$3
  sed -i -E "/^[[:space:]]*SUNSHINEDOTS_DEFAULTS\.${key}[[:space:]]*=/d" "$file"
  printf 'SUNSHINEDOTS_DEFAULTS.%s = "%s"\n' "$key" "$value" >> "$file"
}

apply_editor_selection_to_userconfigs() {
  local log="${1:-/dev/null}"
  local base="${DOTFILES_DIR:-.}"
  local cfg_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  local editor="${SUNSHINEDOTS_SELECTED_EDITOR:-}"
  local visual="${SUNSHINEDOTS_SELECTED_VISUAL:-}"

  [ -z "$editor" ] && [ -z "$visual" ] && return 0

  # The Hyprlang 01-UserDefaults.conf no longer ships (removed with the other
  # .conf files), so the editor/visual default is written to the Lua file only.
  local lua_defaults_files=()
  [ -f "$base/config/hypr/UserConfigs/user_defaults.lua" ] && lua_defaults_files+=("$base/config/hypr/UserConfigs/user_defaults.lua")
  [ -f "$cfg_home/hypr/UserConfigs/user_defaults.lua" ] && lua_defaults_files+=("$cfg_home/hypr/UserConfigs/user_defaults.lua")

  local lf
  for lf in "${lua_defaults_files[@]}"; do
    if [ -n "$editor" ]; then
      set_sunshinedots_default "$lf" edit "$editor"
    fi
    if [ -n "$visual" ]; then
      set_sunshinedots_default "$lf" visual "$visual"
    fi
  done
}

# Fork editor menu: vim, neovim, nano or kate. The chosen editor and nano are
# installed. kate is a GUI editor, so it becomes VISUAL and nano stays EDITOR.
# If the chosen editor is missing after install, nano is used.
choose_default_editor() {
  local log="$1"
  local cfg_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  local user_def_lua="$cfg_home/hypr/UserConfigs/user_defaults.lua"

  if [ "${EXPRESS_MODE:-0}" -eq 1 ] || [ "${RUN_MODE:-}" = "express" ]; then
    echo "${NOTE:-[NOTE]} Express mode: keeping existing editor settings (manage anytime via Rofi Quick Settings: SUPER+SHIFT+E)." 2>&1 | tee -a "$log"
    return 0
  fi

  if [ "${RUN_MODE:-}" = "upgrade" ] && [ -f "$user_def_lua" ]; then
    local current_edit
    current_edit=$(sed -nE 's/^[[:space:]]*SUNSHINEDOTS_DEFAULTS\.edit[[:space:]]*=[[:space:]]*["'"'"']([^"'"'"']*)["'"'"'].*/\1/p' "$user_def_lua" | tail -n1)
    if [ -n "$current_edit" ]; then
      echo "${NOTE:-[NOTE]} Existing editor '$current_edit' preserved from user_defaults.lua (manage anytime via Rofi Quick Settings: SUPER+SHIFT+E)." 2>&1 | tee -a "$log"
      return 0
    fi
  fi

  local choice="" pkg="" cmd="" editor=""
  echo "${INFO:-[INFO]} Choose your default text editor:"
  echo "  1) vim"
  echo "  2) neovim"
  echo "  3) nano   (default)"
  echo "  4) kate   (GUI editor, used as VISUAL)"
  while true; do
    echo -n "${CAT:-[ACTION]} Enter the number of your choice (1-4, Enter = 3): "
    read -r choice
    case "$choice" in
      ""|3) editor=nano; break ;;
      1) editor=vim; break ;;
      2) editor=neovim; break ;;
      4) editor=kate; break ;;
      *) echo "${ERROR:-[ERROR]} Invalid choice. Please enter 1, 2, 3 or 4." ;;
    esac
  done

  # Install the chosen editor plus nano (the fallback).
  if [ "$editor" = nano ]; then
    fork_install_packages "$log" nano || echo "${WARN:-[WARN]} nano could not be installed." 2>&1 | tee -a "$log"
  else
    fork_install_packages "$log" "$editor" nano || echo "${WARN:-[WARN]} ${editor} or nano could not be installed." 2>&1 | tee -a "$log"
  fi

  case "$editor" in
    neovim) cmd=nvim ;;
    *) cmd=$editor ;;
  esac

  if [ "$editor" = kate ]; then
    if command -v kate >/dev/null 2>&1; then
      export SUNSHINEDOTS_SELECTED_VISUAL="kate"
    else
      echo "${WARN:-[WARN]} kate is not installed; VISUAL left unset." 2>&1 | tee -a "$log"
      export SUNSHINEDOTS_SELECTED_VISUAL=""
    fi
    export SUNSHINEDOTS_SELECTED_EDITOR="nano"
    echo "${OK:-[OK]} Default editor set to ${MAGENTA:-}nano${RESET:-} (terminal) with ${MAGENTA:-}kate${RESET:-} as VISUAL." 2>&1 | tee -a "$log"
  else
    if command -v "$cmd" >/dev/null 2>&1; then
      export SUNSHINEDOTS_SELECTED_EDITOR="$cmd"
    else
      echo "${WARN:-[WARN]} ${editor} is not installed; falling back to nano." 2>&1 | tee -a "$log"
      export SUNSHINEDOTS_SELECTED_EDITOR="nano"
    fi
    export SUNSHINEDOTS_SELECTED_VISUAL=""
    echo "${OK:-[OK]} Default editor set to ${MAGENTA:-}${SUNSHINEDOTS_SELECTED_EDITOR}${RESET:-}." 2>&1 | tee -a "$log"
  fi

  apply_editor_selection_to_userconfigs "$log"
}

install_waybar_weather_binary() {
  local log="$1"
  local APP_NAME="waybar-weather"
  local INSTALL_PATH="/usr/bin/${APP_NAME}"
  local ASSET="${SCRIPT_DIR:-.}/assets/${APP_NAME}.gz"

  # Helper: log wrappers may not be defined here; reuse INFO/WARN/ERROR if available
  _log() { echo "[${APP_NAME}] $*" 2>&1 | tee -a "$log"; }
  _warn() { echo "[${APP_NAME}] WARN: $*" 1>&2 | tee -a "$log"; }
  _err() { echo "[${APP_NAME}] ERROR: $*" 1>&2 | tee -a "$log"; }

  # NixOS handled by a separate helper
  if grep -qi '^ID=nixos' /etc/os-release 2>/dev/null; then
    _warn "NixOS detected. Use install_waybar_weather_nixos instead."
    return 0
  fi

  # Sudo handling for /usr/bin and /usr/local/bin
  local SUDO=""
  if [[ $EUID -ne 0 ]]; then
    if command -v sudo >/dev/null 2>&1; then
      SUDO="sudo"
    else
      _err "sudo not available; cannot write to ${INSTALL_PATH} as non-root"
      return 1
    fi
  fi

  if grep -qi '^ID=arch' /etc/os-release 2>/dev/null; then
    if command -v pacman >/dev/null 2>&1 && pacman -Qi waybar-weather >/dev/null 2>&1; then
      _log "waybar-weather already installed via pacman."
      return 0
    fi

    # If no package is installed but a static binary exists, remove it before AUR install
    if [ -x /usr/bin/waybar-weather ] || [ -x /usr/local/bin/waybar-weather ]; then
      _log "Removing waybar-weather static binary"
      ${SUDO} rm -f /usr/bin/waybar-weather /usr/local/bin/waybar-weather || _warn "Failed to remove existing waybar-weather binary."
    fi

    if command -v yay >/dev/null 2>&1; then
      _log "Attempting to install AUR package 'waybar-weather' via yay"
      if yay -S --noconfirm waybar-weather; then
        _log "AUR install succeeded."
        return 0
      else
        _warn "AUR install failed; will fall back to bundled asset."
      fi
    else
      _warn "yay not found on Arch; falling back to bundled asset."
    fi
  fi

  # Asset path validation
  if [[ ! -f "$ASSET" ]]; then
    _err "Asset not found: $ASSET"
    return 1
  fi
  if ! command -v gzip >/dev/null 2>&1; then
    _err "Missing required command: gzip"
    return 1
  fi


  _log "Installing prebuilt binary to ${INSTALL_PATH} from ${ASSET}"
  if ${SUDO} sh -c "tmp=\$(mktemp '${INSTALL_PATH}.XXXXXX') && gzip -dc '$ASSET' > \"\$tmp\" && chmod 0755 \"\$tmp\" && mv -f \"\$tmp\" '${INSTALL_PATH}'"; then
    if "${INSTALL_PATH}" -h >/dev/null 2>&1; then
      _log "Installed ${APP_NAME} successfully."
    else
      _warn "${APP_NAME} installed, but a basic self-check did not run."
    fi
  else
    _err "Failed to install ${APP_NAME} to ${INSTALL_PATH}"
    return 1
  fi
}

# Install waybar-weather on NixOS using Go from the system (no version checks)
install_waybar_weather_nixos() {
  local log="$1"
  local APP_NAME="waybar-weather"
  local DEST="$HOME/.local/bin/${APP_NAME}"

  _log() { echo "[${APP_NAME}] $*" 2>&1 | tee -a "$log"; }
  _warn() { echo "[${APP_NAME}] WARN: $*" 1>&2 | tee -a "$log"; }
  _err() { echo "[${APP_NAME}] ERROR: $*" 1>&2 | tee -a "$log"; }

  if ! grep -qi '^ID=nixos' /etc/os-release 2>/dev/null; then
    _warn "Not NixOS; skipping NixOS-specific build."
    return 0
  fi

  if ! command -v go >/dev/null 2>&1; then
    _err "Go toolchain not found in PATH. Ensure NixOS-Hyprland provides go, then re-run."
    return 1
  fi
  if ! command -v git >/dev/null 2>&1; then
    _err "git not found; install git and retry."
    return 1
  fi

  local tmp
  tmp=$(mktemp -d)
  trap 'rm -rf "${tmp}"' RETURN

  _log "Cloning waybar-weather source"
  if ! git clone --depth 1 https://github.com/wneessen/waybar-weather.git "${tmp}/src" >/dev/null 2>&1; then
    _err "git clone failed"
    return 1
  fi

  if ! (
    cd "${tmp}/src" || { _err "cd failed"; exit 1; }
    _log "Fetching modules"
    go mod download >/dev/null 2>&1 || _warn "go mod download returned non-zero; continuing"
    _log "Building ${APP_NAME}"
    CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o "${APP_NAME}" ./cmd/${APP_NAME}
  ); then
    _err "go build failed"
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  install -m 0755 "${APP_NAME}" "${DEST}" || { _err "install to ${DEST} failed"; return 1; }

  if printf '%s' "$PATH" | grep -q "$HOME/.local/bin"; then
    :
  else
    _warn "~/.local/bin is not in PATH; add it so Waybar can find ${APP_NAME}."
  fi

  if "${DEST}" -h >/dev/null 2>&1; then
    _log "Installed ${APP_NAME} to ${DEST}"
  else
    _warn "${APP_NAME} installed, but a basic self-check did not run."
  fi
}

# Wrapper: choose NixOS builder or non-NixOS installer automatically
install_waybar_weather() {
  local log="$1"
  if grep -qi '^ID=nixos' /etc/os-release 2>/dev/null; then
    install_waybar_weather_nixos "$log"
  else
    install_waybar_weather_binary "$log"
  fi
}

# Install assets/waybar-launcher.sh as /usr/local/bin/waybar, ahead of /usr/bin
# in the session PATH. A bare `waybar` (rofi run mode, a terminal) then starts
# the dots' bar through WaybarStartup.sh instead of the stock one. A file there
# without our marker belongs to someone else and is left alone.
install_waybar_launcher() {
  local log="${1:-/dev/null}"
  local asset="${SCRIPT_DIR:-.}/assets/waybar-launcher.sh"
  local dest="/usr/local/bin/waybar"
  local marker="sunshinedots-waybar-launcher"
  local sudo_cmd=""

  if grep -qi '^ID=nixos' /etc/os-release 2>/dev/null; then
    return 0
  fi
  [ -f "$asset" ] || { echo "${WARN:-[WARN]} $asset not found; skipping the waybar launcher." 2>&1 | tee -a "$log"; return 1; }
  if [ -e "$dest" ] && ! grep -q "$marker" "$dest" 2>/dev/null; then
    echo "${NOTE:-[NOTE]} $dest exists and is not ours; leaving it alone." 2>&1 | tee -a "$log"
    return 0
  fi
  if [ "$EUID" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 || { echo "${WARN:-[WARN]} sudo not found; skipping the waybar launcher." 2>&1 | tee -a "$log"; return 1; }
    sudo_cmd="sudo"
  fi
  if $sudo_cmd install -D -m 0755 "$asset" "$dest" 2>&1 | tee -a "$log"; then
    echo "${OK:-[OK]} Installed the waybar launcher at $dest." 2>&1 | tee -a "$log"
  else
    echo "${WARN:-[WARN]} Could not install the waybar launcher at $dest." 2>&1 | tee -a "$log"
    return 1
  fi
}

# Install Oh My Zsh (and bundled theme templates) when zsh is used and OMZ is missing.
# Uses --unattended --keep-zshrc so it never blocks the script, doesn't hijack the user's
# shell immediately, and preserves the existing .zshrc.
ensure_oh_my_zsh() {
  local log="${1:-/dev/null}"
  local user_shell
  user_shell="$(basename "${SHELL:-}")"

  # Only trigger if the user's shell is zsh or zsh is installed
  if [ "$user_shell" != "zsh" ] && ! command -v zsh >/dev/null 2>&1; then
    return 0
  fi

  # Skip if Oh My Zsh is already installed in any standard location
  local candidate
  for candidate in \
    "${ZSH:-}" \
    "$HOME/.oh-my-zsh" \
    "${ZDOTDIR:-$HOME}/.oh-my-zsh" \
    "${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh" \
    "/usr/share/oh-my-zsh" \
    "/usr/share/ohmyzsh" \
    "/opt/oh-my-zsh"; do
    if [ -n "$candidate" ] && [ -d "$candidate/themes" ]; then
      echo "${INFO:-[INFO]} Oh My Zsh themes already present at $candidate" 2>&1 | tee -a "$log"
      return 0
    fi
  done

  # Verify network / download tools before attempting install
  if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo "${WARN:-[WARN]} curl/wget not found; cannot install Oh My Zsh theme templates." 2>&1 | tee -a "$log"
    return 1
  fi
  if ! command -v git >/dev/null 2>&1; then
    echo "${WARN:-[WARN]} git not found; cannot install Oh My Zsh theme templates." 2>&1 | tee -a "$log"
    return 1
  fi

  echo "${INFO:-[INFO]} Oh My Zsh not found - installing theme templates to ~/.oh-my-zsh..." 2>&1 | tee -a "$log"

  local install_cmd
  if command -v curl >/dev/null 2>&1; then
    install_cmd='curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
  else
    install_cmd='wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
  fi

  # Run unattended without changing the default shell or overwriting .zshrc
  if sh -c "$($install_cmd)" "" --unattended --keep-zshrc 2>&1 | tee -a "$log"; then
    echo "${OK:-[OK]} Oh My Zsh theme templates installed successfully." 2>&1 | tee -a "$log"
    return 0
  else
    echo "${WARN:-[WARN]} Oh My Zsh installation failed; theme switcher may only show 'Random'." 2>&1 | tee -a "$log"
    return 1
  fi
}
