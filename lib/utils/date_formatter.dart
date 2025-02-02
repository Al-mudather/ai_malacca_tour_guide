import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'No date';
    }

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  static String formatDateRange(String? startDate, String? endDate) {
    return '${formatDate(startDate)} - ${formatDate(endDate)}';
  }

  static String formatDayDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}
