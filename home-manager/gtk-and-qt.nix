{ pkgs, ... }:
{
  programs.gtk = {
    enable = true;
    
    # Enable icon cache
    iconCache.enable = true;
  };

  hm.gtk = {
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
  };

  hm.qt = {
    enable = true;
    platformTheme = "gnome";
  };
}
