{lib, ...}: {
  imports =
    [
      ./gnome
      ./gtk
      ./neovim
      ./qt
      ./shell
      ./terminal
      ./tmux
      ./shell
      ./vscodium
      ./zellij
      ./starship.nix
      ./yazi.nix
      ./broot.nix
      ./direnv.nix
      ./fastfetch.nix
      ./cli.nix
      ./fonts.nix
      ./nixtools.nix
      ./zathura.nix
      ../../bin
    ]
    ++ lib.optional (builtins.pathExists ./personal) ./personal;
}
