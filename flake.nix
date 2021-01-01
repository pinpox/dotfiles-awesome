{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wallpaper-generator.url = "github:pinpox/wallpaper-generator";
    wallpaper-generator.flake = false;
  };

  outputs = { self, nixpkgs, wallpaper-generator }: {

    nixosModules = {
      dotfiles = { config, ... }: {
        home.file = {
          ".config/awesome".source = ./dotfiles;
          ".local/share/wallpaper-generator".source = wallpaper-generator;
        };
      };
    };
  };
}
