{ inputs, outputs, lib, config, pkgs, ...}:
{
  imports = [( lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "eero" ] )];

  hm.programs.git.userEmail = "eero.lampela@gmail.com";
  hm.programs.git.userName = "Eero Lampela";
}
