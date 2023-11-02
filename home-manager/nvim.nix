{
  programs.neovim = {
    enable = true;

    # Generates the neovim config file based on this command
    # Wraps neovim to use said config file
    # configure = {};
    
    # Sets neovim as the default editor
    defaultEditor = true;

    # Aliases vi and vim to neovim
    viAlias = true;
    vimAlias = true;

    # Aliases vimdiff to nvim -d
    vimdiffAlias = true;
  };
}
