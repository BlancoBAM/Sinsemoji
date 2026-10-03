# Simplemoji — Distro Edition (Lilith / COSMIC / Freedesktop)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux%20(x86__64)-purple.svg)](#)
[![Built With Slint](https://img.shields.io/badge/Built%20With-Slint%20%2B%20Rust-blue.svg)](#)

A pre-packaged, distro-ready distribution of [Simplemoji](https://github.com/SergioRibera/Simplemoji), customized with a dark black aesthetic, vibrant magenta/purple accents, global hotkey bindings, Freedesktop launcher, and multi-format Linux packaging support.

---

## 🎨 Distro Theme Specifications

| Property | Value | Description |
| :--- | :--- | :--- |
| **Background Color** | `#000000` | Pure deep dark black background |
| **Accent / Primary** | `#a832a6` | Magenta / Neon Purple secondary accent |
| **Global Hotkey** | `Ctrl + e` | Primary system-wide shortcut |
| **Fallback Hotkey** | `Alt + e` | Alternative shortcut (ideal if terminal readline uses Ctrl+e) |
| **Launcher Command** | `simplemoji-picker` | Executable wrapper with configured options |
| **Binary Command** | `simplemoji` | Raw Rust binary accepting CLI flags |

---

## 🚀 Quick Start & Installation

### Option 1: Direct Host Installation (Current User)
```bash
./install.sh --user
```
Installs binaries to `~/.local/bin`, icons to `~/.local/share/icons/hicolor/`, desktop entry to `~/.local/share/applications/`, and binds `Ctrl+e` / `Alt+e` in COSMIC shortcuts.

### Option 2: System-Wide Installation (Root / Sudo)
```bash
sudo ./install.sh --system
# or
sudo make install PREFIX=/usr
```

### Option 3: Install via Pre-Built Debian Package (`.deb`)
```bash
# Build the package
./packaging/build_deb.sh

# Install the built package
sudo dpkg -i dist/simplemoji_1.2.5_amd64.deb
```

---

## 📦 Pushing to Remote GitHub Repository

This folder is already a self-contained Git repository. To publish it to your remote GitHub account:

```bash
cd ~/simplemoji-distro

# 1. Add your remote GitHub repository URL
git remote add origin git@github.com:<YOUR_USERNAME>/<YOUR_REPOSITORY>.git
# (or with HTTPS: https://github.com/<YOUR_USERNAME>/<YOUR_REPOSITORY>.git)

# 2. Ensure main branch is selected
git branch -M main

# 3. Push all commits and tags
git push -u origin main
```

---

## 🛠 Distro Packaging Guide

### 1. Debian / Ubuntu / Lilith Linux (`.deb`)
The `packaging/build_deb.sh` script generates a distribution `.deb` package adhering to Debian guidelines:
```bash
./packaging/build_deb.sh
```
Output will be placed in `dist/simplemoji_1.2.5_amd64.deb`.

### 2. Arch Linux (`PKGBUILD`)
```bash
cd packaging/arch
makepkg -si
```

### 3. Fedora / RHEL (`.spec`)
```bash
rpmbuild -ba packaging/fedora/simplemoji.spec
```

---

## ⌨️ Desktop Environments & Hotkey Configuration

### COSMIC Desktop (System76 / Pop!_OS / Lilith Linux)
The global shortcut is configured in:
- **User Config:** `~/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom`
- **Distro Skeleton:** `/etc/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom`

```ron
{
    (
        modifiers: [
            Ctrl,
        ],
        key: "e",
        description: Some("Simplemoji"),
    ): Spawn("simplemoji-picker"),
    (
        modifiers: [
            Alt,
        ],
        key: "e",
        description: Some("Simplemoji (Alt fallback)"),
    ): Spawn("simplemoji-picker"),
}
```

### GNOME Shell
Shipped schema override: `config/gnome/99_simplemoji.gschema.override`
Install to `/usr/share/glib-2.0/schemas/` and run `glib-compile-schemas`.

### Tiling Window Managers
See `config/window-managers/window-managers.conf` for ready-to-use snippets for:
- **Hyprland:** `bind = CONTROL, E, exec, simplemoji-picker`
- **Sway:** `bindsym Ctrl+e exec simplemoji-picker`
- **i3:** `bindsym Control+e exec --no-startup-id simplemoji-picker`
- **sxhkd / X11:** `ctrl + e` -> `simplemoji-picker`

---

## 📁 Repository Structure

```
simplemoji-distro/
├── .gitignore                      # Git ignore patterns
├── Makefile                        # Universal Makefile (install, deb, icons, clean)
├── README.md                       # Comprehensive guide and documentation
├── install.sh                      # Universal installer (--user or --system)
├── bin/
│   ├── simplemoji                  # 64-bit compiled Rust binary (Simplemoji 1.2.5)
│   └── simplemoji-picker           # Distro wrapper script applying colors
├── desktop/
│   └── simplemoji.desktop          # Freedesktop application launcher entry
├── icons/
│   └── hicolor/                    # Standard icon theme hierarchy
│       ├── scalable/apps/simplemoji.svg
│       ├── 512x512/apps/simplemoji.png
│       ├── 256x256/apps/simplemoji.png
│       ├── 128x128/apps/simplemoji.png
│       ├── 64x64/apps/simplemoji.png
│       ├── 48x48/apps/simplemoji.png
│       ├── 32x32/apps/simplemoji.png
│       ├── 24x24/apps/simplemoji.png
│       └── 16x16/apps/simplemoji.png
├── config/
│   ├── cosmic/                     # COSMIC Desktop shortcut configurations
│   │   ├── custom-shortcuts.ron
│   │   └── 90_simplemoji_defaults.ron
│   ├── gnome/                      # GNOME dconf / gsettings override
│   │   └── 99_simplemoji.gschema.override
│   └── window-managers/            # Hyprland, Sway, i3, sxhkd bindings
│       └── window-managers.conf
├── packaging/
│   ├── build_deb.sh                # Standalone automated Debian builder
│   ├── arch/
│   │   └── PKGBUILD                # Arch Linux package recipe
│   └── fedora/
│       └── simplemoji.spec         # RPM package specification
└── scripts/
    └── generate_icons.py           # Cairo script to regenerate icon assets
```

---

## 📄 License
This packaging and integration profile is released under the [MIT License](LICENSE).
Simplemoji upstream by [Sergio Ribera](https://github.com/SergioRibera/Simplemoji).
