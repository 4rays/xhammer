PREFIX ?= $(HOME)/.local/bin

.PHONY: build install uninstall

build:
	swift build -c release

install: build
	install -m 755 .build/release/xbridge $(PREFIX)/xbridge
	install -m 755 .build/release/xbridged $(PREFIX)/xbridged

uninstall:
	rm -f $(PREFIX)/xbridge $(PREFIX)/xbridged
