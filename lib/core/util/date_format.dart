import 'package:intl/intl.dart';

class DateFormatter {
  static String mmdd(DateTime date) {
    return DateFormat('MM월 dd일').format(date);
  }

  static String full(DateTime date) {
    return DateFormat('yyyy.MM.dd HH:mm').format(date);
  }
}