{
  pkgs,
  lib,
  inputs,
  username,
  outputs,
  self,
  homeArgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${self}/lib/bldr/iso/installer.nix"
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  home-manager = {
    users.${username} = import ./home.nix;
    extraSpecialArgs = homeArgs;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment.systemPackages = import "${self}/config/corePackages.nix" pkgs;

  systemd.services."home-manager-${username}" = {
    before = [ "display-manager.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
