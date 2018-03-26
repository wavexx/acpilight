prefix = /usr
datarootdir = $(prefix)/share
datadir = $(datarootdir)
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1
sysconfdir = /etc

.PHONY: install
install: xbacklight xbacklight.1 90-backlight.rules
	$(NORMAL_INSTALL)
	install -vCDt $(DESTDIR)$(bindir) xbacklight
	install -vCDt $(DESTDIR)$(man1dir) xbacklight.1
	install -vCDt $(DESTDIR)$(sysconfdir)/udev/rules.d 90-backlight.rules 
	$(POST_INSTALL)
	udevadm trigger -s backlight -c add

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(bindir)/xbacklight
	rm -f $(DESTDIR)$(man1dir)/xbacklight.1
	rm -f $(DESTDIR)$(sysconfdir)/udev/rules.d/90-backlight.rules
