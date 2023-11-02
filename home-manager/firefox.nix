{ inputs, outputs, lib, config, pkgs, ...}:
{
  imports = [( lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "eero"] )];

  # Enables firefox in the first place
  programs.firefox = {
    enable = true;
  };

  programs.firefox.languagePacks = [ "en_US" "fi" ]
}
