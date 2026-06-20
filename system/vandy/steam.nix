{lib, pkgs, ...}:
{
    programs = {
      steam.enable = true;
      steam.gamescopeSession.enable = true;
      gamemode.enable = true;
      gamescope = {
        enable = true;
        enableWsi = true;
        capSysNice = false;
      };
    };
}