{
  description = "My awesomeWM configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    wallpaper-generator = {
      url = "github:pinpox/wallpaper-generator";
      flake = false;
    };

  };
  outputs = { self, ... }@inputs:
    with inputs;
    let test = "rstin";
    in {
      nixosModules = {
        dotfiles = { config, ... }: {
          home.file = {
            ".config/awesome".source = ./dotfiles;
            ".local/share/wallpaper-generator".source = wallpaper-generator;
          };
        };
      };
    } //

    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};

      in rec {
        packages = flake-utils.lib.flattenTree rec {

          awesome-configuration = let

            test-awesome = pkgs.writeScript "test-awesome" ''
              #!/usr/bin/env bash
              set -eu -o pipefail
              Xephyr :5 & sleep 1 ; DISPLAY=:5 ${pkgs.awesome}/bin/awesome -c ./dotfiles/rc.lua
            '';
          in pkgs.stdenv.mkDerivation rec {
            pname = "awesome-configration";
            version = "1.0";

            src = ./dotfiles;

            dontBuild = true;

            nativeBuildInputs =
              [ pkgs.luaPackages.lgi pkgs.luaPackages.luafilesystem ];

            installPhase = ''
              cp -r . $out
              cp ${test-awesome} $out/run-test
            '';

            meta = with pkgs.lib; {
              homepage = "https://github.com/pinpox/dotfiles-awesome";
              description = "Pinpox's awesomeWM configuration";
              license = licenses.mit;
              maintainers = [ maintainers.pinpox ];
            };
          };

        };

        apps = {
          test-config = flake-utils.lib.mkApp {
            drv = packages.awesome-configuration;
            exePath = "/run-test";
          };
        };

        defaultPackage = packages.awesome-configuration;
        defaultApp  = apps.test-config;

      });
}
