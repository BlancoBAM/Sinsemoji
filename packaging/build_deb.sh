#!/usr/bin/env bash
# ==============================================================================
# Build Debian / Ubuntu / Lilith Linux package for Simplemoji
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

PKG_NAME="simplemoji"
PKG_VERSION="1.2.5"
PKG_ARCH="amd64"
DEB_NAME="${PKG_NAME}_${PKG_VERSION}_${PKG_ARCH}.deb"

BUILD_DIR="$ROOT_DIR/packaging/deb_root"
OUTPUT_DIR="$ROOT_DIR/dist"

echo "===> Building Debian package: $DEB_NAME"

rm -rf "$BUILD_DIR"
mkdir -p \
  "$BUILD_DIR/DEBIAN" \
  "$BUILD_DIR/usr/bin" \
  "$BUILD_DIR/usr/share/applications" \
  "$BUILD_DIR/usr/share/icons/hicolor/scalable/apps" \
  "$BUILD_DIR/usr/share/glib-2.0/schemas" \
  "$BUILD_DIR/etc/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1" \
  "$OUTPUT_DIR"

# 1. Install Binaries
install -m 755 "$ROOT_DIR/bin/simplemoji" "$BUILD_DIR/usr/bin/simplemoji"
install -m 755 "$ROOT_DIR/bin/simplemoji-picker" "$BUILD_DIR/usr/bin/simplemoji-picker"

# 2. Install Desktop Entry
install -m 644 "$ROOT_DIR/desktop/simplemoji.desktop" "$BUILD_DIR/usr/share/applications/simplemoji.desktop"

# 3. Install Icons
install -m 644 "$ROOT_DIR/icons/hicolor/scalable/apps/simplemoji.svg" "$BUILD_DIR/usr/share/icons/hicolor/scalable/apps/simplemoji.svg"
for s in 16 24 32 48 64 128 256 512; do
  if [ -f "$ROOT_DIR/icons/hicolor/${s}x${s}/apps/simplemoji.png" ]; then
    mkdir -p "$BUILD_DIR/usr/share/icons/hicolor/${s}x${s}/apps"
    install -m 644 "$ROOT_DIR/icons/hicolor/${s}x${s}/apps/simplemoji.png" "$BUILD_DIR/usr/share/icons/hicolor/${s}x${s}/apps/simplemoji.png"
  fi
done

# 4. Install Desktop Integrations
install -m 644 "$ROOT_DIR/config/cosmic/custom-shortcuts.ron" "$BUILD_DIR/etc/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom"
install -m 644 "$ROOT_DIR/config/gnome/99_simplemoji.gschema.override" "$BUILD_DIR/usr/share/glib-2.0/schemas/99_simplemoji.gschema.override"

# 5. Control File
cat > "$BUILD_DIR/DEBIAN/control" <<EOF
Package: ${PKG_NAME}
Version: ${PKG_VERSION}
Section: utils
Priority: optional
Architecture: ${PKG_ARCH}
Maintainer: Lilith Linux Core Team <dev@lilith.org>
Depends: libc6 (>= 2.34)
Recommends: xclip, wl-clipboard
Homepage: https://github.com/SergioRibera/Simplemoji
Description: Fast emoji picker written in Rust with dark black and purple theme
 Simplemoji is a blazing fast emoji picker built with Slint UI and Rust.
 This package provides a preconfigured distro edition featuring a dark black
 background (#000000), purple accent (#a832a6), desktop launcher, and
 global hotkey integrations (Ctrl+e / Alt+e).
EOF

# 6. Post-install Script
cat > "$BUILD_DIR/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e

if [ "$1" = "configure" ]; then
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database -q /usr/share/applications || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
    fi
    if command -v glib-compile-schemas >/dev/null 2>&1; then
        glib-compile-schemas /usr/share/glib-2.0/schemas || true
    fi
fi

exit 0
EOF
chmod 755 "$BUILD_DIR/DEBIAN/postinst"

# 7. Post-remove Script
cat > "$BUILD_DIR/DEBIAN/postrm" <<'EOF'
#!/bin/sh
set -e

if [ "$1" = "remove" ] || [ "$1" = "purge" ]; then
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database -q /usr/share/applications || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
    fi
    if command -v glib-compile-schemas >/dev/null 2>&1; then
        glib-compile-schemas /usr/share/glib-2.0/schemas || true
    fi
fi

exit 0
EOF
chmod 755 "$BUILD_DIR/DEBIAN/postrm"

# 8. Build Debian Package
dpkg-deb --build --root-owner-group "$BUILD_DIR" "$OUTPUT_DIR/$DEB_NAME"

echo "===> Successfully created: $OUTPUT_DIR/$DEB_NAME"
ls -lh "$OUTPUT_DIR/$DEB_NAME"
