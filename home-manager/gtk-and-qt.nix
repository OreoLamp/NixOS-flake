{ pkgs, ... }:
{
  gtk = {
    # Enable icon cache
    iconCache.enable = true;
  };

  hm.gtk = {
    enable = true;
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
  };

  hm.qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };
}
