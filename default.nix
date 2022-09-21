{ self, ... }: {
  perSystem = { config, self', inputs', system, pkgs, ... }:

    let
      dependencies = with config.purs-nix.ps-pkgs; [
        datetime
        either
        formatters
        self'.packages.cn-debug
        self'.packages.pre
      ];
      npmlock2nix = pkgs.callPackages self.inputs.npmlock2nix { };
      foreign.TimeZone.node_modules =
        (npmlock2nix.node_modules { src = ./.; }) + /node_modules;

      ps = config.purs-nix.purs {
        inherit dependencies foreign;
        test-dependencies = [ self'.packages.test-utils ];
        test-module = "Test.TimeZone";
        dir = ./.;
      };

    in

    {
      packages = {
        timezone =
          config.purs-nix.build {
            name = "timezone";
            src.path = ./.;
            info = { inherit dependencies foreign; };
          };
      };

      checks = {
        timezone-test = ps.test.check { };
      };

      extra-shell-tools = [ (config.make-command { inherit ps; pkg = ./.; }) ];
    };
}
