{
  description = "A Nix-flake-based Node.js development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nodejs_24
              typescript
              nodePackages."@angular/cli"
              (vscode-with-extensions.override {
                vscodeExtensions = with vscode-extensions; [
                  angular.ng-template
                  esbenp.prettier-vscode
                  eamodio.gitlens
                  vscodevim.vim
                ];
              })
            ];
          };
        }
      );
    };
}
