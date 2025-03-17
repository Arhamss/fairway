enum UtcTimeZone {
  utcMinus12(-12),
  utcMinus11(-11),
  utcMinus10(-10),
  utcMinus09(-9),
  utcMinus08(-8),
  utcMinus07(-7),
  utcMinus06(-6),
  utcMinus05(-5),
  utcMinus04(-4),
  utcMinus03(-3),
  utcMinus02(-2),
  utcMinus01(-1),
  utc00(0),
  utcPlus01(1),
  utcPlus02(2),
  utcPlus03(3),
  utcPlus04(4),
  utcPlus05(5),
  utcPlus06(6),
  utcPlus07(7),
  utcPlus08(8),
  utcPlus09(9),
  utcPlus10(10),
  utcPlus11(11),
  utcPlus12(12);

  const UtcTimeZone(this.offset);

  final int offset;
}

class UtcTimeZoneHelper {
  static const Map<UtcTimeZone, String> offsetToString = {
    UtcTimeZone.utcMinus12: 'UTC-12:00',
    UtcTimeZone.utcMinus11: 'UTC-11:00',
    UtcTimeZone.utcMinus10: 'UTC-10:00',
    UtcTimeZone.utcMinus09: 'UTC-09:00',
    UtcTimeZone.utcMinus08: 'UTC-08:00',
    UtcTimeZone.utcMinus07: 'UTC-07:00',
    UtcTimeZone.utcMinus06: 'UTC-06:00',
    UtcTimeZone.utcMinus05: 'UTC-05:00',
    UtcTimeZone.utcMinus04: 'UTC-04:00',
    UtcTimeZone.utcMinus03: 'UTC-03:00',
    UtcTimeZone.utcMinus02: 'UTC-02:00',
    UtcTimeZone.utcMinus01: 'UTC-01:00',
    UtcTimeZone.utc00: 'UTC+00:00',
    UtcTimeZone.utcPlus01: 'UTC+01:00',
    UtcTimeZone.utcPlus02: 'UTC+02:00',
    UtcTimeZone.utcPlus03: 'UTC+03:00',
    UtcTimeZone.utcPlus04: 'UTC+04:00',
    UtcTimeZone.utcPlus05: 'UTC+05:00',
    UtcTimeZone.utcPlus06: 'UTC+06:00',
    UtcTimeZone.utcPlus07: 'UTC+07:00',
    UtcTimeZone.utcPlus08: 'UTC+08:00',
    UtcTimeZone.utcPlus09: 'UTC+09:00',
    UtcTimeZone.utcPlus10: 'UTC+10:00',
    UtcTimeZone.utcPlus11: 'UTC+11:00',
    UtcTimeZone.utcPlus12: 'UTC+12:00',
  };

  static const Map<int, String> utcOffsetToLocation = {
    -12: 'Pacific/Kwajalein',
    -11: 'Pacific/Samoa',
    -10: 'Pacific/Honolulu',
    -9: 'America/Anchorage',
    -8: 'America/Los_Angeles',
    -7: 'America/Denver',
    -6: 'America/Chicago',
    -5: 'America/New_York',
    -4: 'America/Houston',
    -3: 'America/Argentina/Buenos_Aires',
    -2: 'America/Noronha',
    -1: 'Atlantic/Azores',
    0: 'UTC',
    1: 'Europe/Paris',
    2: 'Europe/Berlin',
    3: 'Europe/Moscow',
    4: 'Asia/Dubai',
    5: 'Asia/Karachi',
    6: 'Asia/Dhaka',
    7: 'Asia/Bangkok',
    8: 'Asia/Singapore',
    9: 'Asia/Tokyo',
    10: 'Australia/Sydney',
    11: 'Pacific/Noumea',
    12: 'Pacific/Auckland',
  };

  static Future<List<Map<String, String>>> loadUtcTimeZones() async {
    return UtcTimeZone.values.map((timezone) {
      final location = utcOffsetToLocation[timezone.offset] ?? 'UTC';
      return {
        'name': offsetToString[timezone] ?? '',
        'offset': timezone.offset.toString(),
        'location': location,
      };
    }).toList();
  }

  static List<Map<String, String>> getTimeZones() {
    return UtcTimeZone.values.map((zone) {
      final location = utcOffsetToLocation[zone.offset] ?? 'UTC';
      return {
        'name': offsetToString[zone]!,
        'offset': zone.offset.toString(),
        'location': location,
      };
    }).toList();
  }

  static String toOffsetString(UtcTimeZone zone) {
    return offsetToString[zone] ?? 'UTC+00:00';
  }
}
