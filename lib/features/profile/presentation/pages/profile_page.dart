// Path: lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_option.dart';
import 'edit_profile_page.dart';
import 'help_page.dart';
import 'language_page.dart';
import 'notifications_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final habitState = ref.watch(habitProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;

    final habits = habitState is HabitLoaded ? habitState.habits : [];
    final totalCompleted = habits.isEmpty ? 0 : habits.map((h) => h.totalCompleted).reduce((a, b) => a + b);
    final bestStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(l10n.navProfile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF9F67FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage: user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.photoUrl == null
                        ? Text(
                      user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Usuario',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        value: '${habits.length}',
                        label: l10n.habits,
                      ),
                      _StatItem(
                        value: '$bestStreak',
                        label: l10n.bestStreak,
                      ),
                      _StatItem(
                        value: '$totalCompleted',
                        label: l10n.totalCompleted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Opciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ProfileOption(
                    icon: Icons.person_outline,
                    title: l10n.editProfile,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage())),
                  ),
                  ProfileOption(
                    icon: Icons.notifications_outlined,
                    title: l10n.notifications,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NotificationsPage())),
                  ),
                  ProfileOption(
                    icon: Icons.language_outlined,
                    title: l10n.language,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LanguagePage())),
                  ),
                  ProfileOption(
                    icon: Icons.help_outline,
                    title: l10n.help,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HelpPage())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}