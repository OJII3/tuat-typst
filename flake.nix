{
  description = "Development environment for tuat-typst";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "tuat-typst";
            version = "0.2.0";
            src = ./.;
            installPhase = ''
              runHook preInstall
              packageDir="$out/share/typst/packages/local/tuat-typst/0.2.0"
              mkdir -p "$packageDir"
              cp typst.toml lib.typ "$packageDir/"
              cp -r template "$packageDir/"
              runHook postInstall
            '';
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          typstFonts = [ pkgs.times-newer-roman ];
          haranoaji = pkgs.texlivePackages.haranoaji;
          haranoajiFontPath = "${haranoaji}/fonts/opentype/public/haranoaji";
          tuatTypst = self.packages.${system}.default;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.typst
              pkgs.tinymist
              haranoajiFontPath
              pkgs.times-newer-roman
              tuatTypst
            ];
            shellHook = ''
              export TYPST_FONT_PATHS="${pkgs.lib.makeSearchPath "share/fonts" typstFonts}:${haranoajiFontPath}"
              export TYPST_PACKAGE_PATH="${tuatTypst}/share/typst/packages"
            '';
          };
        }
      );
    };
}
