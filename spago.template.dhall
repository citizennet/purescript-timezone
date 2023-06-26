{-
{{GENERATED_DOC}}

A PureScript library for manipulating time zones with moment-timezone
-}
let
  name = "timezone"
in
  { name
  , dependencies =
      [ "datetime"
      , "formatters"
      , "pre"
      , "prelude"
      , "test-unit"
      ]
  -- This path is relative to config file
  , packages = {{PACKAGES_DIR}}/packages.dhall
  -- This path is relative to project root
  -- See https://github.com/purescript/spago/issues/648
  , sources = [ "{{SOURCES_DIR}}/src/**/*.purs", "{{SOURCES_DIR}}/test/**/*.purs" ]
  }
