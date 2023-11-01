{ options, config, lib, pkgs, inputs }:

{
  # Add GNOME packages back that are removed due to core tools not being installed
  home.packages = with pkgs.gnome; [
    nautilus
    seahorse
  ] ++ with pkgs.gnomeExtensions; [
    # Add GNOME shell extensions
    user-themes
    dash-to-panel
    appindicator
    blur-my-shell
    just-perfection
    gnome-40-ui-improvements
    unite
    quake-mode
  ];
}
