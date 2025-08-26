extension KoreanDate on DateTime {
  String dateToYearMonth() => '$year년 $month월';
}

extension NormalizeDate on DateTime {
  DateTime date() => DateTime(year, month, day);
}
