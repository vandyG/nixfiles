{
  config,
  pkgs,
  lib,
  nix-vscode-extensions,
  ...
}:
let
  vscode-marketplace = nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
in
{
  programs.vscode = {
    enable = true;
    profiles = {
      "default" = {
        enableMcpIntegration = true;
        enableUpdateCheck = true;
        extensions = with pkgs.vscode-extensions; [
          eamodio.gitlens
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-slideshow
          ms-toolsai.vscode-jupyter-cell-tags
          github.copilot-chat
          jnoortheen.nix-ide
          charliermarsh.ruff
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ]
        ++
        (
          with vscode-marketplace; [
            # Marketplace-only extensions
            ms-python.vscode-python-envs
            ms-toolsai.vscode-jupyter-powertoys
            ms-vscode.vscode-websearchforcopilot
            ms-vscode.vscode-copilot-vision
          ]
        )
        ;
        userMcp = {
          servers = {
            "nixos" = {
              "command" = "nix";
              "args" = [
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
            };
          };
        };
        userSettings = {
          "workbench.iconTheme"= "catppuccin-mocha";
          "workbench.colorTheme"= "Catppuccin Mocha";
          "terminal.integrated.fontFamily"= "JetBrainsMono NF";
          "ruff.enable"= true;
          "ruff.configuration"= "/home/vandy/work/.vscode/ruff.toml";
          "notebook.editorOptionsCustomizations"= {
              "editor.tabSize"= 4;
              "editor.indentSize"= 4;
              "editor.insertSpaces"= true;
          };
          "diffEditor.codeLens"= true;
          "[python]"= {
            "editor.defaultFormatter"= "charliermarsh.ruff";
            "editor.formatOnSave"= true;
          };
          "remote.autoForwardPortsSource"= "hybrid";
          "workbench.editorAssociations"= {
            "*.mp3"= "vscode.audioPreview";
          };
          "jupyter.askForKernelRestart"= false;
          "[nix]"= {
            "editor.insertSpaces"= true;
            "editor.tabSize"= 2;
          };
          "files.autoSave" = "off"; 
        };
      };
    };
  };
}
