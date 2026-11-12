// Path: test/core/network/dio_failure_mapper_test.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/core/network/dio_failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final options = RequestOptions(path: '/transactions', method: 'POST');

  DioException dioError(
      DioExceptionType type, {
        int? status,
        Object? error,
        dynamic body,
      }) =>
      DioException(
        requestOptions: options,
        type: type,
        error: error,
        response: status == null
            ? null
            : Response(requestOptions: options, statusCode: status, data: body),
      );

  group('timeouts', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      test('$type -> timeout', () {
        expect(mapToFailure(dioError(type)), isA<TimeoutFailure>());
      });
    }
  });

  group('red', () {
    test('connectionError -> network', () {
      expect(mapToFailure(dioError(DioExceptionType.connectionError)),
          isA<NetworkFailure>());
    });

    test('unknown con SocketException -> network', () {
      final failure = mapToFailure(dioError(
        DioExceptionType.unknown,
        error: const SocketException('sin red'),
      ));
      expect(failure, isA<NetworkFailure>());
    });

    test('unknown con otro error -> unknown', () {
      final failure = mapToFailure(dioError(
        DioExceptionType.unknown,
        error: StateError('x'),
      ));
      expect(failure, isA<UnknownFailure>());
    });
  });

  group('códigos HTTP', () {
    final cases = <int, Matcher>{
      400: isA<RejectedFailure>(),
      422: isA<RejectedFailure>(),
      401: isA<AuthFailure>(),
      403: isA<AuthFailure>(),
      404: isA<NotFoundFailure>(),
      500: isA<ServerFailure>(),
      503: isA<ServerFailure>(),
    };

    cases.forEach((status, matcher) {
      test('$status -> $matcher', () {
        final failure = mapToFailure(
          dioError(DioExceptionType.badResponse, status: status),
        );
        expect(failure, matcher);
      });
    });
  });

  group('detalle técnico', () {
    test('incluye método, ruta y código, pero nunca el cuerpo', () {
      final failure = mapToFailure(dioError(
        DioExceptionType.badResponse,
        status: 422,
        body: {'error': 'SECRETO-interno'},
      ));

      final message = failure.when(
        network: (m) => m,
        timeout: (m) => m,
        server: (m) => m,
        auth: (m) => m,
        notFound: (m) => m,
        rejected: (m) => m,
        unknown: (m) => m,
      );

      expect(message, contains('POST'));
      expect(message, contains('/transactions'));
      expect(message, contains('422'));
      expect(message, isNot(contains('SECRETO-interno')));
    });
  });

  test('una excepción que no es de Dio -> unknown', () {
    expect(mapToFailure(StateError('boom')), isA<UnknownFailure>());
  });
}