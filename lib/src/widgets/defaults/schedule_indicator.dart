import 'package:flutter/material.dart';

class DefaultScheduleIndicator extends StatelessWidget {
  const DefaultScheduleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CircleAvatar(radius: 4, backgroundColor: colorScheme.secondary);
  }
}
