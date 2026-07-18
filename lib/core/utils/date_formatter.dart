import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// "19 يونيو 2026"
  static String formatFull(DateTime date) {
    return DateFormat('d MMMM yyyy', 'ar').format(date);
  }

  /// "19/06/2026"
  static String formatShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// "10:30 ص"
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a', 'ar').format(date);
  }

  /// "اليوم" أو "أمس" أو التاريخ الكامل
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'أمس';
    if (diff < 7) return '$diff أيام';
    return formatShort(date);
  }

  /// بداية اليوم الحالي
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// بداية الأسبوع الحالي
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// بداية الشهر الحالي
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
}
