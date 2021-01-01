{
  description = "A very basic flake";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "awesome-dotfiles";
        src = self;
        installPhase = "mkdir -p $out; mv * $out";
      };
  };
}
