{
    config,
    pkgs,
    lib,
    inputs,
    outputs,
    nix-vscode-extensions,
    ... 
}: 
{
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

    # Allow non-FOSS packages
    nixpkgs.config.allowUnfree = true;

    # Enable nix-command and flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

    # Add support for ntfs drives (for some reason has to be added separately)
    boot.supportedFilesystems = [ "ntfs" ];


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

    # Enables polkit
    security.polkit.enable = true;

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

    # Systemd mount unit for 2tb SSD
    systemd.mounts = [{
        mountConfig = { DirectoryMode = "0755"; };
        description = "2tbSSD mount";
        options = [ "nofail" ];
        after = [ "default.target" ];
        wantedBy = [ "default.target"];
        type = "ntfs-3g";
        what = "/dev/disk/by-uuid/588A45CD8A45A878";
        where = "/media/2tbSSD";
    }];


    # =========== #
    # User config #
    # =========== #


    users.users.eero = {
        isNormalUser = true;
        description = "Eero Lampela";
        extraGroups = [ "networkmanager" "wheel" ];

        # User packages
        packages = with pkgs; ([
            neofetch # System state thing?
            piper # Logitech mouse config
            mpv # Video player
            nomacs # Image viewer with a GUI
            peazip # Archive extractor with a GUI
            firefox # Web browser
            libsForQt5.okular # PDF / other document viewer
            inkscape # Vector graphics editor
            gimp # Image editor
            audacity # Audio / waveform toolbox
            obs-studio # Screen recording
            qbittorrent # Torrents
            jetbrains-toolbox # More code editors
            gradience # Adwaita theme generator
            mullvad-vpn # VPN
            calibre # e-book library
            baobab # Disk space utility
            font-manager # Exactly what the name suggests
            signal-desktop # End to end encrypted messaging platform
            telegram-desktop # Another messaging platform, used for student stuff
            spotify # Music player of choice
            spotifywm # Set spotify window name properly
            spotifyd # Spotify daemon
            glib # I think this fixes flatpak mime issues
            tofi # Launcher / app menu
            eww-wayland # Widgets
            swaylock # Lock screen
            wl-clipboard # Clipboard (duh)
            wayshot # Screenshot tool, faster than grim
            slurp # Select area from screen for wayshot
            cliphist # Clipboard history
            imv # Super light image viewer
            wev # Wayland event viewer, for debugging hyprland mostly
            wlr-randr # Check monitor shit on wayland
            gnupg # For some reason have to manually specify this???
            libsecret # Required for vscode gpg integration
            atuin # Best shell history
            vscode # vscode lol
        ]);
    };

    # Makes electron stuff work better???
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

    # Font config (oh god help me)
    # Creates a directory with links to all fonts
    # Path: /run/current-system/sw/share/X11/fonts
    fonts.enableDefaultPackages = true;
    fonts.enableGhostscriptFonts = true;
    fonts.fontDir.enable = true;
    fonts.fontDir.decompressFonts = true;
    fonts.fontconfig = {
        # Hinting options
        hinting.style = "full";
        subpixel.rgba = "rgb";
        allowBitmaps = false;
        allowType1 = false;
        localConf = "
            <!-- Use Blinker as the default system UI font, with a fallback to Noto Sans UI -->
            <alias>
                <family>system-ui</family>
                <prefer>
                    <family>Blinker</family>
                    <family>Noto Sans UI</family>
                </prefer>
            </alias>
        ";
        # Font preferences, these have lower priority than localConf
        # Here mostly as a fallback in case i fuck up something
        defaultFonts = {
            monospace = [
                "JetBrainsMonoNL NerdFont"
                "Noto Sans Mono"
            ];
            sansSerif = [
                "Noto Sans"
            ];
            serif = [
                "Noto Serif"
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
        
        # Aliases (duh)
        shellAliases = {
            sysrebuild = "sudo nixos-rebuild switch --flake /home/eero/.config/nix#desktop-nix";
        };
    };

    # Atuin stuff
    hm.programs.atuin = {
        enable = true;
        settings = {
            style = "compact";
	        filter_mode_shell_up_key_binding = "directory";
	        show_preview = true;
        };
    };

    # Btop user config
    hm.programs.btop = {
        enable = true;
        settings = {
            color_theme = "tokyo-night";
            update_ms = 1000;
            proc_sorting = "memory";
            proc_cpu_graphs = false;
            proc_filter_kernel = true;
            cpu_graph_lower = "idle";
            swap_disk = false;
            disk_free_priv = true;
            show_io_stat = true;
            io_mode = true;
        };
    };

    # Kitty config
    hm.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        theme = "Tokyo Night";
    };

    # Firefox enablement
    hm.programs.firefox.enable = true;

    # ========================== #
    # Desktop environment config #
    # ========================== #

    # Login screen (AKA display manager, for some reason)
    # programs.regreet.enable = true;
    # services.greetd = {
    #     enable = true;
    # };

    # GNOME? More like GONE
    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
    };

    # Enables openGL
    hardware.opengl.enable = true;
    # Enables xwayland
    programs.xwayland.enable = true;

    # Enables xdg portals, even for flatpaks!
    xdg.menus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
    };

    # TODO: xdg mime apps
    xdg.mime.enable = true;
    
    # Home-manager sway config
    hm.wayland.windowManager.sway = {
        enable = true;
        config = {
            # Keyboard layout
            input = {
                "type:keyboard" = {
                    xkb_layout = "fi";
                    xkb_model = "pc105";
                };
            };
            # Monitor config
            output = {
                HDMI-A-1 = {
                    mode = "1920x1080@60Hz";
                    position = "0,360";
                };
                DP-1 = {
                    mode = "2560x1440@143.912Hz";
                    position = "1920,0";
                };
            };
            # Keybindings
            modifier = "Mod4";
            keybindings = 
                let mod = config.hm.wayland.windowManager.sway.config.modifier;
                in lib.mkOptionDefault {
                    "${mod}+Shift+s" = ''exec wayshot -s "$(slurp)" -e png --stdout | wl-copy; tee $XDG_PICTURES_DIR/screenshots/(date "+%Y-%m-%d %H-%M-%S").png'';
                };
            # Font settings
            fonts = {
                names = [ "Blinker" "Noto Sans" "Font Awesome 6 Free" "Font Awesome 6 Brands" ];
                style = "Regular";
                size = 12.0;
            };
            # Various other settings
            terminal = "kitty";
            menu = "tofi-run | xargs swaymsg exec --";
            # Set background color to black so my eyes don't get blasted out
            # Should only be used if an app doesn't fill the entire window
            colors.background = "#000000";
            # Remove titlebars
            window.titlebar = false;
            floating.titlebar = false;
        };
    };

    # Enables cliphist for clipboard "management"
    hm.services.cliphist.enable = true;

    # Enables gnome-keyring and seahorse
    security.pam.services.eero.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    # gpg setup
    hm.programs.gpg.enable = true;
    hm.programs.gpg.homedir = "${config.hm.xdg.dataHome}/gnupg";
    hm.services.gpg-agent.enable = true;
    hm.services.gpg-agent.pinentryFlavor = "gnome3";

    # vscode config
    hm.programs.vscode = {
        enable = true;
        package = pkgs.vscode; 
        extensions = let
            inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
        in with vscode-marketplace; [
            vscode-marketplace."13xforever".language-x86-64-assembly
            alefragnani.bookmarks
            alefragnani.project-manager
            antiantisepticeye.vscode-color-picker
            atomiks.moonlight
            charliermarsh.ruff
            christian-kohler.path-intellisense
            cschlosser.doxdocgen
            davidanson.vscode-markdownlint
            dbaeumer.vscode-eslint
            donjayamanne.python-environment-manager
            eamodio.gitlens
            ecmel.vscode-html-css
            enkia.tokyo-night
            equinusocio.vsc-material-theme
            equinusocio.vsc-material-theme-icons
            esbenp.prettier-vscode
            formulahendry.code-runner
            fortran-lang.linter-gfortran
            github.remotehub
            github.vscode-pull-request-github
            golang.go
            grapecity.gc-excelviewer
            haskell.haskell
            ibm.output-colorizer
            jeff-hykin.better-cpp-syntax
            jnoortheen.nix-ide
            julialang.language-julia
            justusadam.language-haskell
            llvm-vs-code-extensions.vscode-clangd
            mads-hartmann.bash-ide-vscode
            mathworks.language-matlab
            mechatroner.rainbow-csv
            mhutchie.git-graph
            miguelsolorio.fluent-icons
            mikestead.dotenv
            mkxml.vscode-filesize
            ms-azuretools.vscode-docker
            ms-python.autopep8
            ms-python.black-formatter
            ms-python.isort
            ms-python.pylint
            ms-python.python
            ms-python.vscode-pylance
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
            ms-vscode.azure-repos
            ms-vscode.cmake-tools
            ms-vscode.cpptools
            ms-vscode.cpptools-extension-pack
            ms-vscode.cpptools-themes
            ms-vscode.hexeditor
            ms-vscode.makefile-tools
            ms-vscode.remote-explorer
            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode-remote.remote-wsl
            ms-vscode.remote-repositories
            ms-vscode.remote-server
            ms-vscode-remote.vscode-remote-extensionpack
            ms-vscode.vscode-github-issue-notebooks
            ms-vscode.vscode-selfhost-test-provider
            # ms-vscode.vscode-serial-monitor
            njpwerner.autodocstring
            pkief.material-icon-theme
            pkief.material-product-icons
            platformio.platformio-ide
            rdebugger.r-debugger
            redhat.java
            redhat.vscode-xml
            redhat.vscode-yaml
            reditorsupport.r
            rust-lang.rust-analyzer
            ryu1kn.partial-diff
            scala-lang.scala
            scalameta.metals
            sdras.night-owl
            shopify.ruby-lsp
            sonarsource.sonarlint-vscode
            sumneko.lua
            tamasfe.even-better-toml
            techer.open-in-browser
            tomoki1207.pdf
            twxs.cmake
            vadimcn.vscode-lldb
            vscjava.vscode-gradle
            vscjava.vscode-java-debug
            vscjava.vscode-java-dependency
            vscjava.vscode-java-pack
            vscjava.vscode-java-test
            vscjava.vscode-maven
        ];
    };

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
