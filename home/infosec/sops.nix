{
  config,
  lib,
  inputs,
  useGenericLinux,
  pkgs,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
  sopsDefault = {
    defaultSopsFile = "${secretsPath}/home-secrets.enc.yaml";
    validateSopsFiles = false;
    gnupg = {
      home = "${config.xdg.dataHome}/gnupg";
      sshKeyPaths = [];
    };
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
      // lib.optionalAttrs (!useGenericLinux) {
        age.keyFile = "${config.xdg.configHome}/sops/age/home-sops.keyfile";
      };
    home = {
      activation.setupEtc =
        if useGenericLinux
        then
          (config.lib.dag.entryAfter ["writeBoundary"] ''
            /usr/bin/systemctl start --user sops-nix
          '')
        else
          (config.lib.dag.entryAfter ["writeBoundary"] ''
            /run/current-system/sw/bin/systemctl start --user sops-nix
          '');
    };
    systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
  };
}
