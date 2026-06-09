// Path: lib/features/profile/presentation/pages/help_page.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/config/app_config.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/faq_tile.dart';
import '../widgets/help_section.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _version = '${info.version}+${info.buildNumber}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.help),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          HelpSection(
              icon: Icons.email_outlined,
              title: l10n.contact,
              content: AppConfig.contactEmail),
          HelpSection(
              icon: Icons.language_outlined, title: 'Web', content: AppConfig.webUrl),
          HelpSection(
              icon: Icons.info_outline,
              title: l10n.version,
              content: _version.isEmpty ? '...' : _version),
          const SizedBox(height: 24),
          Text(l10n.faq,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          FaqTile(question: l10n.faq1Question, answer: l10n.faq1Answer),
          FaqTile(question: l10n.faq2Question, answer: l10n.faq2Answer),
          FaqTile(question: l10n.faq3Question, answer: l10n.faq3Answer),
          FaqTile(question: l10n.faq4Question, answer: l10n.faq4Answer),
        ],
      ),
    );
  }
}