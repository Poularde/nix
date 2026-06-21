{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, chaotic, home-manager, ... }@inputs: 
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.garuda = nixpkgs.lib.nixosSystem {
        # Set all inputs parameters as special arguments for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        specialArgs = { inherit system inputs outputs; };
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          chaotic.nixosModules.default
        ];
      };
      homeConfigurations = {
        "poularde@garuda" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            # > Our main home-manager configuration file <
            ./home.nix
          ];
        };
      };
    };
}