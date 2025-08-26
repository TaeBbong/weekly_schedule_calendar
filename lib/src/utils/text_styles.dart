import 'package:flutter/material.dart';

abstract class TextStyles {
  static TextStyle header(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ) ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
  }

  static TextStyle weekdayLabel(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  }

  static TextStyle dayNumberUnselected(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ) ??
        const TextStyle(fontSize: 16);
  }

  static TextStyle dayNumberSelected(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  }

  static TextStyle listTitle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  }

  static TextStyle listSubtitle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ) ??
        const TextStyle(fontSize: 14);
  }
}
