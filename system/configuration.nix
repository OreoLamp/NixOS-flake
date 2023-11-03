{
    config, 
    pkgs,
    lib,
    inputs,
    outputs,
    ... 
}:
{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Allow non-FOSS packages
  nixpkgs.config.allowUnfree = true;

  # Make nix automatically optimise the store
  nix.settings.auto-optimise-store = true;

  imports =
    [ 
      # Add an alias "hm" for "home-manager.users.eero"
      ( lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "eero" ] )

      # User profile
      inputs.home-manager.nixosModules.home-manager

      # Hardware config
      ./hardware-configuration.nix
    ];


  # ======================== #
  # Bootloader configuration #
  # ======================== #


  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    gfxmodeEfi = "auto";

    # Uses OSProber to find other bootloaders
    useOSProber = true;

    # Makes GRUB use the last booted boot entry by default
    default = "saved";

    # Makes GRUB install to BOOTX64.EFI, the default bootloader
    efiInstallAsRemovable = true;

    # Defines the device where GRUB is installed
    # Has to be "nodev", otherwise nix will install GRUB in BIOS mode (???WHY???)
    device = "nodev";
  };


  # =============================== #
  # System-wide basic configuration #
  # =============================== #


  # Networking config
  networking.hostName = "desktop-nix";
  networking.networkmanager.enable = true;

  # Keyboard layout stuff
  services.xserver = {
    layout = "fi";
    xkbModel = "pc105";
  };
  # Makes console settings follow xkb settings
  console.useXkbConfig = true;

  # Locale and timezone stuff
  time.timezone = "Europe/Helsinki";
  i18n = {
    supportedLocales = [ "all" ];
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };

  # Enables locate services, and uses plocate for them
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "never";
  };

  # System-wide packages that I want always available
  environment.systemPackages = with pkgs; [
    # Basic packages that really should be standard
    file
    strace
    curl
    pciutils
    lshw
    psmisc
    # Conveniences
    du-dust
    unar
    btop
    tmux
    nnn
    nvimpager
    nix-tree
  ];

  # System-wide neovim config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };


  # =========== #
  # User config #
  # =========== #

  users.users.eero = {
    isNormalUser = true;
    description = "Eero Lampela";
    extraGroups = [ "networkmanager" "wheel" ];

    # User packages
    packages = with pkgs; ([
      kitty
      gimp
      libsForQt5.okular
      spotify
      spotifywm
      spotifyd
      vscode.fhs
    ]) ++ (with pkgs.gnome; [
      nautilus
      gnome-tweaks
      gnome-shell-extensions
      dconf-editor
    ]) ++ (with pkgs.gnomeExtensions; [
      dash-to-panel
      appindicator
      blur-my-shell
      just-perfection
      gnome40-ui-improvements
      unite
      quake-mode
    ]);
  };

  # Makes home-manager load stuff
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      eero = import ../home-manager/home.nix;
    };
  };

  # Basic home-manager config
  hm.programs.home-manager.enable = true;
  hm.home = {
    username = "eero";
    homeDirectory = "/home/eero";
  };
  hm.systemd.user.startServices = "sd-switch";
  hm.home.stateVersion = "23.05";

  # Git config
  hm.programs.git = {
    enable = true;
    userName = "Eero Lampela";
    userEmail = "eero.lampela@gmail.com";
    extraConfig = {
      core.pager = "$PAGER";
      diff.algorithm = "minimal";
      merge.guitool = "nvimdiff";
      submodule.fetchJobs = "0";
      init.defaultBranch = "main";
    };
  };

  # Makes zsh the default user shell
  users.defaultUserShell = pkgs.zsh;

  # zsh config
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # History stuff
    histFile = "$HOME/.config/zsh/zsh_history.txt";
    histSize = 1000000000;
    setOptions = [
      "INC_APPEND_HISTORY_TIME"
      "HIST_VERIFY"
      "HIST_LEX_WORDS"
      "APPEND_HISTORY"
    ];
  };

  # More zsh config
  hm.programs.zsh = {
    enable = true;
    # Directory for zsh config files (defaults to $HOME)
    dotDir = ".config/zsh";

    # Makes zsh add lines beginning with spaces to history 
    history.ignoreSpace = false;

    # Disables sharing history, as it's not compatable with INC_APPEND_HISTORY_TIME
    history.share = false;
  };


  # ========================== #
  # Desktop environment config #
  # ========================== #
  

  # For some reason GNOME requires xserver config stuff even on wayland
  services.xserver = {
    # Required even on wayland (bruh)
    enable = true;
    
    # Enables GNOME and gdm (the locks screen)
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Yeets xterm
    excludePackages = with pkgs; [ xterm ];
  };

  # Removes gnome core utilities, I want almost none of them
  services.gnome.core-utilities.enable = false;

  # Yeets gnome-tour
  environment.gnome.excludePackages = with pkgs; [ 
    gnome-tour
    orca
  ];

  # Enables gnome-keyring and seahorse
  security.pam.services.eero.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Config for gtk and qt
  gtk.iconCache.enable = true;
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # Firefox config
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "fi" ];
  };

  # Sound config
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Pipewire stuff for sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable printing via CUPS
  services.printing.enable = true;

  # Enables flatpaks
  services.flatpak.enable = true;
}
