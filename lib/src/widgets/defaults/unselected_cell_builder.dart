import 'package:flutter/material.dart';
import 'package:weekly_schedule_calendar/src/utils/utils.dart';

class DefaultUnselectedCellBuilder extends StatelessWidget {
  final DateTime day;

  const DefaultUnselectedCellBuilder({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Text(
        day.day.toString().padLeft(2, '0'),
        style: TextStyles.dayNumberUnselected(context),
      ),
    );
  }
}
