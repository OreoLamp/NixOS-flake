{ pkgs, ...}:
{
    users.users.eero.packages = with pkgs; [
        kitty
        neofetch
        piper
        mpv
        imv
        nomacs
        peazip
        firefox
        libsForQt5.okular
        inkscape
        gimp
        audacity
        obs-studio
        qbittorrent
        mullvad-vpn
        bitwarden
        calibre
        signal-desktop
        telegram-desktop
        spotify
        spotifywm
        spotifyd # TODO: Config this
        tofi
        eww-wayland
        swaylock
        wayshot
        slurp
        wl-clipboard
        cliphist
        thefuck
        dasel
        bat
        lsd
        fzf
        ripgrep
        tldr
        lsof
        # Dependencies not installed automatically
        # TODO: Figure out LLVM and GCC stuff
        nil
        shellcheck
        temurin-bin-8
        temurin-bin-11
        temurin-bin-17
        temurin-bin-21
        go
        ghc
        haskell-language-server
        julia
        fortls
        python310Full
        python311Full
        python312Full
        python313Full
        R
        rPackages.languageserver
        ruby-lsp
        rust-analyzer
        scala
        scala_3
    ];

    # Git
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

    # Btop
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

    # Kitty
    # TODO: Set up cue to configure this properly and just source the file
    hm.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        theme = "Tokyo Night";
        font.name = "JetBrainsMonoNL Nerd Font Thin";
        font.size = 11;
        settings = {
            # Font families
            font_family = "JetBrainsMonoNL Nerd Font ExtraLight";
            bold_font = "JetBrainsMonoNL Nerd Font Medium";
            italic_font = "JetBrainsMonoNL Nerd Font ExtraLight Italic";
            bold_italic_font = "JetBrainsMonoNL Nerd Font Medium Italic";

            # Font size
            font_size = 11;

            # Enable ligatures by default
            disable_ligatures = "never";

            # Cursor color
            cursor = "#FFCC00";

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
        };
    };
}