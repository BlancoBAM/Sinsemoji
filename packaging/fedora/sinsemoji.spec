Name:           sinsemoji
Version:        1.2.5
Release:        1%{?dist}
Summary:        Fast emoji picker for Lilith Linux (preconfigured Simplemoji upstream)

License:        MIT
URL:            https://github.com/SergioRibera/Simplemoji

Provides:       simplemoji
Obsoletes:      simplemoji

%description
Sinsemoji is a pre-packaged distribution of Simplemoji for Lilith Linux.
Upstream Simplemoji by Sergio Ribera: https://github.com/SergioRibera/Simplemoji
Pre-configured with dark black background (#000000) and magenta/purple accent (#a832a6).

%install
make install DESTDIR=%{buildroot} PREFIX=/usr

%files
/usr/bin/sinsemoji
/usr/bin/sinsemoji-picker
/usr/bin/simplemoji
/usr/share/applications/sinsemoji.desktop
/usr/share/icons/hicolor/*/apps/sinsemoji.png
/usr/share/glib-2.0/schemas/99_sinsemoji.gschema.override
/etc/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom

%changelog
* Fri Oct 03 2026 Lilith Linux Core Team <dev@lilith.org> - 1.2.5-1
- Initial release of Sinsemoji for Lilith Linux
