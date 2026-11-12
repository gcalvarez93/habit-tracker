// Path: lib/core/errors/failures.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Fallo tipado de la capa de datos.
///
/// `message` es el detalle técnico pensado para logs y depuración. La UI NO
/// debe mostrarlo: usa `FailureMessage.userMessage(l10n)` para obtener el
/// texto localizado.
@freezed
class Failure with _$Failure {
  /// Sin conexión o servidor inalcanzable.
  const factory Failure.network({required String message}) = NetworkFailure;

  /// El servidor no respondió a tiempo (connect/send/receive).
  const factory Failure.timeout({required String message}) = TimeoutFailure;

  /// Error 5xx o respuesta inesperada del servidor.
  const factory Failure.server({required String message}) = ServerFailure;

  /// 401/403 de la API, o error de autenticación de Firebase.
  const factory Failure.auth({required String message}) = AuthFailure;

  /// 404: el recurso no existe.
  const factory Failure.notFound({required String message}) = NotFoundFailure;

  /// 400/422: el servidor rechazó los datos enviados.
  const factory Failure.rejected({required String message}) = RejectedFailure;

  const factory Failure.unknown({required String message}) = UnknownFailure;
}