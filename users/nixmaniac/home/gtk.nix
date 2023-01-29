{
  gtk.enable = true;
  gtk.gtk2.extraConfig = ''
    gtk-key-theme-name = "Emacs"
    binding "gtk-emacs-text-entry"
    {
      bind "<alt>BackSpace" { "delete-from-cursor" (word-ends, -1) }
    }
  '';
}
