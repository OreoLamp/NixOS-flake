{
  programs.zsh = {
    # Enables zsh to begin with lol
    enable = true;
    
    # Autosuggestion stuff
    autosuggestions.enable = true;
    autosuggestions.async = true;
    autosuggestions.strategy = [
      "match_prev_cmd"
      "history"
      "completion"
    ];
    
    # Completion stuff
    enableCompletion = true;
    
    # History stuff
    histFile = "$HOME/.config/zsh/zsh_history.txt";
    histSize = 1000000000;

    # Syntax highlight stuff
    syntaHighlight.enable = true;

    # General options
    setOptions = [
      "CLOBBER"
      "CHECK_RUNNING_JOBS"
      "C_BASES"
      "INC_APPEND_HISTORY_TIME"
      "HIST_LEX_WORDS"
      "HIST_VERIFY"
    ];
  };
}
