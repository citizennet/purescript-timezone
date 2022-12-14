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
  foreign.TimeZone = {
    type = "npm";
    path = ./.;
  };
  test-dependencies = [
    "test-utils"
  ];
  test-module = "Test.TimeZone";
}
