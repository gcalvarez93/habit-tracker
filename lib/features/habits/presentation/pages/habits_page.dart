// Path: lib/features/habits/presentation/pages/habits_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/habit_provider.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_empty_state.dart';
import '../widgets/habit_failure_listener.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final habitState = ref.watch(habitProvider);
    listenToHabitActionFailures(context, ref, l10n);

    Future<void> reload() => ref.read(habitProvider.notifier).loadHabits();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navHabits),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: switch (habitState) {
        HabitLoading() => const Center(child: CircularProgressIndicator()),
        HabitLoaded(:final habits) => RefreshIndicator(
          onRefresh: reload,
          child: habits.isEmpty
              ? const _ScrollableCenter(child: HabitEmptyState())
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
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
        HabitError(:final failure) => RefreshIndicator(
          onRefresh: reload,
          child: _ScrollableCenter(
            child: ErrorRetryView(
              message: failure.userMessage(l10n),
              retryLabel: l10n.actionRetry,
              onRetry: reload,
            ),
          ),
        ),
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

/// Centra su contenido y permite hacer pull-to-refresh aunque no haya lista.
class _ScrollableCenter extends StatelessWidget {
  const _ScrollableCenter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}