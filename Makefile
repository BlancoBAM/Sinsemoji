PREFIX ?= /usr
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
SYSCONFDIR ?= /etc

all:
	@echo "Sinsemoji — Lilith Linux Distro Packaging for Simplemoji."
	@echo "Run 'make install' (with optional DESTDIR and PREFIX) to install."
	@echo "Run 'make deb' to build a Debian/Ubuntu/Lilith package."

install:
	# Install binaries
	install -d "$(DESTDIR)$(BINDIR)"
	install -m 755 bin/simplemoji "$(DESTDIR)$(BINDIR)/simplemoji"
	install -m 755 bin/sinsemoji "$(DESTDIR)$(BINDIR)/sinsemoji"
	ln -sf sinsemoji "$(DESTDIR)$(BINDIR)/sinsemoji-picker"

	# Install desktop entry
	install -d "$(DESTDIR)$(DATADIR)/applications"
	install -m 644 desktop/sinsemoji.desktop "$(DESTDIR)$(DATADIR)/applications/sinsemoji.desktop"

	# Install icons
	for s in 16 24 32 48 64 128 256 512 1024; do \
		if [ -f "icons/hicolor/$${s}x$${s}/apps/sinsemoji.png" ]; then \
			install -d "$(DESTDIR)$(DATADIR)/icons/hicolor/$${s}x$${s}/apps"; \
			install -m 644 "icons/hicolor/$${s}x$${s}/apps/sinsemoji.png" "$(DESTDIR)$(DATADIR)/icons/hicolor/$${s}x$${s}/apps/sinsemoji.png"; \
		fi \
	done

	# Install COSMIC desktop configuration
	install -d "$(DESTDIR)$(SYSCONFDIR)/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1"
	install -m 644 config/cosmic/custom-shortcuts.ron "$(DESTDIR)$(SYSCONFDIR)/skel/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom"

	# Install GNOME schema override
	install -d "$(DESTDIR)$(DATADIR)/glib-2.0/schemas"
	install -m 644 config/gnome/99_sinsemoji.gschema.override "$(DESTDIR)$(DATADIR)/glib-2.0/schemas/99_sinsemoji.gschema.override"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/sinsemoji"
	rm -f "$(DESTDIR)$(BINDIR)/sinsemoji-picker"
	rm -f "$(DESTDIR)$(BINDIR)/simplemoji"
	rm -f "$(DESTDIR)$(DATADIR)/applications/sinsemoji.desktop"
	for s in 16 24 32 48 64 128 256 512 1024; do \
		rm -f "$(DESTDIR)$(DATADIR)/icons/hicolor/$${s}x$${s}/apps/sinsemoji.png"; \
	done
	rm -f "$(DESTDIR)$(DATADIR)/glib-2.0/schemas/99_sinsemoji.gschema.override"

icons:
	python3 scripts/generate_icons.py

deb:
	./packaging/build_deb.sh

clean:
	rm -rf dist packaging/deb_root

.PHONY: all install uninstall icons deb clean
