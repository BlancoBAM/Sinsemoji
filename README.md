# Sinsemoji (Lilith Linux Edition)

<p align="center">
  <img src="assets/sinsemoji.png" alt="Sinsemoji Logo" width="160" height="160" />
</p>

<p align="center">
  <b>Downstream packaging, theme pre-configuration, and desktop integration layer for <a href="https://github.com/SergioRibera/Simplemoji">Simplemoji</a> on Lilith Linux.</b>
</p>

<p align="center">
  <a href="https://github.com/SergioRibera/Simplemoji"><img src="https://img.shields.io/badge/Upstream-SergioRibera%2FSimplemoji-purple.svg?style=flat-square" alt="Upstream Repository"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License: MIT"></a>
  <a href="#"><img src="https://img.shields.io/badge/Platform-Linux%20(x86__64)-red.svg?style=flat-square" alt="Platform"></a>
  <a href="#"><img src="https://img.shields.io/badge/OS%20Target-Lilith%20Linux-black.svg?style=flat-square" alt="Target: Lilith Linux"></a>
</p>

---

> [!IMPORTANT]
> ## ⚠️ Upstream Attribution & Project Scope
> **Sinsemoji is NOT an independent application, fork, or rewrite of Simplemoji, nor does this repository claim any credit for its core development.**
>
> All core application engineering, Rust source code, Slint UI interface, IME injection routines, and clipboard management are 100% the original creation and intellectual property of **[Sergio Ribera](https://github.com/SergioRibera)** and contributors at:
> ### 🔗 **[https://github.com/SergioRibera/Simplemoji](https://github.com/SergioRibera/Simplemoji)**
>
> ### Why does this repository exist?
> This repository exists solely as a **downstream distribution, styling, and OS integration package for [Lilith Linux](https://github.com/s8n)** (and other Linux installations). It bundles the official upstream `simplemoji` binary with:
> 1. **Lilith Dark Theme Presets:** Pure black background (`#000000`) and glowing purple accents (`#a832a6`).
> 2. **Global Hotkeys:** Pre-configured shortcut bindings (`Ctrl+e` / `Alt+e`) for the COSMIC Desktop environment and other window managers.
> 3. **Desktop Launcher & Branding:** Custom `sinsemoji.desktop` launcher entry and dedicated high-resolution icon artwork for the Lilith desktop.
> 4. **Distro Packaging:** Automated `.deb` build scripts, Arch Linux `PKGBUILD`, Fedora `.spec`, and universal `Makefile` for native operating system distribution.

---

## 🎨 Theme & Integration Specifications

| Component | Setting / Path | Description |
| :--- | :--- | :--- |
| **Upstream Software** | [SergioRibera/Simplemoji](https://github.com/SergioRibera/Simplemoji) | Fast emoji picker written in Rust + Slint UI |
| **Lilith Launcher Command** | `sinsemoji` (`/usr/bin/sinsemoji`) | Automatically passes preset theme parameters |
| **Upstream Raw Binary** | `simplemoji` (`/usr/bin/simplemoji`) | Untouched binary for custom CLI flags |
| **Background Color** | `#000000` | Pure deep dark black background |
| **Primary / Accent Color**| `#a832a6` | Vibrant magenta / purple Lilith accent |
| **Primary Hotkey** | `Ctrl + e` | Global shortcut in COSMIC Desktop |
| **Secondary Hotkey** | `Alt + e` | Fallback shortcut (prevents collision with terminal readline) |
| **Desktop Launcher** | `sinsemoji.desktop` | Standard Freedesktop application entry |
| **Icon Suite** | `sinsemoji.png` (16px – 1024px) | Hi-res Lilith Sinsemoji artwork |

---

## 📁 What is Included in this Repository

```
Sinsemoji/
├── assets/
│   └── sinsemoji.png                 # Master high-resolution artwork
├── bin/
│   ├── simplemoji                     # Official compiled upstream Rust ELF binary (v1.2.5)
│   ├── sinsemoji                      # Lilith Linux launcher wrapper (-b '#000000' -m '#a832a6')
│   └── sinsemoji-picker -> sinsemoji  # Convenience compatibility symlink
├── config/
│   ├── cosmic/                        # COSMIC Desktop environment shortcut definitions
│   │   ├── custom-shortcuts.ron       # User shortcut configuration snippet
│   │   └── 90_sinsemoji_defaults.ron  # System-level defaults patch snippet
│   ├── gnome/                         # GNOME dconf / GSettings override
│   │   └── 99_sinsemoji.gschema.override
│   └── window-managers/               # Keybinds for Hyprland, Sway, i3, and sxhkd
│       └── window-managers.conf
├── desktop/
│   └── sinsemoji.desktop              # Freedesktop application launcher entry
├── icons/hicolor/                     # Full multi-size icon hierarchy (16x16 up to 1024x1024)
│   ├── 16x16/apps/sinsemoji.png
│   ├── 24x24/apps/sinsemoji.png
│   ├── 32x32/apps/sinsemoji.png
│   ├── 48x48/apps/sinsemoji.png
│   ├── 64x64/apps/sinsemoji.png
│   ├── 128x128/apps/sinsemoji.png
│   ├── 256x256/apps/sinsemoji.png
│   ├── 512x512/apps/sinsemoji.png
│   └── 1024x1024/apps/sinsemoji.png
├── packaging/
│   ├── build_deb.sh                   # Automated Debian / Ubuntu / Lilith .deb builder
│   ├── arch/
│   │   └── PKGBUILD                   # Arch Linux / Pacman package specification
│   └── fedora/
│       └── sinsemoji.spec             # RPM spec file for Fedora / RHEL
├── scripts/
│   └── generate_icons.py              # Python utility to regenerate all icon sizes from assets
├── Makefile                           # Universal installation and build system
├── install.sh                         # Multi-target installer script (--system or --user)
├── LICENSE                            # MIT License
└── README.md                          # Documentation and upstream credits
```

---

## 🚀 Installation & Usage

### 1. Install via Pre-Built Debian Package (`.deb`)
Recommended for Lilith Linux, Pop!_OS, Debian, and Ubuntu:

```bash
# Build the Debian package:
./packaging/build_deb.sh

# Install with dpkg:
sudo dpkg -i dist/sinsemoji_1.2.5_amd64.deb
```

### 2. Universal System Install (`make install`)
Installs binaries to `/usr/bin`, desktop file to `/usr/share/applications`, icons to `/usr/share/icons/hicolor`, and skeleton shortcuts to `/etc/skel`:

```bash
sudo make install PREFIX=/usr
```

### 3. User-Local Install (No Root Required)
Installs into `~/.local` and configures the active user's COSMIC shortcuts:

```bash
./install.sh --user
```

---

## ⌨️ Desktop Shortcuts & Hotkey Configuration

### COSMIC Desktop (Lilith Linux / Pop!_OS)
Global shortcuts in COSMIC are stored in:
* **Active User:** `~/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom`
* **Default Profile for New Users:** `/etc/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom`

The configuration automatically maps:
```ron
{
    (
        modifiers: [
            Ctrl,
        ],
        key: "e",
        description: Some("Sinsemoji"),
    ): Spawn("sinsemoji"),
    (
        modifiers: [
            Alt,
        ],
        key: "e",
        description: Some("Sinsemoji (Alt fallback)"),
    ): Spawn("sinsemoji"),
}
```

### Other Environments
Snippets for **GNOME**, **Hyprland**, **Sway**, **i3**, and **sxhkd** are provided in `config/window-managers/window-managers.conf` and `config/gnome/`.

---

## 🛠 Building for Linux Distributions

### Debian / Ubuntu / Lilith Linux
```bash
./packaging/build_deb.sh
# Output: dist/sinsemoji_1.2.5_amd64.deb
```

### Arch Linux
```bash
cd packaging/arch
makepkg -si
```

### Fedora / RHEL
```bash
rpmbuild -ba packaging/fedora/sinsemoji.spec
```

---

## 📤 Publishing to Remote GitHub

This directory is an independent, ready-to-push Git repository on the `main` branch. To link it to your remote GitHub account:

```bash
cd /home/s8n/Sinsemoji

# 1. Set your remote repository URL:
git remote add origin git@github.com:<YOUR_USERNAME>/Sinsemoji.git
# (or with HTTPS: https://github.com/<YOUR_USERNAME>/Sinsemoji.git)

# 2. Push to GitHub:
git push -u origin main
```

---

## 📜 Credits & License

* **Core Application & Slint UI:** Created by **Sergio Ribera** ([@SergioRibera](https://github.com/SergioRibera)).  
  Upstream project repository: [https://github.com/SergioRibera/Simplemoji](https://github.com/SergioRibera/Simplemoji)  
  Licensed under the MIT License.
* **Packaging & Lilith Linux Integration:** Maintained by the **Lilith Linux Core Team**.  
  Licensed under the [MIT License](LICENSE).
