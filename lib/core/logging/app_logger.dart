// Path: lib/core/logging/app_logger.dart
import 'dart:developer' as developer;

/// Registro de eventos de la app con contexto.
///
/// Envuelve `developer.log` para que todos los mensajes lleven un nombre de
/// origen y un nivel, y se puedan filtrar en DevTools. Los niveles siguen los
/// valores de `package:logging` (800 = info, 900 = warning, 1000 = severe).
abstract final class AppLogger {
  static const String _name = 'HabitTracker';

  static void info(String message) =>
      developer.log(message, name: _name, level: 800);

  static void warning(String message) =>
      developer.log(message, name: _name, level: 900);

  /// [context] indica dónde ocurrió el error, por ejemplo
  /// `HabitRepositoryImpl.getHabits`.
  static void error(String context, Object error, StackTrace stackTrace) =>
      developer.log(
        context,
        name: _name,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
}