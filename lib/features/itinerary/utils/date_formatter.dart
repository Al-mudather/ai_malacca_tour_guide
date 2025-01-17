class DateFormatter {
  static String formatDate(String date) {
    if (date.isEmpty) return '';
    final dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
