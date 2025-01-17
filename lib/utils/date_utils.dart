import 'package:intl/intl.dart';

class DateUtils {
  // Format a DateTime object to "YYYY-MM-DD"
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Generate sequential dates between start and end
  static List<String> generateDateRange(DateTime startDate, int days) {
    return List.generate(days, (index) {
      final currentDate = startDate.add(Duration(days: index));
      return formatDate(currentDate);
    });
  }

  // Ensure dates are within the correct range
  static bool isDateInRange(
      DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate.subtract(Duration(days: 1))) &&
        date.isBefore(endDate.add(Duration(days: 1)));
  }
}
