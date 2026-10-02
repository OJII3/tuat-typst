{
  description = "Development environment for tuat-typst";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              typst
              noto-fonts-cjk-sans
            ];
            shellHook = ''
              export TYPST_FONT_PATHS="${pkgs.noto-fonts-cjk-sans}/share/fonts"
            '';
          };
        }
      );
    };
}
