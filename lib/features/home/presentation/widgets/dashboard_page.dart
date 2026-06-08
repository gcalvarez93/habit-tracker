// Path: lib/features/home/presentation/widgets/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/presentation/widgets/habit_stats_card.dart';
import '../../../home/presentation/pages/home_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final habitState = ref.watch(habitProvider);

    final userName = authState is AuthAuthenticated
        ? authState.user.name ?? 'Usuario'
        : 'Usuario';

    final habits = habitState is HabitLoaded ? habitState.habits : <HabitEntity>[];
    final completedToday = habits.where((h) => h.completedToday).length;
    final totalHabits = habits.length;
    final bestStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(habitProvider.notifier).loadHabits(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.greeting(userName),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          l10n.todaySummary,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () =>
                      ref.read(homeIndexProvider.notifier).state = 2,
                      child: CircleAvatar(
                        backgroundColor:
                        const Color(0xFF7C3AED).withOpacity(0.1),
                        child: const Icon(Icons.person,
                            color: Color(0xFF7C3AED)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Progress card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9F67FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.completedToday,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedToday / $totalHabits',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (totalHabits > 0)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: completedToday / totalHabits,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 8,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    HabitStatsCard(
                      label: l10n.streak,
                      value: '$bestStreak',
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    HabitStatsCard(
                      label: l10n.habits,
                      value: '$totalHabits',
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF7C3AED),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Today's habits
                Text(
                  l10n.navHabits,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                if (habitState is HabitLoading)
                  const Center(child: CircularProgressIndicator())
                else if (habits.isEmpty)
                  Center(
                    child: Text(
                      l10n.noHabits,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                else
                  ...habits.take(3).map(
                        (h) => HabitCard(
                      habit: h,
                      onComplete: () => ref
                          .read(habitProvider.notifier)
                          .completeHabit(h.id),
                      onDelete: () => ref
                          .read(habitProvider.notifier)
                          .deleteHabit(h.id),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}