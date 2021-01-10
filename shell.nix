# Import the nix package collection, so we can access the `pkgs` and `stdenv`
# variables

  # Make a new "derivation" that represents our shell
stdenv.mkDerivation rec {
  name = "awesomewm-dev";

  # The packages in the `buildInputs` list will be added to the PATH in our shell
  buildInputs = [];

  # Export paths and add helper functions and aliases
  # Preview command
  # ./awmtt.sh stop && ./awmtt.sh start -C ~/Projects/dotfiles-awesome/dotfiles/rc.lua && ./awmtt.sh run xterm && ./awmtt.sh run xterm
  shellHook = ''
    alias build="lua main.lua"
  '';
}
