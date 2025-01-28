{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.garuda = nixpkgs.lib.nixosSystem {
        # Set all inputs parameters as special arguments for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        specialArgs = { inherit system inputs; };
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
        ];
      };
      homeConfigurations = (
        import ./home-manager.nix {
          inherit system nixpkgs home-manager;
        }
      );
    };
}