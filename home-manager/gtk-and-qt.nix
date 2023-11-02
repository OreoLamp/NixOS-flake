{ packages, ... }:
{
  gtk = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
  };
}
