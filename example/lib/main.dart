import 'package:example/models/schedule_example.dart';
import 'package:flutter/material.dart';
import 'package:weekly_schedule_calendar/weekly_schedule_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example app for weekly_schedule_calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WeeklyScheduleCalendar(
              weeklySchedules: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
