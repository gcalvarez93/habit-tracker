// Path: lib/features/habits/presentation/widgets/habit_empty_state.dart
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class HabitEmptyState extends StatelessWidget {
  const HabitEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80,
              color: colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(l10n.noHabits,
              style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5), fontSize: 16)),
        ],
      ),
    );
  }
}