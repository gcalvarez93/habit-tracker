// Path: lib/features/habits/presentation/widgets/habit_failure_listener.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/habit_provider.dart';

/// Avisa con un SnackBar cuando una operación falla con datos en pantalla
/// (recarga, completar o borrar un hábito). Debe llamarse desde `build`.
void listenToHabitActionFailures(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ) {
  ref.listen<HabitState>(habitProvider, (previous, next) {
    if (next is! HabitLoaded) return;
    final failure = next.actionFailure;
    if (failure == null) return;
    if (previous is HabitLoaded && identical(previous.actionFailure, failure)) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage(l10n)),
        backgroundColor: Colors.red,
      ),
    );
  });
}