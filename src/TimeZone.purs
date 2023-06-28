module TimeZone
  ( TimeZone
  , abbr
  , adjustFrom
  , adjustTo
  , format
  , name
  , pacific
  , timezone
  , timezones
  , utc
  ) where

import CitizenNet.Prelude

import Data.DateTime as Data.DateTime
import Data.Formatter.DateTime as Data.Formatter.DateTime
import Data.Formatter.Parser.Interval as Data.Formatter.Parser.Interval
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Time.Duration as Data.Time.Duration

newtype TimeZone =
  TimeZone String

derive instance newtypeTimeZone :: Newtype TimeZone _
derive instance genericTimeZone :: Generic TimeZone _
derive instance eqTimeZone :: Eq TimeZone

instance showTimeZone :: Show TimeZone where
  show x = genericShow x

foreign import _abbr :: TimeZone -> String -> String

foreign import _format :: TimeZone -> String -> String -> String

foreign import _offset :: TimeZone -> String -> Number

foreign import timezones :: Array TimeZone

foreign import validate :: String -> Boolean

abbr :: TimeZone -> DateTime -> String
abbr timezone' dateTime = _abbr timezone' (toUTCString dateTime)

adjustFrom :: TimeZone -> DateTime -> Maybe DateTime
adjustFrom timezone' dateTime =
  Data.DateTime.adjust
    (Data.Time.Duration.negateDuration (offset timezone' dateTime))
    dateTime

adjustTo :: TimeZone -> DateTime -> Maybe DateTime
adjustTo timezone' dateTime = Data.DateTime.adjust (offset timezone' dateTime) dateTime

format :: TimeZone -> DateTime -> String -> String
format timezone' dateTime formatter =
  _format
    timezone'
    (toUTCString dateTime)
    formatter

name :: TimeZone -> String
name = case _ of
  TimeZone name' -> name'

pacific :: TimeZone
pacific = TimeZone "America/Los_Angeles"

toUTCString :: DateTime -> String
toUTCString =
  Data.Formatter.DateTime.format
    Data.Formatter.Parser.Interval.extendedDateTimeFormatInUTC

offset :: TimeZone -> DateTime -> Data.Time.Duration.Minutes
offset timezone' dateTime =
  Data.Time.Duration.Minutes
    ( _offset
        timezone'
        (toUTCString dateTime)
    )

timezone :: String -> Either String TimeZone
timezone name'
  | validate name' = Right (TimeZone name')
  | otherwise = Left (show name' <> " is not a valid timezone")

utc :: TimeZone
utc = TimeZone "UTC"
