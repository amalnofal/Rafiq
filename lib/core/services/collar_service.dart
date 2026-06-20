import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rafiq/features/collar/data/models/ai_diagnosis_model.dart';
import 'package:rafiq/features/collar/data/models/collar_reading_model.dart';

class CollarService {
  final Dio _dio;

  CollarService(this._dio);

  Future<CollarReadingModel?> getLatestReading(
    int petId, {
    String? after,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (after != null) {
        queryParams['after'] = after;
      }

      final response = await _dio.get(
        '/pets/$petId/latest-reading',
        queryParameters: queryParams,
      );

      log("[CollarService - Reading]: ${response.data}");

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        return CollarReadingModel.fromJson(response.data['data']);
      } else if (response.statusCode == 204) {
        // مفيش داتا جديدة
        return null;
      } else {
        throw Exception(response.data['message'] ?? 'حدث خطأ غير متوقع');
      }
    } catch (e) {
      log("[CollarService]: فشل في جلب قراءات الطوق: $e");
      rethrow;
    }
  }

  Future<AiDiagnosisModel?> getAiDiagnosis(int petId) async {
    try {
      final response = await _dio.get('/pets/$petId/prediction');

      log("[AI Diagnosis Response]: ${response.data}");

      if (response.statusCode == 200) {
        return AiDiagnosisModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        throw Exception(
          'جاري جمع البيانات... الموديل يحتاج لـ 100 قراءة على الأقل.',
        );
      }
      log("[CollarService]: فشل في جلب تشخيص الـ AI: $e");
      throw Exception('حدث خطأ أثناء جلب تشخيص الذكاء الاصطناعي');
    }
  }
}
