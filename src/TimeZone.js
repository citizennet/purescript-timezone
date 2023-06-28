// module TimeZone

var Moment = require("moment-timezone");

exports._abbr = timezone => dateTime =>
  Moment(dateTime).tz(timezone).zoneAbbr();

exports._format = timezone => dateTime => formatter =>
  Moment(dateTime).tz(timezone).format(formatter);

exports._offset = timezone => dateTime =>
  Moment(dateTime).tz(timezone).utcOffset();

exports.timezones = Moment.tz.names();

exports.validate = name => Moment.tz.zone(name) !== null;
