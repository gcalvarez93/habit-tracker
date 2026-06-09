// Path: lib/features/habits/presentation/widgets/add_habit_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/habit_provider.dart';

class AddHabitSheet extends ConsumerStatefulWidget {
  const AddHabitSheet({super.key});

  @override
  ConsumerState<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends ConsumerState<AddHabitSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedFrequency = 'daily';
  String _selectedIcon = '⭐';
  String _selectedColor = '#7C3AED';

  final List<String> _icons = [
    '⭐', '💪', '📚', '🏃', '🧘', '💧',
    '🍎', '😴', '🎯', '✍️', '🎵', '🌿',
  ];

  final List<String> _colors = [
    '#7C3AED', '#2563EB', '#059669', '#D97706',
    '#DC2626', '#DB2777', '#0891B2', '#65A30D',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addHabit,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.habitName,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.habitDescription,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFrequency = 'daily'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedFrequency == 'daily'
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.daily,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedFrequency == 'daily'
                              ? Colors.white
                              : colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFrequency = 'weekly'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedFrequency == 'weekly'
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.weekly,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedFrequency == 'weekly'
                              ? Colors.white
                              : colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.selectIcon,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _icons.map((icon) => GestureDetector(
                onTap: () => setState(() => _selectedIcon = icon),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIcon == icon
                        ? colorScheme.primary.withOpacity(0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: _selectedIcon == icon
                        ? Border.all(color: colorScheme.primary)
                        : null,
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Text(l10n.selectColor,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colors.map((color) {
                final c = Color(int.parse(color.replaceFirst('#', '0xFF')));
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
                          ? Border.all(color: colorScheme.onSurface, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) return;
                await ref.read(habitProvider.notifier).createHabit(
                  name: _nameController.text.trim(),
                  description: _descriptionController.text.trim(),
                  frequency: _selectedFrequency,
                  icon: _selectedIcon,
                  color: _selectedColor,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.habitCreatedSuccess),
                      backgroundColor: colorScheme.primary,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.save, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}