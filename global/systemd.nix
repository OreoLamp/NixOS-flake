{ pkgs, ... }:
{
    #! Custom systemd units
    systemd = {

        # Mount unit for 2tb SSD
        # TODO: Start after login, this slows boot down non-negligebly lol
        mounts = [{
            mountConfig = { DirectoryMode = "0755"; };
            description = "2tbSSD mount";
            options = "nofail,atime,exec,windows_names,remove_hiberfile,big_writes,uid=1000,gid=100,umask=0022,fmask=0022,gmask=0022";
            wants = [ "multi-user.target" ];
            wantedBy = [ "multi-user.target"];
            after = [ "multi-user.target" ];
            type = "ntfs-3g";
            what = "/dev/disk/by-uuid/588A45CD8A45A878";
            where = "/media/2tbSSD";
        }];

        # Gnome polkit authentication agent service, starts on login
        # This is cursed as fuck but nixos has apparently no sane way of doing this
        user.services.polkit-gnome-authentication-agent-1 = {
            enable = true;
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };

        # Starts gcr ssh-agent on login, again cursed af but no sane way to do this...
        user.services.gnome-keyring = {
            enable = true;
            description = "GNOME keyring daemon";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            environment = {
                SSH_AUTH_SOCK = "${builtins.getEnv "XDG_RUNTIME_DIR"}/keyring/ssh";
            };
            serviceConfig = {
                Type = "simple";
                ExecStart = let args = "--start --foreground --components=secrets,ssh";
                    in "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon ${args}";
                Restart = "on-abort";
            };
        };
    };

    #! Syslog config
    # TODO: Make a custom compression algorithm for these, seems like a cool project
    services.journald = {
        # Keep syslogs in persistent storage
        storage = "persistent";

        /*
        Configures burst limits on syslog event storage.
        rateLimitBurst defines how many messages are stored, when logged within 
        the period of time defined in rateLimitInterval.
        Note that the definition of rateLimitBurst is multiplied by a value,
        defined by the amount of available disk space.
        In my case, should always be 5.
        Defaults are 10k messages / 30 seconds. 
        */
        rateLimitBurst = 20000;
        rateLimitInterval = "10s";

        # Makes journald read the kernel ring buffer (kmesg)
        extraConfig = "ReadKMsg = true";
    };
}