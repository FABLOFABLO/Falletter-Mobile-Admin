import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  static String mmdd(DateTime date) {
    return DateFormat('MM월 dd일').format(date);
  }

  /// 앞자리 0 없이 표시 (예: 3월 14일)
  static String md(DateTime date) {
    return DateFormat('M월 d일').format(date);
  }

  /// 현재 시각 기준 상대 시간 (예: 28분 전)
  static String relative(DateTime date) {
    return timeago.format(date, locale: 'ko');
  }

  static String full(DateTime date) {
    return DateFormat('yyyy.MM.dd HH:mm').format(date);
  }
}
