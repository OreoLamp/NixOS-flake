{ pkgs, ... }:
{
  # Add GNOME packages back that are removed due to core tools not being installed
  let packages = with pkgs.gnome; [
    nautilus
    seahorse
  ]; 
  shell-extensions = with pkgs.gnomeExtensions; [
    user-themes
    dash-to-panel
    appindicator
    blur-my-shell
    just-perfection
    gnome-40-ui-improvements
    unite
    quake-mode
  ];

  in
  {
    home.packages = packages ++ shell-extensions
  };
}
