// Path: lib/features/habits/presentation/pages/habits_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_empty_state.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final habitState = ref.watch(habitProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navHabits),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: switch (habitState) {
        HabitLoading() => const Center(child: CircularProgressIndicator()),
        HabitLoaded(:final habits) => habits.isEmpty
            ? const HabitEmptyState()
            : RefreshIndicator(
          onRefresh: () => ref.read(habitProvider.notifier).loadHabits(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            itemBuilder: (context, index) => HabitCard(
              habit: habits[index],
              onComplete: () => ref
                  .read(habitProvider.notifier)
                  .completeHabit(habits[index].id),
              onDelete: () => ref
                  .read(habitProvider.notifier)
                  .deleteHabit(habits[index].id),
            ),
          ),
        ),
        HabitError(:final message) =>
            Center(child: Text(message, style: const TextStyle(color: Colors.red))),
        _ => const SizedBox(),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddHabitSheet(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}