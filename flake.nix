{
  description = "Development environment for tuat-typst";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          typstFonts = [ pkgs.times-newer-roman ];
          haranoaji = pkgs.texlivePackages.haranoaji;
          haranoajiFontPath = "${haranoaji}/fonts/opentype/public/haranoaji";
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.typst
              pkgs.tinymist
              haranoajiFontPath
              pkgs.times-newer-roman
            ];
            shellHook = ''
              export TYPST_FONT_PATHS="${pkgs.lib.makeSearchPath "share/fonts" typstFonts}:${haranoajiFontPath}"
            '';
          };
        }
      );
    };
}
