// Path: lib/features/profile/presentation/widgets/faq_tile.dart
import 'package:flutter/material.dart';

class FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const FaqTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: ExpansionTile(
          title: Text(question,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(answer,
                  style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}