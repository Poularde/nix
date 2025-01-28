{ system, nixpkgs, home-manager, ... }:

home-manager.users.poularde = { pkgs, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];
    programs.ssh = {
      startAgent = true;
      addKeysToAgent = "yes";
    };
}