import 'package:flutter/material.dart';
import 'package:weekly_schedule_calendar/src/utils/utils.dart';

class DefaultSelectedCellBuilder extends StatelessWidget {
  final DateTime day;

  const DefaultSelectedCellBuilder({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        day.day.toString().padLeft(2, '0'),
        style: TextStyles.dayNumberSelected(context),
      ),
    );
  }
}
