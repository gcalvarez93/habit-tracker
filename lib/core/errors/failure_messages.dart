// Path: lib/core/errors/failure_messages.dart
import '../../l10n/app_localizations.dart';
import 'failures.dart';

/// Convierte un [Failure] en el texto localizado que ve el usuario.
///
/// Nunca expone el `message` técnico del fallo (va solo a los logs).
extension FailureMessage on Failure {
  String userMessage(AppLocalizations l10n) => when(
    network: (_) => l10n.errorNetwork,
    timeout: (_) => l10n.errorTimeout,
    server: (_) => l10n.errorServer,
    auth: (_) => l10n.errorSession,
    notFound: (_) => l10n.errorNotFound,
    rejected: (_) => l10n.errorRejected,
    unknown: (_) => l10n.errorUnknown,
  );
}