import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTime12HourWithTimezone(DateTime? dateTime) {
  final formatter = DateFormat('hh:mm a z');
  return formatter.format(dateTime!.toLocal());
}

String formatDate(DateTime date) {
  final day = _getDayWithSuffix(date.day);
  final month = DateFormat('MMMM').format(date);
  final year = DateFormat('y').format(date);
  return '$day $month, $year';
}

String formatDateShort(DateTime? date) {
  final day = DateFormat('d').format(date!); // Day without suffix
  final month = DateFormat('MMM').format(date); // Shortened month, e.g., "Jan"
  final year = DateFormat('yy').format(date); // Shortened year, e.g., "24"
  return '$day $month $year'; // e.g., "1 Jan 24"
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String _getDayWithSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

// Helper function to format duration in hours and minutes from a Duration object
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}';
  } else if (hours > 0) {
    return '$hours hour${hours > 1 ? 's' : ''}';
  } else {
    return '$minutes minute${minutes > 1 ? 's' : ''}';
  }
}

// Helper function to format an integer (minutes) into "xx mins"
String formatDurationInMinutes(int? durationInMinutes) {
  if (durationInMinutes == null) {
    return 'Unknown Duration';
  } else {
    return '$durationInMinutes mins';
  }
}

class DateUtility {
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMM d').format(date);
    }
  }
}

class TimeZoneHelper {
  static String formatTimeToLocalTimeZone(DateTime utcTime) {
    final localTime = utcTime.toLocal();
    final timeFormat = DateFormat('hh:mm a');
    final formattedTime = timeFormat.format(localTime);

    final timeZoneAbbreviation = localTime.timeZoneName;

    return '$formattedTime $timeZoneAbbreviation';
  }

  static String formatTimeToHours(DateTime utcTime) {
    final localTime = utcTime.toLocal();
    final timeFormat = DateFormat('hh:mm a');
    final formattedTime = timeFormat.format(localTime);

    return formattedTime;
  }

  static String formatDateToLocalTimeZone(DateTime utcTime) {
    final localTime = utcTime.toLocal();
    final dateFormat = DateFormat('dd MMM yyyy');
    return dateFormat.format(localTime);
  }

  static String formatTimeOfDayToLocalTimeZone(
    TimeOfDay timeOfDay,
    DateTime classDate,
  ) {
    final dateTime = DateTime(
      classDate.year,
      classDate.month,
      classDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    final localTime = dateTime.toLocal();
    final timeFormat = DateFormat('hh:mm a');
    final formattedTime = timeFormat.format(localTime);

    final timeZoneAbbreviation = localTime.timeZoneName;

    return '$formattedTime $timeZoneAbbreviation';
  }
}
