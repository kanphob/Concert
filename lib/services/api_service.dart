import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/concert.dart';
import '../models/booking.dart';
import '../app_core/token_provider.dart';

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:3000';
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    // Android Emulator to access host machine
    return 'http://10.0.2.2:3000';
  }

  // iOS Simulator / macOS / Windows / Linux
  return 'http://localhost:3000';
}

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: getBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenProvider.getToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Debug print access token from header
        log('[API] AccessToken: $token');

        log('[API] ${options.method} ${options.baseUrl}${options.path}');

        return handler.next(options);
      },
          onError: (DioException e, handler) async {
            // Log error details
            log(
              '[API ERROR] ${e.requestOptions.method} '
                  '${e.requestOptions.baseUrl}${e.requestOptions.path} '
                  '${e.response?.statusCode ?? 'NA'} ${e.message}',
              error: e,
              stackTrace: e.stackTrace,
            );

            // Force logout on 401 Unauthorized
            if (e.response?.statusCode == 401) {
              // Clear stored token
              await TokenProvider.clearToken();
              // Optionally you could navigate to login screen or trigger app-wide logout logic
              log('Unauthorized (401) - token cleared, user should be logged out.');
            }

            return handler.next(e);
          },
    ),
  );

  static Future<List<Concert>> fetchConcerts() async {
    try {
      final response = await _dio.get('/concert');

      if (response.statusCode == 200) {
        final data = response.data as List;

        return data
            .map((json) => Concert.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load concerts (${response.statusCode})');
    } catch (e, stack) {
      log('Error fetching concerts: $e', stackTrace: stack);
      rethrow;
    }
  }

  static Future<Concert> fetchConcertDetail(int id) async {
    try {
      final response = await _dio.get('/concert/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Concert.fromJson(data);
      }

      throw Exception('Failed to load concert detail (${response.statusCode})');
    } catch (e, stack) {
      log('Error fetching concert detail for id $id: $e', stackTrace: stack);
      rethrow;
    }
  }

  static Future<Booking> createBooking(int concertId, int quantity) async {
    try {
      final response = await _dio.post(
        '/booking',
        data: {
          'concertId': concertId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return Booking.fromJson(data);
      }

      throw Exception('Failed to create booking (${response.statusCode})');
    } catch (e, stack) {
      log('Error creating booking for concert $concertId: $e', stackTrace: stack);
      rethrow;
    }
  }

  static Future<List<Booking>> fetchBookings() async {
    try {
      final response = await _dio.get('/booking');

      if (response.statusCode == 200) {
        final data = response.data as List;

        return data
            .map((json) => Booking.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load bookings (${response.statusCode})');
    } catch (e, stack) {
      log('Error fetching bookings: $e', stackTrace: stack);
      rethrow;
    }
  }
}
