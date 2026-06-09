// Path: lib/features/profile/presentation/widgets/profile_option.dart
import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
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
          leading: Icon(icon, color: colorScheme.primary),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16, color: colorScheme.onSurface.withOpacity(0.4)),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}