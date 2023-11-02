{
  # General zsh options
  programs.zsh = {
    # Enable zsh to begin with (lol)
    enable = true;

    # Sets the zsh config directory to something other than $HOME
    dotDir = "$HOME/.config/zsh";

    # History stuff
    history = {
      enable = true;
      # Path to history file
      path = "$HOME/.config/zsh/zsh_history.txt";
      
      # How many lines of history should be saved at a time / total
      save = 1000000000;
      size = 1000000000;
      
      # Make commands starting with a space still be included in history
      ignoreSpace = false;

      # Disables history sharing, because it isn't compatable with INC_APPEND_HISTORY_TIME
      share = false;
    };

    initExtra = "setopt INC_APPEND_HISTORY_TIME\nsetopt HIST_VERIFY\nsetopt HIST_LEX_WORDS\nsetopt APPEND_HISTORY"
  };
}
