import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentApiServiceProvider = Provider<PaymentApiService>((ref) {
  return PaymentApiService();
});

class PaymentApiService {
  final Dio _dio;

  PaymentApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://sandbox.example.com/api', // 샌드박스 URL 예시
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  /// 결제 승인 시뮬레이션
  /// 성공 시 true, 실패(에러) 시 예외 발생
  Future<bool> processPayment({
    required String cardId,
    required double amount,
    required String description,
    required String authToken,
  }) async {
    try {
      // 샌드박스 환경에서는 임의의 딜레이를 주어 네트워크 통신을 시뮬레이션
      await Future.delayed(const Duration(seconds: 1));

      // Mock 성공/실패 로직: 금액이 1,000,000 이상이면 한도 초과 에러 시뮬레이션
      if (amount >= 1000000) {
        throw DioException(
          requestOptions: RequestOptions(path: '/payments'),
          response: Response(
            requestOptions: RequestOptions(path: '/payments'),
            statusCode: 403,
            data: {'message': '한도 초과 (Mock)'},
          ),
          type: DioExceptionType.badResponse,
        );
      }

      /* 실제 API 연동 시 사용할 코드 형태
      final response = await _dio.post(
        '/payments',
        data: {
          'cardId': cardId,
          'amount': amount,
          'description': description,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('결제 실패: ${response.data}');
      }
      */

      return true; // 성공 시뮬레이션
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('한도 초과 등 결제 거절: ${e.response?.data['message']}');
      } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw Exception('네트워크 연결 지연');
      }
      throw Exception('결제 오류: ${e.message}');
    } catch (e) {
      throw Exception('알 수 없는 오류 발생: $e');
    }
  }
}
