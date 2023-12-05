{ pkgs, ...}:
{
    users.users.eero.packages = with pkgs; [
        kitty # Terminal emulator
        neofetch # System information thingy
        mpv # Minimal video player
        imv # Minimal image viewer
        nomacs # Less minimal image viewer, but has an actual gui
        peazip # ZIP file manager (should yeet ngl)
        firefox # Browser
        libsForQt5.okular # Document viewer / editor
        inkscape # Vector graphics editor
        gimp # Image editor
        audacity # Waveform editor
        obs-studio # Screen recorder
        qbittorrent # Bittorrent client with a GUI
        mullvad-vpn # VPN
        bitwarden # Password manager
        calibre # Ebook library thingy
        signal-desktop # Messaging platform
        telegram-desktop # Another messaging platform
        spotify # For music
        spotifywm # Sets the spotify window title correctly. # TODO: Configure this
        spotifyd # Daemonized spotify: # TODO: Configure this
        tofi # Launcher / runner
        eww-wayland # Custom widgets # TODO: Set up
        swaylock # Lock screen support # TODO: Set up
        wayshot # Screenshot utility for Wayland
        slurp # Select area from screen on Wayland
        wl-clipboard # Wayland clipboard
        cliphist # Clipboard history, preserves everything byte for byte
        thefuck # Checks for typos and shit in the last command if it didnt work
        dasel # jq / yq, but faster and for a lot more data types
        bat # cat but better
        lsd # ls but better # TODO: Check out eza?
        fzf # Command line fuzzy finder
        ripgrep # Faster grep with more capabilities
        tealdeer # Gives TLDR examples of commands, and respects XDG base directory spec
        kitty-themes # For themes in kitty
        meld # GUI diff / merge tool
        # TODO: Figure out LLVM and GCC stuff
        # Sets up gnome keyring as the password storage
        # Also moves extensions to somewhere more sane
        # And confg folder from .config/Code to .config/vscode
        ( vscode.override { commandLineArgs = ''--password-store="gnome" --extensions-dir "$XDG_DATA_HOME/vscode" --user-data-dir "$XDG_CONFIG_HOME/vscode"''; } )
        nil # Nix language server
        shellcheck # Shell language server
        shfmt
        go # Go language
        ghc # Glasgow Haskell Compiler
        haskell-language-server # take a guess
        julia # Julia toolchain ig?
        fortls # Fortran language server
        R # R compiler and programming language
        rPackages.languageserver # R language server
        ruby-lsp # Ruby language server
        rust-analyzer # Rust language server
        cue # Cue programming language
        cuelsp # Cue language server
        cuetools # Cue utilities
        lemminx # XML language server
    ];

    # Enables git, sources the git user config file
    programs.git.enable = true;
    hm.home.file."git.config" = {
        enable = true;
        source = ./configs/git.config;
        target = ".config/git/config";
    };

    # Neovim
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
    };

    # Steam... let's see if this works at all
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
    };
    
    # 32 bit libraries needed for steam
    hardware.opengl.driSupport32Bit = true;

    # Kitty
    # TODO: Set up cue to configure this properly and just source the file
    hm.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        font.name = "JetBrainsMOno Nerd Font Mono ExtraLight";
        font.size = 11;
        settings = {
            # Font families
            font_family = "JetBrainsMono Nerd Font Mono ExtraLight";
            bold_font = "JetBrainsMono Nerd Font Mono Medium";
            italic_font = "JetBrainsMono Nerd Font Mono ExtraLight Italic";
            bold_italic_font = "JetBrainsMono Nerd Font Mono Medium Italic";

            # Font size
            font_size = 12;

            # Enable ligatures by default
            disable_ligatures = "never";

            # Cursor color
            cursor = "#ffcc00";

            # Scrollback lines to keep in memory
            scrollback_lines = 10000;

            # TODO: Configure nvimpager to be used for scrollback pager
            # scrolback_pager = "nvimpager --blah"

            # Size of the scrollback buffer used for the pager
            scrollback_pager_history_size = 4095;

            # Hides mouse cursor immediately when starting to type
            mouse_hide_wait = -1;

            # Underline hyperlinks always to mark them
            underline_hyperlinks = "always";

            # Sanity checks for pasting stuff into the terminal
            # Asks for confirmation if the text to be pasted contains terminal control characters
            # or if the text to be pasted is very large (>16KB). Also quotes URLs.
            paste_actions = "quote-urls-at-prompt,confirm,confirm-if-large";

            # Makes focus follow the mouse
            focus_follow_mouse = "true";

            # Makes the repaint delay lower than the refresh rate of my monitor
            repaint_delay = 5;

            # Reduces input delay, might cause flicker in slow TUI programs
            input_delay = 1;

            # Disables terminal bell (bruh)
            enable_audio_bell = "false";

            # Make kitty not remember the window size (am using a tiler lol)
            remember_window_size = "false";

            # Fixes kitty window border width to 2 pixels. Note that this is not the OS window border.
            window_border_width = "2px";

            # Moves the tab bar to the top
            tab_bar_edge = "top";

            # Tab bar visual style
            tab_bar_style = "separator";

            # Always show the tab bar
            tab_bar_min_tabs = 1;

            # When closing a tab, open the tab that was open prior to the closed one
            tab_switch_strategy = "previous";

            # The separator used between tabs
            tab_separator = " ┃ ";

            # Symbol to display if a tab has activity and isn't in focus
            # TODO: Figure out how to make this recolor the tab text instead

            # Maximum length for a tab title
            tab_title_max_length = 20;

            # The layout of the tab title
            # TODO: Customize

            # Sets the font style of tabs to something more reasonable than bold italic
            active_tab_font_style = "bold";
            inactive_tab_font_style = "bold";

            # Sets the default editor to use in kitty
            editor = "neovim";

            # Disables clipboard size limits
            clipboard_max_size = "0";

            # Make Tokyo Night the color theme used
            include = "${pkgs.kitty-themes}/share/kitty-themes/themes/tokyo_night_night.conf";
        };
    };
}