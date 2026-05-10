{ config, pkgs, lib, ... }:
{
    programs.vscode = {
        enable = true;
        profiles = {
            "personal" = {
                enableMcpIntegration = true;
            }
        };
    };
}