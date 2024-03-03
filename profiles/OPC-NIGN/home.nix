{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "gnome"
    "neovim"
    "shell"
    "terminal"
    "fonts.nix"
    "tmux.nix"
    "starship.nix"
    "yazi.nix"
    "direnv.nix"
    "cli.nix"
    "nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
  home.shellAliases = {
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
  };
}