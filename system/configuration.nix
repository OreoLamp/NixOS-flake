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

    # Enable nix-command
    nix.settings.experimental-features = [ "nix-command" ];

    imports = [ 
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
    time.timeZone = "Europe/Helsinki";
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
        localuser = null;
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
	        # Basic utilities
            neofetch
            piper
            # Editors
            libsForQt5.okular
            inkscape
            gimp
            audacity
            obs-studio
            qbittorrent
            vscode.fhs
            jetbrains-toolbox
            # Not so basic utilities
            gradience
            peazip
            mullvad-vpn
            mpv
            nomacs
            calibre
            baobab
            font-manager
            # Social media stuff
            signal-desktop
            telegram-desktop
            spotify
            spotifywm
        ]) ++ (with pkgs.gnome; [
            nautilus
            gnome-tweaks
            gnome-shell-extensions
            dconf-editor
        ]) ++ (with pkgs.gnomeExtensions; [
            user-themes
            app-hider
            dash-to-panel
            appindicator
            blur-my-shell
            just-perfection
            gnome-40-ui-improvements
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
    hm.home.stateVersion = "23.05";
    hm.xdg.enable = true;
    hm.home = {
        username = "eero";
        homeDirectory = "/home/eero";
    };

    # Restart systemd user services when switching configs
    hm.systemd.user.startServices = "sd-switch";

    # Yeets the desktop entry for the nix manual
    hm.xdg.desktopEntries = {
        nixos-manual = {
            name = "NixOS Manual";
            noDisplay = true;
        };
    };

    # Font config (oh god help me)
    # Creates a directory with links to all fonts
    # Path: /run/current-system/sw/share/X11/fonts
    fonts.fontDir.enable = true;
    fonts.fontconfig = {
        # Hinting options
        hinting.style = "full";
        subpixel.rgba = "rgb";
        allowBitmaps = false;
        # Font preferences
        defaultFonts = {
            monospace = [
                "JetBrainsMonoNL NerdFont"
                "DejaVuSansM Nerd Font"
                "NotoMono Nerd Font"
                "Noto Sans Mono"
            ];
            sansSerif = [
                "Inter"
                "Noto Sans"
            ];
        };
    };

    # Font packages (oh god there's so many)
    fonts.packages = with pkgs; [
        font-awesome
        helvetica-neue-lt-std
        julia-mono
        nerdfonts
        # Then a massive list of fonts from google-fonts
        (google-fonts.override { fonts = [
            "Abhaya Libre"
            "Advent Pro"
            "Akatab"
            "Akshar"
            "Albert Sans"
            "Alegreya"
            "Alegreya Sans"
            "Alegreya Sans SC"
            "Alegreya SC"
            "Aleo"
            "Alexandria"
            "Alkatra"
            "Almarai"
            "Almendra"
            "Alumni Sans"
            "Amaranth"
            "Amiri"
            "Andada Pro"
            "Andika"
            "Anek Bangla"
            "Anek Devanagari"
            "Anek Gujarati"
            "Anek Gurmukhi"
            "Anek Kannada"
            "Anek Latin"
            "Anek Malayalam"
            "Anek Odia"
            "Anek Tamil"
            "Anek Telugu"
            "Anonymous Pro"
            "Antonio"
            "Anuphan"
            "Anybody"
            "AR One Sans"
            "Archivo"
            "Archivo Narrow"
            "Arima"
            "Arimo"
            "Arsenal"
            "Arvo"
            "Asap"
            "Asap Condensed"
            "Assistant"
            "Athiti"
            "Atkinson Hyperlegible"
            "Atma"
            "Averia Libre"
            "Averia Sans Libre"
            "Averia Serif Libre"
            "Azeret Mono"
            "B612"
            "B612 Mono"
            "Bai Jamjuree"
            "Baloo 2"
            "Baloo Bhai 2"
            "Baloo Bhaijaan 2"
            "Baloo Bhaina 2"
            "Baloo Chettan 2"
            "Baloo Da 2"
            "Baloo Paaji 2"
            "Baloo Tamma 2"
            "Baloo Tammudu 2"
            "Baloo Thambi 2"
            "Balsamiq Sans"
            "Barlow"
            "Barlow Condensed"
            "Barlow Semi Condensed"
            "Battambang"
            "Be Vietnam Pro"
            "Bellota"
            "Bellota Text"
            "Besley"
            "Big Shoulders Display"
            "Big Shoulders Inline Display"
            "Big Shoulders Inline Text"
            "Big Shoulders Stencil Display"
            "Big Shoulders Stencil Text"
            "Big Shoulders Text"
            "BioRhyme"
            "BioRhyme Expanded"
            "Biryani"
            "Bitter"
            "Blinker"
            "Bodoni Moda"
            "Bricolage Grotesque"
            "Brygada 1918"
            "Cabin"
            "Cabin Condensed"
            "Cairo"
            "Cairo Play"
            "Caladea"
            "Cambay"
            "Cantarell"
            "Carlito"
            "Catamaran"
            "Caudex"
            "Caveat"
            "Chakra Petch"
            "Changa"
            "Charis SIL"
            "Chathura"
            "Chivo"
            "Chivo Mono"
            "Cinzel"
            "Comfortaa"
            "Comic Neue"
            "Comme"
            "Commissioner"
            "Cormorant"
            "Cormorant Garamond"
            "Cormorant Infant"
            "Cormorant SC"
            "Cormorant Unicase"
            "Cormorant Upright"
            "Courier Prime"
            "Cousine"
            "Crimson Pro"
            "Crimson Text"
            "Cuprum"
            "Dai Banna SIL"
            "Dancing Script"
            "Darker Grotesque"
            "DM Mono"
            "DM Sans"
            "Domine"
            "Dosis"
            "DynaPuff"
            "EB Garamond"
            "Economica"
            "Eczar"
            "Edu NSW ACT Foundation"
            "Edu QLD Beginner"
            "Edu SA Beginner"
            "Edu TAS Beginner"
            "Edu VIC WA NT Beginner"
            "El Messiri"
            "Encode Sans"
            "Encode Sans Condensed"
            "Encode Sans Expanded"
            "Encode Sans SC"
            "Encode Sans Semi Condensed"
            "Encode Sans Semi Expanded"
            "Enriqueta"
            "Epilogue"
            "Exo"
            "Exo 2"
            "Expletus Sans"
            "Fahkwang"
            "Familjen Grotesk"
            "Farro"
            "Faustina"
            "Figtree"
            "Finlandica"
            "Fira Code"
            "Fira Sans"
            "Fira Sans Condensed"
            "Fira Sans Extra Condensed"
            "Foldit"
            "Frank Ruhl Libre"
            "Fraunces"
            "Fredoka"
            "Gabarito"
            "Gantari"
            "Gelasio"
            "Gemunu Libre"
            "Genos"
            "Gentium Book Plus"
            "Gentium Plus"
            "Geologica"
            "Georama"
            "GFS Neohellenic"
            "Glory"
            "Gluten"
            "Golos Text"
            "Gothic A1"
            "Grandstander"
            "Grenze"
            "Grenze Gotisch"
            "Hahmlet"
            "Halant"
            "Handjet"
            "Hanken Grotesk"
            "Hanuman"
            "Harmattan"
            "Heebo"
            "Hepta Slab"
            "Hind"
            "Hind Guntur"
            "Hind Madurai"
            "Hind Siliguri"
            "Hind Vadodara"
            "Ibarra Real Nova"
            "IBM Plex Mono"
            "IBM Plex Sans"
            "IBM Plex Sans Arabic"
            "IBM Plex Sans Condensed"
            "IBM Plex Sans Devanagari"
            "IBM Plex Sans Hebrew"
            "IBM Plex Sans JP"
            "IBM Plex Sans KR"
            "IBM Plex Sans Thai"
            "IBM Plex Sans Thai Looped"
            "IBM Plex Serif"
            "Imbue"
            "Inconsolata"
            "Inknut Antiqua"
            "Inria Sans"
            "Inria Serif"
            "Instrument Sans"
            "Inter"
            "Inter Tight"
            "Istok Web"
            "JetBrains Mono"
            "Josefin Sans"
            "Josefin Slab"
            "Jost"
            "Jura"
            "K2D"
            "Kaisei Tokumin"
            "Kameron"
            "Kanit"
            "Kantumruy Pro"
            "Karla"
            "Karma"
            "Kay Pho Du"
            "Khand"
            "Khula"
            "Kodchasan"
            "Koh Santepheap"
            "KoHo"
            "Kreon"
            "Krub"
            "Kufam"
            "Kulim Park"
            "Kumbh Sans"
            "Labrada"
            "Laila"
            "Lateef"
            "Lato"
            "League Spartan"
            "Lemonada"
            "Lexend"
            "Lexend Deca"
            "Lexend Exa"
            "Lexend Giga"
            "Lexend Mega"
            "Lexend Peta"
            "Lexend Tera"
            "Lexend Zetta"
            "Libre Bodoni"
            "Libre Franklin"
            "Linefont"
            "Lisu Bosa"
            "Literata"
            "Livvic"
            "Lobster Two"
            "Londrina Solid"
            "Lora"
            "M PLUS 1"
            "M PLUS 1 Code"
            "M PLUS 1p"
            "M PLUS 2"
            "M PLUS Code Latin"
            "M PLUS Rounded 1c"
            "Mada"
            "Maitree"
            "Mali"
            "Manrope"
            "Manuale"
            "Marhey"
            "Markazi Text"
            "Martel"
            "Martel Sans"
            "Martian Mono"
            "Marvel"
            "Maven Pro"
            "Merienda"
            "Merriweather"
            "Merriweather Sans"
            "Mirza"
            "Mitr"
            "Mohave"
            "Montagu Slab"
            "Montserrat"
            "Montserrat Alternates"
            "Mukta"
            "Mukta Mahee"
            "Mukta Malar"
            "Mukta Vaani"
            "Mulish"
            "Murecho"
            "MuseoModerno"
            "Neuton"
            "Newsreader"
            "Niramit"
            "Nobile"
            "Nokora"
            "Noticia Text"
            "Noto Emoji"
            "Noto Kufi Arabic"
            "Noto Naskh Arabic"
            "Noto Nastaliq Urdu"
            "Noto Rashi Hebrew"
            "Noto Sans"
            "Noto Sans Adlam"
            "Noto Sans Adlam Unjoined"
            "Noto Sans Arabic"
            "Noto Sans Armenian"
            "Noto Sans Balinese"
            "Noto Sans Bamum"
            "Noto Sans Bassa Vah"
            "Noto Sans Bengali"
            "Noto Sans Canadian Aboriginal"
            "Noto Sans Cham"
            "Noto Sans Cherokee"
            "Noto Sans Devanagari"
            "Noto Sans Display"
            "Noto Sans Ethiopic"
            "Noto Sans Georgian"
            "Noto Sans Gujarati"
            "Noto Sans Gunjala Gondi"
            "Noto Sans Gurmukhi"
            "Noto Sans Hanifi Rohingya"
            "Noto Sans Hebrew"
            "Noto Sans Hong Kong"
            "Noto Sans Japanese"
            "Noto Sans Javanese"
            "Noto Sans Kannada"
            "Noto Sans Kawi"
            "Noto Sans Kayah Li"
            "Noto Sans Khmer"
            "Noto Sans Korean"
            "Noto Sans Lao"
            "Noto Sans Lao Looped"
            "Noto Sans Lisu"
            "Noto Sans Malayalam"
            "Noto Sans Medefaidrin"
            "Noto Sans Meetei Mayek"
            "Noto Sans Mono"
            "Noto Sans Myanmar"
            "Noto Sans N'Ko Unjoined"
            "Noto Sans Nag Mundari"
            "Noto Sans New Tai Lue"
            "Noto Sans Ol Chiki"
            "Noto Sans Oriya"
            "Noto Sans Simplified Chinese"
            "Noto Sans Sinhala"
            "Noto Sans Sora Sompeng"
            "Noto Sans Sundanese"
            "Noto Sans Symbols"
            "Noto Sans Syriac"
            "Noto Sans Syriac Eastern"
            "Noto Sans Tai Tham"
            "Noto Sans Tamil"
            "Noto Sans Tangsa"
            "Noto Sans Telugu"
            "Noto Sans Thaana"
            "Noto Sans Thai"
            "Noto Sans Thai Looped"
            "Noto Sans Traditional Chinese"
            "Noto Sans Vithkuqi"
            "Noto Serif"
            "Noto Serif Armenian"
            "Noto Serif Bengali"
            "Noto Serif Devanagari"
            "Noto Serif Display"
            "Noto Serif Ethiopic"
            "Noto Serif Georgian"
            "Noto Serif Gujarati"
            "Noto Serif Gurmukhi"
            "Noto Serif Hebrew"
            "Noto Serif Hong Kong"
            "Noto Serif Japanese"
            "Noto Serif Kannada"
            "Noto Serif Khmer"
            "Noto Serif Khojki"
            "Noto Serif Korean"
            "Noto Serif Lao"
            "Noto Serif Malayalam"
            "Noto Serif Myanmar"
            "Noto Serif Nyiakeng Puachue Hmong"
            "Noto Serif Oriya"
            "Noto Serif Simplified Chinese"
            "Noto Serif Sinhala"
            "Noto Serif Tamil"
            "Noto Serif Telugu"
            "Noto Serif Thai"
            "Noto Serif Tibetan"
            "Noto Serif Toto"
            "Noto Serif Traditional Chinese"
            "Noto Serif Vithkuqi"
            "Noto Serif Yezidi"
            "Noto Traditional Nüshu"
            "Nunito"
            "Nunito Sans"
            "Onest"
            "Open Sans"
            "Orbitron"
            "Oswald"
            "Outfit"
            "Overlock"
            "Overpass"
            "Overpass Mono"
            "Oxanium"
            "Palanquin"
            "Palanquin Dark"
            "Pathway Extreme"
            "Petrona"
            "Philosopher"
            "Phudu"
            "Piazzolla"
            "Pixelify Sans"
            "Playfair"
            "Playfair Display"
            "Playfair Display SC"
            "Playpen Sans"
            "Plus Jakarta Sans"
            "Podkova"
            "Półtawski Nowy"
            "Pontano Sans"
            "Poppins"
            "Pridi"
            "Prompt"
            "Proza Libre"
            "PT Sans"
            "PT Serif"
            "Public Sans"
            "Puritan"
            "Quantico"
            "Quattrocento Sans"
            "Quicksand"
            "Radio Canada"
            "Rajdhani"
            "Raleway"
            "Rambla"
            "Rasa"
            "Readex Pro"
            "Recursive"
            "Red Hat Display"
            "Red Hat Mono"
            "Red Hat Text"
            "Red Rose"
            "Reem Kufi"
            "Reem Kufi Fun"
            "REM"
            "Roboto"
            "Roboto Condensed"
            "Roboto Flex"
            "Roboto Mono"
            "Roboto Serif"
            "Roboto Slab"
            "Rokkitt"
            "Rosario"
            "Rubik"
            "Ruda"
            "Ruwudu"
            "Saira"
            "Saira Condensed"
            "Saira Extra Condensed"
            "Saira Semi Condensed"
            "Sansita"
            "Sansita Swashed"
            "Sarabun"
            "Sarpanch"
            "Scada"
            "Scheherazade New"
            "Schibsted Grotesk"
            "Sen"
            "Shantell Sans"
            "Share"
            "Shippori Mincho"
            "Shippori Mincho B1"
            "Signika"
            "Signika Negative"
            "Simonetta"
            "Smooch Sans"
            "Sofia Sans"
            "Sofia Sans Condensed"
            "Sofia Sans Extra Condensed"
            "Sofia Sans Semi Condensed"
            "Solway"
            "Sometype Mono"
            "Sono"
            "Sora"
            "Source Code Pro"
            "Source Sans 3"
            "Source Serif 4"
            "Space Grotesk"
            "Space Mono"
            "Spectral"
            "Spectral SC"
            "Spline Sans"
            "Spline Sans Mono"
            "Stick No Bills"
            "STIX Two Text"
            "Suwannaphum"
            "Syne"
            "Tajawal"
            "Taviraj"
            "Teko"
            "Tektur"
            "Texturina"
            "Thasadith"
            "Tillana"
            "Tinos"
            "Titillium Web"
            "Tomorrow"
            "Tourney"
            "Trirong"
            "Trispace"
            "Truculenta"
            "Tsukimi Rounded"
            "Turret Road"
            "Ubuntu"
            "Ubuntu Mono"
            "Unbounded"
            "Unna"
            "Urbanist"
            "Varta"
            "Vazirmatn"
            "Vesper Libre"
            "Victor Mono"
            "Volkhov"
            "Vollkorn"
            "Vollkorn SC"
            "Wavefont"
            "Wix Madefor Display"
            "Wix Madefor Text"
            "Work Sans"
            "Yaldevi"
            "Yanone Kaffeesatz"
            "Yantramanav"
            "Yrsa"
            "Ysabeau"
            "Ysabeau Infant"
            "Ysabeau Office"
            "Ysabeau SC"
            "Zen Kaku Gothic Antique"
            "Zen Kaku Gothic New"
            "Zen Maru Gothic"
            "Zen Old Mincho"
            "Zilla Slab"
        ]; })
    ];

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

    # zsh config, done in home-manager because home-manager is actually moronic
    # TODO: This whole shitshow in .zshrc, and just yeet it in the correct place with home-manager
    # (fuck home-manager)
    programs.zsh.enable = true;
    hm.programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        dotDir = ".config/zsh";

        # History stuff
        history = {
            ignoreDups = false;
            ignoreSpace = false;
            path = "$HOME/.config/zsh/zsh_history.txt";
            save = 1000000000;
            size = 1000000000;
            share = false;
        };

        # Syntax highlighting
        syntaxHighlighting.enable = true;

        # Extra options to enable in .zshrc
        initExtra = "
            setopt APPEND_HISTORY
            setopt HIST_LEX_WORDS
            setopt HIST_VERIFY
            setopt INC_APPEND_HISTORY_TIME
        ";
    };

    # Enables cliphist
    hm.services.cliphist.enable = true;

    # Kitty config
    hm.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        theme = "Tokyo Night";
    };

    # Firefox enablement
    programs.firefox.enable = true; 
    hm.programs.firefox.enable = true;


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
