import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;

    // Alternative using intl package (more robust for different locales/calendars):
    // final nowFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // final dateFormatted = DateFormat('yyyy-MM-dd').format(this);
    // return dateFormatted == nowFormatted;
  }

  // Is same day as
  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
