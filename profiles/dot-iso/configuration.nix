{
  pkgs,
  lib,
  hostName,
  target_user,
  inputs,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  isoImage = {
    appendToMenuLabel = " live";
    # copy self(flake directory) to /iso path of the dot installer
    # contents = [
    #   {
    #     source = self;
    #     target = "/nix-dots";
    #   }
    # ];
  };

  environment.systemPackages = with pkgs; [
    gum
    rsync
    age
    sops
    yq-go
    (
      writeShellScriptBin "setup_gpg"
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        sudo cryptsetup luksOpen /dev/disk/by-label/v enc_vol
        mkdir ~/usb
        sudo mount /dev/mapper/env_vol ~/usb
        gpg --import ~/usb/.k/pgp/percygtdev.subkeys.gpg
      ''
    )
    (
      writeShellScriptBin "install_nixos"
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        dots_dir="$HOME/nix-dots";

        if [ ! -d "$dots_dir/.git" ]; then
        	git clone --depth 1 https://gitlab.com/percygt/nix-dots.git "$dots_dir"
        fi

        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v ${hostName} | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        echo "Setting up secrets and keys..."
        if grep -q "luks.keyfile" "$dots_dir/profiles/$TARGET_HOST/disks.nix"; then
          echo -n "$(head -c32 /dev/random | base64)" > "/tmp/luks.keyfile"
        fi

        [ -e "/tmp/$TARGET_HOST.keyfile" ] || age-keygen -o "/tmp/$TARGET_HOST.keyfile"

        [ -e "/tmp/host.enc.yaml" ] || printf "user-hashedPassword: $(mkpasswd -s)" > "/tmp/host.enc.yaml"

        SOPS_AGE_KEY_FILE="/tmp/$TARGET_HOST.keyfile"
        AGE_PUBLIC_KEY=$(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)")

        pushd $dots_dir &> /dev/null;
        if [ $(git status --porcelain | wc -l) -eq "0" ]; then
          popd &> /dev/null;
          sops \
            --encrypt \
            --age $AGE_PUBLIC_KEY \
            --in-place "/tmp/host.enc.yaml"

          cp -f "/tmp/host.enc.yaml" "$dots_dir/profiles/$TARGET_HOST/"

          yq ".keys[.keys[] | select(anchor == \"$TARGET_HOST\") | path | .[-1]] = \"$AGE_PUBLIC_KEY\"" -i "$dots_dir/.sops.yaml"

          pushd $dots_dir &> /dev/null;
          git add .
          popd &> /dev/null;
        fi

        gum confirm  --default=true \
          "WARNING!!!! This will ERASE ALL DATA on the disks $TARGET_HOST. Are you sure you want to continue?"

        echo "Partitioning Disks"
        sudo nix run github:nix-community/disko \
          --extra-experimental-features "nix-command flakes" \
          --no-write-lock-file \
          -- \
          --mode zap_create_mount \
          "$dots_dir/profiles/$TARGET_HOST/disks.nix"

        [ -e "/mnt/etc/secrets" ] || sudo mkdir -p "/mnt/etc/secrets"

        sudo cp /tmp/$TARGET_HOST.keyfile /mnt/etc/secrets
        sudo chmod 0400 /mnt/etc/secrets/$TARGET_HOST.keyfile

        if [[ -f "/tmp/luks.keyfile" ]]; then
          sudo cp /tmp/luks.keyfile /mnt/etc/secrets
          sudo chmod 0400 /mnt/etc/secrets/luks.keyfile
        fi

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd

        mkdir -p "/mnt/home/${target_user}/nix-dots"
        rsync -a --delete "$dots_dir" "/mnt/home/${target_user}/"

        echo "Installation complete! Don't forget to backup your secrets in \"/etc/secrets\""
      ''
    )
  ];
}
