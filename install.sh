#!/usr/bin/env bash
# ==============================================================================
# Sinsemoji Universal Installer Script (Lilith Linux Distro Packaging)
#
# Upstream Application: Simplemoji by Sergio Ribera
# (https://github.com/SergioRibera/Simplemoji)
#
# Supports:
#   1. System-wide install (requires root / sudo): installs to /usr or /usr/local
#   2. User-local install (no root required): installs to ~/.local
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

log_info()  { echo -e "${GREEN}[✔]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
log_step()  { echo -e "\n${BLUE}═══ $* ═══${NC}"; }

MODE="user"
if [[ $EUID -eq 0 ]]; then
    MODE="system"
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --system)
            MODE="system"
            shift
            ;;
        --user)
            MODE="user"
            shift
            ;;
        *)
            echo "Usage: $0 [--user | --system]"
            exit 1
            ;;
    esac
done

if [[ "$MODE" == "system" ]]; then
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: System-wide install requires root. Run with sudo: sudo $0 --system${NC}" >&2
        exit 1
    fi
    PREFIX="/usr"
    BINDIR="$PREFIX/bin"
    DATADIR="$PREFIX/share"
    SYSCONFDIR="/etc"
    log_step "Installing Sinsemoji System-Wide to $PREFIX"
else
    PREFIX="$HOME/.local"
    BINDIR="$PREFIX/bin"
    DATADIR="$PREFIX/share"
    SYSCONFDIR="$HOME/.config"
    log_step "Installing Sinsemoji for User: $USER (Prefix: $PREFIX)"
fi

# 1. Install Binaries
mkdir -p "$BINDIR"
install -m 755 "$SCRIPT_DIR/bin/simplemoji" "$BINDIR/simplemoji"
install -m 755 "$SCRIPT_DIR/bin/sinsemoji" "$BINDIR/sinsemoji"
ln -sf sinsemoji "$BINDIR/sinsemoji-picker"
log_info "Installed binaries to $BINDIR (sinsemoji, sinsemoji-picker, simplemoji)"

# 2. Install Desktop Entry
mkdir -p "$DATADIR/applications"
install -m 644 "$SCRIPT_DIR/desktop/sinsemoji.desktop" "$DATADIR/applications/sinsemoji.desktop"
log_info "Installed desktop entry to $DATADIR/applications/sinsemoji.desktop"

# 3. Install Icons
for s in 16 24 32 48 64 128 256 512 1024; do
    if [ -f "$SCRIPT_DIR/icons/hicolor/${s}x${s}/apps/sinsemoji.png" ]; then
        mkdir -p "$DATADIR/icons/hicolor/${s}x${s}/apps"
        install -m 644 "$SCRIPT_DIR/icons/hicolor/${s}x${s}/apps/sinsemoji.png" "$DATADIR/icons/hicolor/${s}x${s}/apps/sinsemoji.png"
    fi
done
log_info "Installed Sinsemoji icons to $DATADIR/icons/hicolor"

# 4. Configure Shortcuts
if [[ "$MODE" == "system" ]]; then
    # System skeleton for COSMIC
    mkdir -p "$SYSCONFDIR/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1"
    install -m 644 "$SCRIPT_DIR/config/cosmic/custom-shortcuts.ron" "$SYSCONFDIR/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom"

    # GNOME Schema override
    if [ -d "$DATADIR/glib-2.0/schemas" ]; then
        install -m 644 "$SCRIPT_DIR/config/gnome/99_sinsemoji.gschema.override" "$DATADIR/glib-2.0/schemas/99_sinsemoji.gschema.override"
        glib-compile-schemas "$DATADIR/glib-2.0/schemas" 2>/dev/null || true
    fi
    log_info "Configured system-wide skeleton shortcuts"
else
    # User COSMIC shortcuts
    COSMIC_SHORTCUTS_DIR="$HOME/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1"
    if [ -d "$HOME/.config/cosmic" ]; then
        mkdir -p "$COSMIC_SHORTCUTS_DIR"
        CUSTOM_FILE="$COSMIC_SHORTCUTS_DIR/custom"
        if [ ! -f "$CUSTOM_FILE" ]; then
            install -m 644 "$SCRIPT_DIR/config/cosmic/custom-shortcuts.ron" "$CUSTOM_FILE"
        else
            # Update custom shortcuts for Sinsemoji
            python3 -c "
with open('$CUSTOM_FILE', 'r') as f:
    lines = f.readlines()
# Remove any old simplemoji entries
new_lines = []
skip = False
for line in lines:
    if 'Simplemoji' in line or 'simplemoji' in line:
        pass
    new_lines.append(line)
c = ''.join(new_lines)
if 'Sinsemoji' not in c:
    c = c.rstrip()
    if c.endswith('}'):
        c = c[:-1].rstrip() + '''
    (
        modifiers: [
            Ctrl,
        ],
        key: \"e\",
        description: Some(\"Sinsemoji\"),
    ): Spawn(\"sinsemoji\"),
    (
        modifiers: [
            Alt,
        ],
        key: \"e\",
        description: Some(\"Sinsemoji (Alt+e fallback)\"),
    ): Spawn(\"sinsemoji\"),
}
'''
with open('$CUSTOM_FILE', 'w') as f:
    f.write(c)
"
        fi
        log_info "Configured COSMIC desktop shortcuts for Sinsemoji (Ctrl+e / Alt+e)"
    fi
fi

# Update caches
update-desktop-database "$DATADIR/applications" 2>/dev/null || true
gtk-update-icon-cache "$DATADIR/icons/hicolor" 2>/dev/null || true

log_step "Installation Complete!"
echo "Launch command: sinsemoji"
echo "Global Hotkey:  Ctrl+e (or Alt+e)"
