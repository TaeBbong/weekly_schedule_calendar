import 'package:flutter/material.dart';
import 'package:weekly_schedule_calendar/src/utils/utils.dart';

class DefaultTitleBuilder extends StatelessWidget {
  final DateTime selected;

  const DefaultTitleBuilder({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Text(selected.dateToYearMonth(), style: TextStyles.header(context));
  }
}
