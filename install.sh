#!/usr/bin/env bash
# ==============================================================================
# Simplemoji Universal Installer Script
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
    log_step "Installing Simplemoji System-Wide to $PREFIX"
else
    PREFIX="$HOME/.local"
    BINDIR="$PREFIX/bin"
    DATADIR="$PREFIX/share"
    SYSCONFDIR="$HOME/.config"
    log_step "Installing Simplemoji for User: $USER (Prefix: $PREFIX)"
fi

# 1. Install Binaries
mkdir -p "$BINDIR"
install -m 755 "$SCRIPT_DIR/bin/simplemoji" "$BINDIR/simplemoji"
install -m 755 "$SCRIPT_DIR/bin/simplemoji-picker" "$BINDIR/simplemoji-picker"
log_info "Installed binaries to $BINDIR"

# 2. Install Desktop Entry
mkdir -p "$DATADIR/applications"
install -m 644 "$SCRIPT_DIR/desktop/simplemoji.desktop" "$DATADIR/applications/simplemoji.desktop"
log_info "Installed desktop entry to $DATADIR/applications"

# 3. Install Icons
mkdir -p "$DATADIR/icons/hicolor/scalable/apps"
install -m 644 "$SCRIPT_DIR/icons/hicolor/scalable/apps/simplemoji.svg" "$DATADIR/icons/hicolor/scalable/apps/simplemoji.svg"

for s in 16 24 32 48 64 128 256 512; do
    if [ -f "$SCRIPT_DIR/icons/hicolor/${s}x${s}/apps/simplemoji.png" ]; then
        mkdir -p "$DATADIR/icons/hicolor/${s}x${s}/apps"
        install -m 644 "$SCRIPT_DIR/icons/hicolor/${s}x${s}/apps/simplemoji.png" "$DATADIR/icons/hicolor/${s}x${s}/apps/simplemoji.png"
    fi
done
log_info "Installed icons to $DATADIR/icons/hicolor"

# 4. Configure Shortcuts
if [[ "$MODE" == "system" ]]; then
    # System skeleton for COSMIC
    mkdir -p "$SYSCONFDIR/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1"
    install -m 644 "$SCRIPT_DIR/config/cosmic/custom-shortcuts.ron" "$SYSCONFDIR/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom"
    
    # GNOME Schema override
    if [ -d "$DATADIR/glib-2.0/schemas" ]; then
        install -m 644 "$SCRIPT_DIR/config/gnome/99_simplemoji.gschema.override" "$DATADIR/glib-2.0/schemas/99_simplemoji.gschema.override"
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
            # If custom exists, check if Simplemoji is already mapped
            if ! grep -q "Simplemoji" "$CUSTOM_FILE" 2>/dev/null; then
                python3 -c "
with open('$CUSTOM_FILE', 'r') as f:
    c = f.read().rstrip()
if c.endswith('}'):
    c = c[:-1].rstrip() + '''
    (
        modifiers: [
            Ctrl,
        ],
        key: \"e\",
        description: Some(\"Simplemoji\"),
    ): Spawn(\"$BINDIR/simplemoji-picker\"),
    (
        modifiers: [
            Alt,
        ],
        key: \"e\",
        description: Some(\"Simplemoji (Alt fallback)\"),
    ): Spawn(\"$BINDIR/simplemoji-picker\"),
}
'''
    with open('$CUSTOM_FILE', 'w') as f:
        f.write(c)
"
            fi
        fi
        log_info "Configured COSMIC desktop shortcut (Ctrl+e / Alt+e)"
    fi
fi

# Update caches
update-desktop-database "$DATADIR/applications" 2>/dev/null || true
gtk-update-icon-cache "$DATADIR/icons/hicolor" 2>/dev/null || true

log_step "Installation Complete!"
echo "You can now launch Simplemoji with: simplemoji-picker"
echo "Global Hotkey: Ctrl+e (or Alt+e)"
