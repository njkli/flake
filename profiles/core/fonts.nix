{ lib, pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override (_: {
        fonts = [
          "InconsolataLGC"
          "Ubuntu"
          "DejaVuSansMono"
          "DroidSansMono"
          "JetBrainsMono"
          "ShareTechMono"
          "UbuntuMono"
          "VictorMono"
        ];
      }))
      dejavu_fonts
      # google-fonts
      roboto
      windows-fonts
      freefont_ttf
      tlwg
      corefonts
      terminus_font
      all-the-icons
    ];

    fontconfig = {
      enable = lib.mkDefault true;
      antialias = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "UbuntuMono Nerd Font Mono" ];
        sansSerif = [ "UbuntuMono Nerd Font Mono" ];
        serif = [ "UbuntuMono Nerd Font Mono" ];
      };
    };
  };
}
