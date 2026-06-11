import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'request_signer.dart';

class MyDataService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final RequestSigner _signer;

  // Sandbox URL & Credentials
  static const String _baseUrl = 'https://sandbox.mydata.go.kr/api/v1';
  static const String _clientId = 'dummy_client_id_123';
  static const String _clientSecret = 'dummy_client_secret_456';
  static const String _tokenKey = 'mydata_access_token';

  MyDataService()
      : _dio = Dio(BaseOptions(baseUrl: _baseUrl)),
        _signer = RequestSigner(_clientSecret) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Automatically inject Bearer Token if available
        final token = await _storage.read(key: _tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Generate HMAC signature for the request body
        final timestamp = _signer.getCurrentTimestamp();
        final payload = options.data != null ? jsonEncode(options.data) : '';
        final signature = _signer.generateSignature(payload, timestamp);

        options.headers['x-api-timestamp'] = timestamp;
        options.headers['x-api-signature'] = signature;
        
        return handler.next(options);
      },
    ));
  }

  /// OAuth 2.0 Client Credentials Flow
  Future<void> fetchAccessToken() async {
    try {
      // In a real scenario, this endpoint doesn't need Bearer token but needs Basic Auth or form data
      final response = await _dio.post(
        '/oauth/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        if (token != null) {
          await _storage.write(key: _tokenKey, value: token);
        }
      }
    } catch (e) {
      // Handle error
      print('Error fetching access token: $e');
      throw Exception('Failed to obtain access token');
    }
  }

  /// Mock endpoint for fetching registered cards
  Future<List<Map<String, dynamic>>> fetchCardList() async {
    try {
      final response = await _dio.get('/cards');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['card_list'] ?? []);
      }
      return [];
    } on DioException catch (e) {
      // Return dummy data since this is a sandbox and endpoint doesn't really exist
      if (e.response?.statusCode == 404 || e.type == DioExceptionType.connectionError) {
        return [
          {
            'cardId': 'card_1234',
            'cardName': '신한 Deep Dream',
            'company': '신한카드',
            'isCreditCard': true,
          },
          {
            'cardId': 'card_5678',
            'cardName': 'KB국민 탄탄대로',
            'company': 'KB국민카드',
            'isCreditCard': true,
          }
        ];
      }
      rethrow;
    }
  }

  /// Mock endpoint for fetching transaction history of a specific card
  Future<List<Map<String, dynamic>>> fetchTransactionHistory(String cardId) async {
    try {
      final response = await _dio.get('/cards/$cardId/transactions');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['transaction_list'] ?? []);
      }
      return [];
    } on DioException catch (e) {
      // Mock Data fallback
      if (e.response?.statusCode == 404 || e.type == DioExceptionType.connectionError) {
        return [
          {
            'id': 'tx_001',
            'cardId': cardId,
            'amount': 15000,
            'category': '식비',
            'date': DateTime.now().toIso8601String(),
            'description': '스타벅스 강남점',
            'status': 'APPROVED',
          },
          {
            'id': 'tx_002',
            'cardId': cardId,
            'amount': 32000,
            'category': '교통',
            'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            'description': '카카오T 택시',
            'status': 'APPROVED',
          }
        ];
      }
      rethrow;
    }
  }
}
