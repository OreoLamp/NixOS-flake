{ pkgs, ... }:
{
    # Mount unit for 2tb SSD
    # TODO: Start after login, this slows boot down non-negligebly lol
    systemd.mounts = [{
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
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
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
}