module Test.TimeZone (main) where

import CitizenNet.Prelude

import Data.Formatter.DateTime as Data.Formatter.DateTime
import Data.Formatter.Parser.Interval as Data.Formatter.Parser.Interval
import Test.Unit as Test.Unit
import Test.Unit.Main as Test.Unit.Main
import Test.Utils as Test.Utils
import TimeZone as TimeZone

main :: Effect Unit
main = Test.Unit.Main.runTest suite

suite :: Test.Unit.TestSuite
suite =
  Test.Unit.suite "Test.TimeZone" do
    Test.Unit.suite "timezone" do
      Test.Unit.test "parses \"America/Los_Angeles\" timezone"
        let
          actual = TimeZone.timezone "America/Los_Angeles"

          expected = Right TimeZone.pacific
        in
          Test.Utils.equal expected actual
      Test.Unit.test "parses \"UTC\" timezone"
        let
          actual = TimeZone.timezone "UTC"

          expected = Right TimeZone.utc
        in
          Test.Utils.equal expected actual
      Test.Unit.test "fails to parse invalid TimeZone" case TimeZone.timezone "Mars" of
        Left _ -> Test.Unit.success
        Right _ -> Test.Unit.failure "Did not expect to succeed"
    Test.Unit.suite "adjustFrom" do
      Test.Unit.test "adjusts date-time by subtracting timezone offset" do
        testAdjust
          { expected: "2020-07-31T00:00:00Z"
          , startString: "2020-07-30T17:00:00Z"
          , adjust: TimeZone.adjustFrom
          }
    Test.Unit.suite "adjustTo" do
      Test.Unit.test "adjusts date-time by adding timezone offset" do
        testAdjust
          { expected: "2020-07-30T17:00:00Z"
          , startString: "2020-07-31T00:00:00Z"
          , adjust: TimeZone.adjustTo
          }
    Test.Unit.suite "format" do
      Test.Unit.test "MM/D/YY hh:mm a"
        let
          expected = Right "07/30/20 10:00 am"

          actual = do
            pacific <- TimeZone.timezone "America/Los_Angeles"
            dateTime <-
              Data.Formatter.DateTime.unformat
                Data.Formatter.Parser.Interval.extendedDateTimeFormatInUTC
                "2020-07-30T17:00:00Z"
            pure $ TimeZone.format pacific dateTime "MM/D/YY hh:mm a"
        in
          Test.Utils.equal expected actual

testAdjust ::
  { expected :: String
  , startString :: String
  , adjust :: TimeZone.TimeZone -> DateTime -> Maybe DateTime
  } ->
  Test.Unit.Test
testAdjust { expected, startString, adjust } =
  let
    actual = do
      pacific <- TimeZone.timezone "America/Los_Angeles"
      start <-
        Data.Formatter.DateTime.unformat
          Data.Formatter.Parser.Interval.extendedDateTimeFormatInUTC
          startString
      result <-
        note
          ("Couldn't adjust date: " <> startString)
          (adjust pacific start)
      pure
        $ Data.Formatter.DateTime.format
            Data.Formatter.Parser.Interval.extendedDateTimeFormatInUTC
            result
  in
    Test.Utils.equal (Right expected) actual
