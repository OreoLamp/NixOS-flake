# Basic packages that should be always available
# Some of these should really be included by default...
{pkgs, ...}:
{
    # Defines system-wide basic packages that should be always available
    environment.systemPackages = with pkgs; [
        strace
        du-dust
	file
	nvimpager
	nnn
	psmisc
	neovim
	unar
	btop
	curl
	pciutils
	lshw
	tmux
	nix-tree
    ];

    services.locate = {
        enable = true;
        package = pkgs.plocate;
        interval = "never";
    };
}
