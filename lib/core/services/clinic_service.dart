import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class ClinicService {
  final Dio _dio;

  ClinicService(this._dio);

  // ==========================================
  // إضافة عيادة جديدة
  // ==========================================
  Future<Response> addClinic(Map<String, dynamic> data) async {
    try {
      FormData formData = FormData.fromMap(data);
      final response = await _dio.post('/Clinic/add-clinic', data: formData);
      log("[ClinicService]: تم إضافة العيادة بنجاح.");
      return response;
    } catch (e) {
      log("[ClinicService]: فشل إضافة العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب بيانات العيادة الكاملة للتعديل
  // ==========================================
  Future<Response> getClinicForEdit(String id) async {
    try {
      final response = await _dio.get('/Clinic/edit-view/$id');
      log("[ClinicService]: تم جلب بيانات العيادة للتعديل بنجاح.");
      return response;
    } catch (e) {
      log("[ClinicService]: فشل جلب بيانات العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // تعديل عيادة
  // ==========================================
  Future<Response> updateClinic(String id, Map<String, dynamic> data) async {
    try {
      FormData formData = FormData.fromMap(data);
      final response = await _dio.put(
        '/Clinic/update-clinic/$id',
        data: formData,
      );
      log("[ClinicService]: تم تعديل العيادة بنجاح.");
      return response;
    } catch (e) {
      log("[ClinicService]: فشل تعديل العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // رفع صورة العيادة
  // ==========================================
  Future<void> uploadClinicPhoto(String clinicId, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      await _dio.post('/Clinic/$clinicId/photo', data: formData);
      log("[ClinicService]: تم رفع صورة العيادة بنجاح.");
    } catch (e) {
      log("[ClinicService]: فشل رفع صورة العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // حذف عيادة
  // ==========================================
  Future<Response> deleteClinic(String id) async {
    try {
      final response = await _dio.delete('/Clinic/delete-clinic/$id');
      log("[ClinicService]: تم حذف العيادة بنجاح.");
      return response;
    } catch (e) {
      log("[ClinicService]: فشل حذف العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب تفاصيل العيادة بالكامل (مع التقييمات)
  // ==========================================
  Future<Response> getClinicDetails(int clinicId) async {
    try {
      final response = await _dio.get('/Clinic/$clinicId');
      log("[ClinicService]: تم جلب تفاصيل العيادة بنجاح.");
      return response;
    } catch (e) {
      log("[ClinicService]: فشل جلب تفاصيل العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب كل العيادات للزوار
  // ==========================================
  Future<Response> getAllClinics({int skip = 0, int take = 10}) async {
    try {
      final response = await _dio.get(
        '/Clinic/all',
        queryParameters: {'skip': skip, 'take': take},
      );
      return response;
    } catch (e) {
      log("[ClinicService]: فشل جلب كل العيادات: $e");
      rethrow;
    }
  }

  // ==========================================
  // إضافة تقييم لعيادة
  // =========================================
  Future<Response> addReview(Map<String, dynamic> data) async {
    try {
      FormData formData = FormData.fromMap(data);

      final response = await _dio.post('/Review/add', data: formData);
      log("[ClinicService]: تم إرسال التقييم بنجاح.");
      return response;
    } catch (e) {
      log("[ClinicService]: فشل إرسال التقييم: $e");
      rethrow;
    }
  }

  // ==========================================
  // تعديل تقييم
  // ==========================================
  Future<Response> updateReview(int reviewId, Map<String, dynamic> data) async {
    try {
      FormData formData = FormData.fromMap(data);
      final response = await _dio.put(
        '/Review/update/$reviewId',
        data: formData,
      );
      return response;
    } catch (e) {
      log("[ClinicService]: فشل تعديل التقييم: $e");
      rethrow;
    }
  }

  // ==========================================
  // حذف تقييم
  // ==========================================
  Future<Response> deleteReview(int reviewId) async {
    try {
      final response = await _dio.delete('/Review/delete/$reviewId');
      return response;
    } catch (e) {
      log("[ClinicService]: فشل حذف التقييم: $e");
      rethrow;
    }
  }

  // ==========================================
  // البحث عن عيادات بالاسم أو العنوان
  // ==========================================
  Future<Response> searchClinics(
    String keyword, {
    int skip = 1,
    int take = 50,
  }) async {
    try {
      final response = await _dio.get(
        '/Clinic/search',
        queryParameters: {'keyword': keyword, 'skip': skip, 'take': take},
      );
      return response;
    } catch (e) {
      log("[ClinicService]: فشل البحث عن عيادات: $e");
      rethrow;
    }
  }
}
