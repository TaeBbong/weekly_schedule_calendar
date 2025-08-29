import 'package:example/models/schedule_example.dart';
import 'package:example/repository/mockup_repository.dart';
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
            WeeklyScheduleCalendar<ScheduleExample>(
              startDate: DateTime.now(),
              titleBuilder: (context, selected) {
                return Text(
                  '${selected.year}. ${selected.month}',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                );
              },
              weekdayLabels: ['일', '월', '화', '수', '목', '금', '토'],
              scheduleLoader: MockupRepository().fetchWeeklySchedules,
              titleOf: (schedule) => schedule.subject,
              subtitleOf: (schedule) => schedule.duration,
            ),
          ],
        ),
      ),
    );
  }
}
