// Path: lib/features/profile/presentation/widgets/language_tile.dart
import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  final String flag;
  final String language;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.flag,
    required this.language,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: ListTile(
          leading: Text(flag, style: const TextStyle(fontSize: 28)),
          title: Text(language,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: colorScheme.primary)
              : null,
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}