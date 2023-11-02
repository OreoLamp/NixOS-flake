{
  hm.gtk = {
    enable = true;
    
    # Enable icon cache
    gtk.iconCache.enable = true;

    # Theme stuff
    hm.iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    hm.iconTheme.name = "Adwaita";
  };

  hm.qt = {
    enable = true;
    platformTheme = "gnome";
  };
}
