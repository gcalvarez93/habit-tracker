// Path: lib/features/profile/presentation/pages/language_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../widgets/language_tile.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('es'));

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final profileState = ref.watch(profileProvider);
    final currentLanguage = profileState is ProfileLoaded
        ? profileState.profile.language
        : currentLocale.languageCode;

    Future<void> changeLanguage(String language) async {
      // Primero actualiza el locale inmediatamente
      ref.read(localeProvider.notifier).state = Locale(language);

      // Luego guarda en la API sin esperar
      if (profileState is ProfileLoaded) {
        final p = profileState.profile;
        ref.read(profileProvider.notifier).updateProfile(
          name: p.name,
          language: language,
          notifications: p.notifications,
        );
      }

      if (context.mounted) Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.language),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          LanguageTile(
            flag: '🇪🇸',
            language: 'Español',
            code: 'es',
            isSelected: currentLanguage == 'es',
            onTap: () => changeLanguage('es'),
          ),
          LanguageTile(
            flag: '🇬🇧',
            language: 'English',
            code: 'en',
            isSelected: currentLanguage == 'en',
            onTap: () => changeLanguage('en'),
          ),
        ],
      ),
    );
  }
}