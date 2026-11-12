// Path: lib/core/network/dio_failure_mapper.dart
import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/failures.dart';

/// Traduce cualquier excepción de la capa de datos a un [Failure] tipado.
///
/// El `message` resultante es solo para logs: contiene el tipo de error, el
/// método, la ruta y el código HTTP, pero nunca el cuerpo de la respuesta.
Failure mapToFailure(Object error) {
  if (error is DioException) return _fromDio(error);
  return Failure.unknown(message: '${error.runtimeType}: $error');
}

Failure _fromDio(DioException e) {
  final status = e.response?.statusCode;
  final detail = '${e.type.name} ${e.requestOptions.method} '
      '${e.requestOptions.path}${status != null ? ' -> $status' : ''}';

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return Failure.timeout(message: detail);
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return Failure.network(message: detail);
    case DioExceptionType.badResponse:
      return _fromStatus(status, detail);
    case DioExceptionType.cancel:
      return Failure.unknown(message: detail);
    case DioExceptionType.unknown:
      return e.error is SocketException
          ? Failure.network(message: detail)
          : Failure.unknown(message: '$detail (${e.error.runtimeType})');
  }
}

Failure _fromStatus(int? status, String detail) {
  switch (status) {
    case 401:
    case 403:
      return Failure.auth(message: detail);
    case 404:
      return Failure.notFound(message: detail);
    case 400:
    case 422:
      return Failure.rejected(message: detail);
    default:
      return Failure.server(message: detail);
  }
}