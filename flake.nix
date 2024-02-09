{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-darwin.hello = nixpkgs.legacyPackages.x86_64-darwin.hello;

    packages.x86_64-darwin.default = self.packages.x86_64-darwin.hello;

  };
}
