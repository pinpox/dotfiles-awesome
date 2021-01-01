{
  description = "A very basic flake";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }: {

    nixosModules = {
      dotfiles = { home.file = { ".config/awesome".source = ./dotfiles; }; };
    };
  };
}
