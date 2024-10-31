{
  inputs,
  isGeneric,
  buildHome,
  isIso,
  username,
}:
let
  lib = if isGeneric then inputs.home-manager.lib else inputs.nixpkgs.lib;
in
{
  sway = import ./sway.nix { inherit lib; };
  toRasi = import ./toRasi.nix { inherit lib; };
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };

  colorConvert = import ./colorCoversions.nix { nixpkgs-lib = lib; };
  importPaths =
    let
      importHome =
        rootDir: if (builtins.pathExists (rootDir + /home.nix)) then [ (rootDir + /home.nix) ] else [ ];
      importSystem =
        rootDir: if (builtins.pathExists (rootDir + /system.nix)) then [ (rootDir + /system.nix) ] else [ ];
      moduleDefault = rootDir: if isGeneric then importHome rootDir else importSystem rootDir;
      moduleAll =
        rootDir:
        builtins.filter (path: builtins.pathExists path) (
          map (f: rootDir + "/${f}") (
            builtins.attrNames (
              removeAttrs (builtins.readDir rootDir) [
                "default.nix"
                "home.nix"
                "system.nix"
              ]
            )
          )
        );
    in
    {
      default = rootDir: {
        imports = moduleDefault rootDir;
        home-manager.users.${username} = {
          imports = if (builtins.pathExists (rootDir + /home.nix)) then [ (rootDir + /home.nix) ] else [ ];
        };
      };
      all = rootDir: { imports = moduleAll rootDir; };
    };

}
