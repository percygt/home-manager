{
  config,
  lib,
  inputs,
  isGeneric,
  pkgs,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
  sopsDefault = {
    defaultSopsFile = "${secretsPath}/home-secrets.enc.yaml";
    validateSopsFiles = false;
  };
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    infosec.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.infosec.sops.enable {
    home.packages = with pkgs; [
      sops
    ];
    sops =
      sopsDefault
      // (
        if isGeneric
        then {
          gnupg = {
            home = "${config.xdg.dataHome}/gnupg";
            sshKeyPaths = [];
          };
        }
        else {
          age.keyFile = "${config.home.homeDirectory}/.nixos/keys/home-sops.keyfile";
          age.sshKeyPaths = [];
          gnupg.sshKeyPaths = [];
        }
      );
    home = {
      activation.setupEtc =
        if isGeneric
        then
          (config.lib.dag.entryAfter ["writeBoundary"] ''
            /usr/bin/systemctl start --user sops-nix
          '')
        else
          (config.lib.dag.entryAfter ["writeBoundary"] ''
            /run/current-system/sw/bin/systemctl start --user sops-nix
          '');
    };
  };
}
