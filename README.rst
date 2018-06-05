acpilight: a backward-compatibile xbacklight replacement
========================================================

"acpilight" is a backward-compatibile replacement for xbacklight_ that uses the
ACPI interface to set the display brightness. On modern laptops "acpilight" can
control both display and keyboard backlight uniformly on either X11, the
console or Wayland.


Motivation
----------

On some modern laptops "XRandR" might lack the ability to set the display
brightness. This capability was moved/unified to the kernel's ACPI interface,
via ``/sys/class/backlight/``.

"acpilight" provides a drop-in replacement for the ``xbacklight`` command that
uses the ACPI interface instead of "XRandR", allowing old scripts to run. As a
result, ``xbacklight`` can subsequently be used also from the console and
Wayland (X11 is not used at all).

When paired with the ddcci-backlight_ kernel module, the backlight of most
professional external monitors can be controlled as well.


Installation
------------

If you have ``make`` available, to install the executable, man page, and udev 
rules; run::

  sudo make install

Setup
-----

Normally, users are prohibited to alter files in the ``sys`` filesystem. It's
advisable (and *recommended*) to setup an "udev" rule to allow users in the
"video" group to set the display brightness.

To do so, place a file in ``/etc/udev/rules.d/90-backlight.rules`` containing::

  SUBSYSTEM=="backlight", ACTION=="add", \
    RUN+="/bin/chgrp video %S%p/brightness", \
    RUN+="/bin/chmod g+w %S%p/brightness"

to setup the relevant permissions at boot time. These rules are *very*
conservative: only the display brightness can be controlled, and nothing else.
**Do not set suid permissions on xbacklight!** Similarly, running
``xbacklight`` under ``sudo`` is pointless (there's simply no reason to).

Keyboard backlight control is also available on certain laptop models via the
"leds" subsystem. The following laptop models are known to have a controllable
keyboard backlight:

- Lenovo ThinkPad: ``-ctrl tpacpi::kbd_backlight``
- Apple MacBook Pro: ``-ctrl smc::kbd_backlight``
- Dell Latitude/XPS: ``-ctrl dell::kbd_backlight``
- Asus N-Series Notebooks: ``-ctrl asus::kbd_backlight``

The following rules allow users in the video group to set the keyboard
backlight as well::

  SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
    RUN+="/bin/chgrp video %S%p/brightness", \
    RUN+="/bin/chmod g+w %S%p/brightness"

Please report if other laptops have working interfaces to control the keyboard
backlight.

If you have an external monitor with which supports the DDC/CI protocol,
backlight control can be enabled by installing the `appropriate drivers
<ddcci-backlight_>`_ and loading the ``ddcci-backlight`` module at boot
time. On Debian, this is done by installing the ``ddcci-dkms`` package
and then appending ``ddcci-backlight`` to ``/etc/modules``.


Differences from xbacklight
---------------------------

The original "xbacklight" sets the display brightness of the current
``$DISPLAY``, whereas "acpilight" ignores ``$DISPLAY`` completely and sets the
brightness of the first device found in ``/sys/class/backlight`` by default. On
systems with multiple panels, they might differ.

Use ``xbacklight -list`` to see the full list of available devices that can be
controlled; then use the ``-ctrl`` flag to control them individually.

"acpilight" can always *query*, but might not necessarily be allowed to *set*
the brightness of all listed devices depending on the current user and
permissions. See the setup section above to set the permissions correctly.

"acpilight" doesn't fade: the requested brightness is set immediately by
default. For smooth transitions, specify the number of fading steps (using
``-steps``) or, more conveniently, the fading frame rate (``-fps``).


Authors and Copyright
---------------------

| "acpilight" is distributed under GPLv3+ (see COPYING) WITHOUT ANY WARRANTY.
| Copyright(c) 2016-2017 by wave++ "Yuri D'Elia" <wavexx@thregr.org>.

.. _xbacklight: http://cgit.freedesktop.org/xorg/app/xbacklight
.. _ddcci-backlight: https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux
