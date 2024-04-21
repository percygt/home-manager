{
  lib,
  isGeneric,
  ...
}: {
  imports =
    [
      ./cli
      ./desktop
      ./editor
      ./bin
      ./terminal
      ./shell
      ./infosec
      ./dev
      ./browser
      ./common
    ]
    ++ lib.optionals isGeneric [./generic];
}
