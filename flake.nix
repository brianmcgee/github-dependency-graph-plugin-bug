{
  description = "Reproducer for Github Dependency Graph Plugin Bug";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
                jdk
                gradle
            ];
        };
      };
    };
}
