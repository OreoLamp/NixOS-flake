{ pkgs, config, ... }:
{
    # Packages used
    users.users.eero.packages = with pkgs; [
        # For good shell history
        atuin
    ];

    # Atuin stuff for history
    hm.programs.atuin = {
        enable = true;
        settings = {
            style = "compact";
            filter_mode_shell_up_key_binding = "directory";
            show_preview = true;
        };
    };
 
    # Global shell config, applies to all shells
    environment.variables = rec {
        # Allow users to set their own pager and editor...
        EDITOR = "";
        PAGER = "";

        # XDG stuff
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME./cache";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_RUNTIME_DIR = "/run/user/${builtins.toString config.users.users.eero.uid}";

        # GPG home
        GNUPGHOME = "${XDG_DATA_HOME}/gnupg";

        # Setting SSH sock properly to work with gnome-keyring
        SSH_AUTH_SOCK = "${XDG_RUNTIME_DIR}/keyring/ssh";

        # Gets rid of .cargo in $HOME
        CARGO_HOME = "${XDG_DATA_HOME}/cargo";

        # Gets rid of .sonarlint in $HOME
        SONARLINT_USER_HOME = "${XDG_DATA_HOME}/sonarlint";
    };

    # Bash history file yeetage
    programs.bash.shellInit = ''export HISTFILE="$XDG_DATA_HOME"/bash/history.txt'';

    # Global zsh stuff
    # TODO: Set this up properly without HM and without .zshenv being a thing
    programs.zsh = {
        enable = true;
    };

    # zsh config, done in home-manager because home-manager is actually moronic
    # TODO: This whole shitshow in .zshrc, and just yeet it in the correct place with home-manager
    # (fuck home-manager)
    hm.programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        dotDir = ".config/zsh";

        # History stuff
        history = {
            ignoreDups = false;
            ignoreSpace = false;
            path = "$HOME/.local/share/zsh/zsh_history.txt";
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
            dev = "nix develop";
            sysrebuild = "sudo nixos-rebuild switch --flake /home/eero/.config/nix/NixOS-flake#desktop-nix";
        };
    };
}