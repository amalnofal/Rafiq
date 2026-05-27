import 'package:dio/dio.dart';
import 'dart:developer';

class StoreService {
  final Dio _dio;
  StoreService(this._dio);

  // ==========================================
  // 🛒 جلب المنتجات
  // ==========================================
  Future<Response> getProducts({int page = 1}) async {
    try {
      log("🔄 جاري جلب المنتجات للصفحة $page...", name: "StoreService");
      final response = await _dio.get(
        '/Product',
        queryParameters: {'page': page, 'pageSize': 20},
      );
      log("✅ تم جلب المنتجات بنجاح", name: "StoreService");
      return response;
    } on DioException catch (e) {
      log(
        "❌ خطأ في جلب المنتجات: ${e.message}",
        name: "StoreService - DioError",
      );
      rethrow; // بنرمي الإيرور للـ Provider عشان يتعامل معاه (مثلاً يظهر رسالة للمستخدم)
    } catch (e) {
      log("❌ خطأ غير متوقع: $e", name: "StoreService - Error");
      rethrow;
    }
  }

  // ==========================================
  // ➕ إضافة منتج (Multipart لرفع الصور)
  // ==========================================
  Future<Response> addProduct(FormData data) async {
    try {
      log("🔄 جاري إضافة منتج جديد...", name: "StoreService");
      final response = await _dio.post('/Product', data: data);
      log("✅ تم إضافة المنتج بنجاح", name: "StoreService");
      return response;
    } on DioException catch (e) {
      log(
        "❌ خطأ في إضافة المنتج: ${e.response?.data ?? e.message}",
        name: "StoreService - DioError",
      );
      rethrow;
    } catch (e) {
      log("❌ خطأ غير متوقع: $e", name: "StoreService - Error");
      rethrow;
    }
  }

  // ==========================================
  // 🗑️ حذف منتج
  // ==========================================
  Future<Response> deleteProduct(String id) async {
    try {
      log("🔄 جاري حذف المنتج رقم: $id...", name: "StoreService");
      final response = await _dio.delete('/Product/$id');
      log("✅ تم حذف المنتج بنجاح", name: "StoreService");
      return response;
    } on DioException catch (e) {
      log("❌ خطأ في حذف المنتج: ${e.message}", name: "StoreService - DioError");
      rethrow;
    } catch (e) {
      log("❌ خطأ غير متوقع: $e", name: "StoreService - Error");
      rethrow;
    }
  }

  // ==========================================
  // ✏️ تحديث منتج
  // ==========================================
  Future<Response> updateProduct(String id, FormData data) async {
    try {
      log("🔄 جاري تحديث المنتج رقم: $id...", name: "StoreService");
      final response = await _dio.put('/Product/$id', data: data);
      log("✅ تم تحديث المنتج بنجاح", name: "StoreService");
      return response;
    } on DioException catch (e) {
      log(
        "❌ خطأ في تحديث المنتج: ${e.response?.data ?? e.message}",
        name: "StoreService - DioError",
      );
      rethrow;
    } catch (e) {
      log("❌ خطأ غير متوقع: $e", name: "StoreService - Error");
      rethrow;
    }
  }
}
