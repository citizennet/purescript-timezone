{ self, ... }: {
  perSystem = { config, ... }: {
    packages.timezone = config.purs-nix-build ./.;
    checks.timezone-test =
      let ps = config.packages.array.purs-nix-info-extra.ps;
      in ps.test.check { };
  };
}
