{
  # Add GNOME packages back that are removed due to core tools not being installed
  hm.home.packages = (with pkgs.gnome; [
    nautilus
    gnome-tweaks
    gnome-shell-extensions
  ]) ++ (with pkgs.gnomeExtensions; [
    # Add GNOME shell extensions
    user-themes
    dash-to-panel
    appindicator
    blur-my-shell
    just-perfection
    gnome-40-ui-improvements
    unite
    quake-mode
  ]);

  # Enable gnome-keyring and seahorse
  security.pam.services.eero.enableGnomeKeyring = true;
  programs.seahorse.enable = true;
}
