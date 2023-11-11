{ pkgs, ...}:
{
    users.users.eero.packages = with pkgs; [
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
        nil
        shellcheck
        thefuck
        dasel
        bat
        lsd
        fzf
        ripgrep
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
    hm.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        theme = "Tokyo Night";
    };
}