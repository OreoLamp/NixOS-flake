{ pkgs, ... }:
{
    # Packages used
    users.users.eero.packages = with pkgs; [
        # For good shell history
        atuin
    ];

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
            sysrebuild = "sudo nixos-rebuild switch --flake /home/eero/.config/nix/NixOS-flake#desktop-nix";
        };
    };

    # Atuin stuff for history
    hm.programs.atuin = {
        enable = true;
        settings = {
            style = "compact";
            filter_mode_shell_up_key_binding = "directory";
            show_preview = true;
        };
    };
}
