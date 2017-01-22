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

"xbacklight" provides a drop-in replacement for the same command, using the
ACPI interface instead of "XRandR" in order to let old scripts run. As a
result, "xbacklight" can now also be used from the console and Wayland (X11 is
not used at all).


Setup
-----

Normally, users are prohibited to alter files in the ``sys`` filesystem. It's
advisable to setup an "udev" rule to allow users in the "video" group to set
the display brightness.

To do so, place a file in ``/etc/udev/rules.d/90-backlight.rules`` containing::

  SUBSYSTEM=="backlight", ACTION=="add", \
    RUN+="/bin/chgrp video %S%p/brightness", \
    RUN+="/bin/chmod g+w %S%p/brightness"

to setup the relevant permissions at boot time. Keyboard backlight control is
only available on certain laptop models via the "leds" subsystem. Lenovo
ThinkPads are known to work. The following rules allow users in the video group
to set the keyboard backlight as well::

  SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
    RUN+="/bin/chgrp video %S%p/brightness", \
    RUN+="/bin/chmod g+w %S%p/brightness"


Differences from xbacklight
---------------------------

The original "xbacklight" sets the display brightness of the current
``$DISPLAY``, whereas "acpilight" ignores ``$DISPLAY`` completely and sets the
brightness of the first device found in ``/sys/class/backlight`` by default.

Use ``xbacklight -list`` to see the full list of available devices that can be
controlled. ``acpilight`` can always query, but might not necessarily be
allowed to set the brightness of all listed devices depending on the current
permissions.

``acpilight`` doesn't fade: the requested brightness is set immediately by
default. To fade, specify the number of fading steps (using ``-steps``) or,
more conveniently, the fading frame rate (``-fps``).


Authors and Copyright
---------------------

| "acpilight" is distributed under GPLv3+ (see COPYING) WITHOUT ANY WARRANTY.
| Copyright(c) 2016-2017 by wave++ "Yuri D'Elia" <wavexx@thregr.org>.

.. _xbacklight: http://cgit.freedesktop.org/xorg/app/xbacklight
