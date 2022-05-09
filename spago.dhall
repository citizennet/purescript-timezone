{-
A PureScript library for manipulating time zones with moment-timezone
-}
let
  name = "timezone"
in
  { name
  , dependencies =
      [ "datetime"
      , "either"
      , "formatters"
      , "pre"
      , "test-unit"
      ]
  , packages = ../../packages.dhall
  -- Due to a spago bug (see https://github.com/purescript/spago/issues/648)
  -- `sources` are relative to root instead of config file.
  , sources = [ "lib/${name}/src/**/*.purs", "lib/${name}/test/**/*.purs" ]
  }