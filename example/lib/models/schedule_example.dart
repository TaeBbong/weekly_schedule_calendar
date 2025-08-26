class ScheduleExample {
  final String subject;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleExample({
    required this.subject,
    required this.startTime,
    required this.endTime,
  });

  String get duration =>
      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
}
