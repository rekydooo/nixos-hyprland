{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    polymc.url = "github:PolyMC/PolyMC";
  };

  outputs = { self, nixpkgs, polymc }: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-Linux";

      modules = [
        ({ pkgs, ... }: {
	  nixpkgs.overlays = [ polymc.overlay ];
	})

        ./configuration.nix
      ];
    };

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
