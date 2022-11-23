{ pkgs, npmlock2nix, ... }:

{
  name = "timezone";
  srcs = [ "src" ];
  dependencies = [
    "datetime"
    "either"
    "formatters"
    "cn-debug"
    "pre"
  ];
  foreign.TimeZone.node_modules =
    (npmlock2nix.node_modules { src = ./.; }) + /node_modules;
  test-dependencies = [
    "test-utils"
  ];
  test-module = "Test.TimeZone";
}
