Name:           simplemoji
Version:        1.2.5
Release:        1%{?dist}
Summary:        Fast emoji picker written in Rust (Dark Black & #a832a6 Theme)

License:        MIT
URL:            https://github.com/SergioRibera/Simplemoji

%description
Fast emoji picker written in Rust with custom dark black (#000000) and
magenta/purple (#a832a6) branding, desktop integration, and global hotkeys.

%install
make install DESTDIR=%{buildroot} PREFIX=/usr

%files
/usr/bin/simplemoji
/usr/bin/simplemoji-picker
/usr/share/applications/simplemoji.desktop
/usr/share/icons/hicolor/*/apps/simplemoji.*
/usr/share/glib-2.0/schemas/99_simplemoji.gschema.override
/etc/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom

%changelog
* Fri Oct 03 2026 Lilith Linux Core Team <dev@lilith.org> - 1.2.5-1
- Initial distro release
