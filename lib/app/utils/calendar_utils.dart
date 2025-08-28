import 'package:intl/intl.dart';

class CalendarUtils {
  static getFormattedTodayDate() {
    final now = DateTime.now();

    // Weekday full name
    const weekdays = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[now.weekday - 1];

    // Month full name
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[now.month - 1];

    return '$weekday, $month ${now.day}, ${now.year}';
  }

  static int getDaysInCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  int getDaysInMonth(int month, int year) {
    // Handle February (check for leap year)
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }

    // Handle months with 30 or 31 days
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }

    return 31;
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }

  static String getCurrentMonthName() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  static int getCurrentYear() {
    return DateTime.now().year;
  }

  static int getCurrentDate() {
    return DateTime.now().day;
  }

  static String getCurrentDayName() {
    final now = DateTime.now();
    const days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
    return days[now.weekday - 1]; // weekday is 1-7 (Monday=1, Sunday=7)
  }

  String getCurrentTime12Hour() {
    final now = DateTime.now();
    final hour =
        now.hour % 12 == 0 ? 12 : now.hour % 12; // Convert to 12-hour (1-12)
    final minute = now.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String getAmPm() {
    final now = DateTime.now();
    return now.hour < 12 ? 'AM' : 'PM';
  }

  static getMonthName(int monthNumber) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (monthNumber < 1 || monthNumber > 12) {
      throw RangeError('Month number must be between 1 and 12');
    }

    return months[monthNumber - 1];
  }

  static bool containsAlphabet(String input) {
    return RegExp(r'[a-zA-Z]').hasMatch(input);
  }
}
