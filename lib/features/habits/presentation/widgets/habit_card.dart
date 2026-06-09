// Path: lib/features/habits/presentation/widgets/habit_card.dart
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/habit_entity.dart';

class HabitCard extends StatelessWidget {
  final HabitEntity habit;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onComplete,
    required this.onDelete,
  });

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _parseColor(habit.color);
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(habit.icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  if (habit.description.isNotEmpty)
                    Text(
                      habit.description,
                      style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5), fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        l10n.streakDays(habit.streak),
                        style: TextStyle(
                            color: color, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: habit.completedToday ? null : onComplete,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: habit.completedToday ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: habit.completedToday
                        ? color
                        : colorScheme.onSurface.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: habit.completedToday
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}