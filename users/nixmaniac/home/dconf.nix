{ self, osConfig, ... }:

{
  dconf.enable = true;
  dconf.settings = {
    "org/mate/desktop/session".idle-delay = 15;
    "org/mate/desktop/session".show-hidden-apps = true;
    "org/mate/screensaver".mode = "blank-only";
    "org/gtk/settings/file-chooser".sort-directories-first = true;
    "org/mate/desktop/peripherals/mouse".motion-acceleration = 7;

    # TODO: have a touchpad profile instead of this
    "org/mate/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      three-finger-click = 2;
      two-finger-click = 3;
    };

    "org/mate/desktop/peripherals/keyboard/kbd" = {
      layouts = [ "us" "ru\tphonetic_YAZHERTY" "de" ];
      options = [ "grp\tgrp:shifts_toggle" ];
    };

    "org/mate/panel/objects/clock/prefs" = {
      format = "24-hour";
      cities = [ ''<location name="" city="Frankfurt" timezone="Europe/Berlin" latitude="50.049999" longitude="8.600000" code="EDDF" current="false"/>'' ];
    };

    "org/mate/desktop/peripherals/keyboard/indicator" = {
      show-flags = false;
    };

    "org/mate/settings-daemon/plugins/media-keys".power = "<Primary><Alt>End";
    "org/mate/desktop/interface".window-scaling-factor = if (self.lib.isHiDpi osConfig) then 2 else 1;
  };
}
