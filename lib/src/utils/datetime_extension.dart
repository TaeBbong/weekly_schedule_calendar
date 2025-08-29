extension KoreanDate on DateTime {
  String dateToYearMonth() => '$year년 $month월';
}

extension NormalizeDate on DateTime {
  DateTime date() => DateTime(year, month, day);
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
