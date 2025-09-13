{ config, pkgs, lib, ... }:

{
  programs.rclone = {
    enable = true;
  };

  systemd.user.services.rclone-Resume = {
    Unit = {
      Description = "Rclone mount for Resume";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount vandy23:Resume/ %h/data/Resume \
          --vfs-cache-mode writes \
          --allow-other
      '';
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/data/Resume";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
