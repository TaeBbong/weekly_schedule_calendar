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
      body: FutureBuilder(
        future: MockupRepository().fetchWeeklySchedules(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WeeklyScheduleCalendar(
                  schedules: snapshot.data!,
                  title: 'subject',
                  subtitle: 'duration',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
