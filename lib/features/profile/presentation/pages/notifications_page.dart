// Path: lib/features/profile/presentation/pages/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../widgets/notification_tile.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileProvider);

    if (profileState is ProfileError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.notifications),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: ErrorRetryView(
            message: profileState.failure.userMessage(l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.read(profileProvider.notifier).loadProfile(),
          ),
        ),
      );
    }

    if (profileState is! ProfileLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = profileState.profile;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.notifications),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          NotificationTile(
            title: l10n.notificationsGeneral,
            subtitle: l10n.notificationsGeneralSubtitle,
            value: profile.notifications,
            onChanged: (value) async {
              final messenger = ScaffoldMessenger.of(context);
              final saved = await ref.read(profileProvider.notifier).updateProfile(
                name: profile.name,
                language: profile.language,
                notifications: value,
              );
              if (!saved) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.profileUpdateError),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}