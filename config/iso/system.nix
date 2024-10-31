{
  pkgs,
  lib,
  inputs,
  config,
  profile,
  self,
  ...
}:
let
  g = config._general;
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${self}/profiles/systems/${profile}/installer.nix"
    ../nixpkgs
    ../nix.nix
    ../home-manager.nix
  ];
  _general.username = "nixos";
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  environment.systemPackages = g.system.corePackages;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
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
}
