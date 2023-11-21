{ pkgs, ... }:
{
    # Packages used
    users.users.eero.packages = with pkgs; [
        # For good shell history
        atuin
    ];

    # Global shell config, applies to all shells
    environment.variables = {
        # Yeets .gnupg/ from $HOME
        GNUPGHOME = /home/eero/.local/share/gnupg;
    };

    # Bash history file yeetage
    programs.bash.shellInit = ''export HISTFILE="$XDG_STATE_HOME"/bash/history'';

    # Global zsh stuff
    programs.zsh = {
        enable = true;
        
        # .zshenv yeetage
        shellInit = ''export ZDOTDIR="$HOME"/.config/zsh'';
    };

    # zsh config, done in home-manager because home-manager is actually moronic
    # TODO: This whole shitshow in .zshrc, and just yeet it in the correct place with home-manager
    # (fuck home-manager)
    hm.programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;

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
