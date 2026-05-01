import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class PetService {
  final Dio _dio;

  PetService(this._dio);

  // ==========================================
  // 1. إضافة حيوان أليف (بيانات نصية فقط)
  // ==========================================
  Future<Response> addPet(Map<String, dynamic> petData) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(petData['dob']);

      Map<String, dynamic> dataMap = {
        "petName": petData['name'],
        "type": petData['type'],
        "gender": petData['gender'],
        "breed": petData['breed'],
        "dateOfBirth": formattedDate,
        "weight": petData['weight'],
        "color": petData['color'] ?? "",
      };

      FormData formData = FormData.fromMap(dataMap);
      final response = await _dio.post('/Pet/add-pet', data: formData);

      log("[PetService]: تم إرسال طلب إضافة الحيوان بنجاح.");
      return response;
    } catch (e) {
      log("[PetService]: فشل في إرسال طلب إضافة الحيوان: $e");
      rethrow;
    }
  }

  // ==========================================
  // 2. جلب بيانات الحيوان الكاملة للتعديل
  // ==========================================
  Future<Response> getPetForEdit(String petId) async {
    try {
      final response = await _dio.get('/Pet/edit-view/$petId');
      log("[PetService]: تم جلب بيانات الحيوان للتعديل بنجاح.");
      return response;
    } catch (e) {
      log("[PetService]: فشل جلب بيانات الحيوان للتعديل: $e");
      rethrow;
    }
  }

  // ==========================================
  // 3. تعديل بيانات حيوان أليف
  // ==========================================
  Future<Response> updatePet(String petId, Map<String, dynamic> petData) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(petData['dob']);

      Map<String, dynamic> dataMap = {
        "petName": petData['name'],
        "type": petData['type'],
        "gender": petData['gender'],
        "breed": petData['breed'],
        "dateOfBirth": formattedDate,
        "weight": petData['weight'],
        "color": petData['color'] ?? "",
      };

      FormData formData = FormData.fromMap(dataMap);
      final response = await _dio.put('/Pet/update-pet/$petId', data: formData);

      log("[PetService]: تم إرسال طلب تعديل بيانات الحيوان بنجاح.");
      return response;
    } catch (e) {
      log("[PetService]: فشل في إرسال طلب تعديل الحيوان: $e");
      rethrow;
    }
  }

  // ==========================================
  // 4. مسح حيوان أليف
  // ==========================================
  Future<void> deletePet(int petId) async {
    try {
      final response = await _dio.delete('/Pet/delete-pet/$petId');

      if (response.statusCode == 200) {
        log("[PetService]: تم حذف الحيوان من الخادم بنجاح.");
      }
    } catch (e) {
      if (e is DioException) {
        log(
          "[PetService]: خطأ أثناء حذف الحيوان من الخادم: ${e.response?.data}",
        );
      } else {
        log("[PetService]: فشل حذف الحيوان: $e");
      }
      rethrow;
    }
  }

  // ==========================================
  // جلب بروفايل الحيوان الشامل (بيانات + مواعيد)
  // ==========================================
  Future<Response> getPetProfile(String petId) async {
    try {
      final response = await _dio.get('/Pet/$petId/profile');
      log("[PetService]: تم جلب بروفايل الحيوان بنجاح.");
      return response;
    } catch (e) {
      log("[PetService]: فشل جلب بروفايل الحيوان: $e");
      rethrow;
    }
  }
}
