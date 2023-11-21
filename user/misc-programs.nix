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
        tldr # Gives tldr examples of how to use commands
        kitty-themes # For themes in kitty
        meld # GUI diff / merge tool
        # Dependencies not installed automatically
        # TODO: Figure out LLVM and GCC stuff
        # Sets up gnome keyring as the password storage
        # Also moves extensions to somewhere more sane
        # And confg folder from .config/Code to .config/vscode
        ( vscode.override { commandLineArgs = ''--password-store="gnome" --extensions-dir "$XDG_DATA_HOME/vscode" --user-data-dir "$XDG_CONFIG_HOME/vscode"''; } )
        nil # Nix language server
        shellcheck # Shell language server
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
    ];

    # Git
    hm.programs.git = {
        enable = true;

        # All config is done in extraConfig because i want to get rid of home-manager
        extraConfig = {
            core = {
                # Makes git case-insensetive, for NTFS compatability
                ignoreCase = true;
                # Disallows files / paths that NTFS would disallow
                protectNTFS = true;

                # TODO: Figure out whether askPass is needed

                # Sets the default editor and pager
                editor = "$EDITOR";
                pager = "$PAGER";
                
                # Makes git do proper file write sync on added and committed files
                fsync = "objects,index,commit-graph";
            };

            user = {
                name = "Eero Lampela";
                email = "eero.lampela@gmail.com";

                # Key identifier used for signing stuff
                signingKey = "214155AB1DF262A0";
            };

            diff = {
                # Generate 5 lines of context instead of 3 
                context = "5";

                # Show context between diff hunks, makes git fuse hunks that are close by
                interHunkContext = "5";

                # Makes file rename detection detect more file renames
                renameLimit = 100000;

                # Uses a better diff algorithm
                algorithm = "minimal";
                
                # Use nvimdiff as the diff tool
                tool = "nvimdiff";

                # Use meld as the GUI diff tool
                guitool = "meld";
            };

            gc = {
                # Makes the amount of possible files gc compares against for delta compression higher
                aggressiveWindow = 1000;

                # Disables auto gc
                auto = 0;

                # Disables pruning unreachable objects
                pruneExpire = "never";
            };

            log = {
                # Stops git from abbreviating commits by default
                abbrevCommit = false;

                # Gives dates in a more sensible format ()
                date = "format:%F %T";

                # Enables short ref names in terminal, disables them elsewhere
                decorate = "auto";
            };

            merge = {
                # Disables merge fast-forwarding, so git creates a merge commit for those
                ff = false;

                # Makes sure that merges are signed by a valid key
                verifySignatures = true;

                # Adds merge logs
                log = true;

                # Because git treats directory renames as file renames
                renameLimit = 100000;

                # Renormalize the merged data to prevent unnecessary conflicts
                renormalize = true;
            };

            pack = {
                # Default window size used by git-pack-objects
                # Basically, how many objects to compare against to find delta compression
                window = 250;

                # Disables packfile reuse, since it results in larger packs
                allowPackReuse = false;

                # Increases delta cache size from 256MiB, for some reason set in bytes
                deltaCacheSize = 2147483647;

                # Increases the max size of an object in delta cache
                deltaCacheLimit = 65535;

                # Sets the maximum number of threads for delta searching
                # Limited to 6, as each thread gets its own memory pool.
                threads = 6;
            };

            # Makes fetch write a commit graph after every download by git fetch
            fetch.writeCommitGraph = true;

            # Makes supported commands output in columns, if the output is a terminal
            column.ui = "auto";

            # Makes all commits GPG-signed
            commit.gpgSign = true;

            # Renames the default branch to "main" instead of "master"
            init.defaultBranch = "main";

            # Makes git use the default pager for manpages
            man.viewer = "$PAGER";

            # Disables pull fast-forwarding, so git creates a pull commit for those
            pull.ff = false;
            
            # Allow this many fetch jobs for submodules in parallel
            submodule.fetchJobs = 12;
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
        font.name = "JetBrainsMono Nerd Font Thin";
        font.size = 11;
        settings = {
            # Font families
            font_family = "JetBrainsMono Nerd Font ExtraLight";
            bold_font = "JetBrainsMono Nerd Font Medium";
            italic_font = "JetBrainsMono Nerd Font ExtraLight Italic";
            bold_italic_font = "JetBrainsMono Nerd Font Medium Italic";

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

            # Make Tokyo Night the color theme used
            include = "${pkgs.kitty-themes}/share/kitty-themes/themes/tokyo_night_night.conf";
        };
    };
}