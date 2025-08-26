import 'package:example/models/schedule_example.dart';

class MockupRepository {
  Future<List<List<dynamic>>> fetchWeeklySchedules() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      [
        ScheduleExample(
          subject: 'Sunday Job',
          startTime: DateTime(2025, 8, 17, 9, 00),
          endTime: DateTime(2025, 8, 17, 11, 00),
        ),
        ScheduleExample(
          subject: 'Lunch Time',
          startTime: DateTime(2025, 8, 17, 12, 00),
          endTime: DateTime(2025, 8, 17, 13, 30),
        ),
      ],
      [
        ScheduleExample(
          subject: 'Monday Routine',
          startTime: DateTime(2025, 8, 18, 9, 00),
          endTime: DateTime(2025, 8, 18, 11, 00),
        ),
        ScheduleExample(
          subject: 'Lunch Time',
          startTime: DateTime(2025, 8, 18, 12, 00),
          endTime: DateTime(2025, 8, 18, 13, 30),
        ),
      ],
      [
        ScheduleExample(
          subject: 'Project Review',
          startTime: DateTime(2025, 8, 19, 9, 00),
          endTime: DateTime(2025, 8, 19, 11, 00),
        ),
        ScheduleExample(
          subject: 'Lunch Time',
          startTime: DateTime(2025, 8, 19, 12, 00),
          endTime: DateTime(2025, 8, 19, 13, 30),
        ),
      ],
      [],
      [
        ScheduleExample(
          subject: 'Do Something Job',
          startTime: DateTime(2025, 8, 21, 9, 00),
          endTime: DateTime(2025, 8, 21, 11, 00),
        ),
        ScheduleExample(
          subject: 'Lunch Time',
          startTime: DateTime(2025, 8, 21, 12, 00),
          endTime: DateTime(2025, 8, 21, 13, 30),
        ),
      ],
      [],
      [
        ScheduleExample(
          subject: 'Saturday is good',
          startTime: DateTime(2025, 8, 23, 9, 00),
          endTime: DateTime(2025, 8, 23, 11, 00),
        ),
        ScheduleExample(
          subject: 'Lunch Time',
          startTime: DateTime(2025, 8, 23, 12, 00),
          endTime: DateTime(2025, 8, 23, 13, 30),
        ),
      ],
    ];
  }
}
