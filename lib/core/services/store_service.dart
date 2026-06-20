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
      rethrow;
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

  // ==========================================
  // 🔍 البحث عن المنتجات
  // ==========================================
  Future<Response> searchProducts(String query, {int page = 1}) async {
    try {
      log("🔄 جاري البحث عن '$query' للصفحة $page...", name: "StoreService");
      final response = await _dio.get(
        '/Product/search',
        queryParameters: {'query': query, 'page': page},
      );
      log("✅ تم البحث بنجاح", name: "StoreService");
      return response;
    } on DioException catch (e) {
      log("❌ خطأ في البحث: ${e.message}", name: "StoreService - DioError");
      rethrow;
    } catch (e) {
      log("❌ خطأ غير متوقع في البحث: $e", name: "StoreService - Error");
      rethrow;
    }
  }

  Future<Response> getProductById(String productId) async {
    try {
      return await _dio.get('/Product/$productId');
    } catch (e) {
      rethrow;
    }
  }

  // ==========================================
  // 🛒 السلة (Cart)
  // ==========================================
  Future<Response> getCart() async {
    try {
      return await _dio.get('/Cart');
    } catch (e) {
      log("❌ خطأ في جلب السلة: $e", name: "StoreService");
      rethrow;
    }
  }

  Future<Response> addToCart(String productId, int quantity) async {
    try {
      final body = {
        "productID": int.tryParse(productId) ?? 0,
        "quantity": quantity,
      };

      return await _dio.post('/Cart/add', data: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateCartItem(String cartItemId, int quantity) async {
    try {
      return await _dio.put(
        '/Cart/update/$cartItemId',
        data: {"quantity": quantity},
      );
    } catch (e) {
      log("❌ خطأ في تحديث كمية السلة: $e", name: "StoreService");
      rethrow;
    }
  }

  Future<Response> removeCartItem(String cartItemId) async {
    try {
      return await _dio.delete('/Cart/remove/$cartItemId');
    } catch (e) {
      log("❌ خطأ في حذف منتج من السلة: $e", name: "StoreService");
      rethrow;
    }
  }

  Future<Response> clearCart() async {
    try {
      return await _dio.delete('/Cart/clear');
    } catch (e) {
      log("❌ خطأ في تفريغ السلة: $e", name: "StoreService");
      rethrow;
    }
  }

  // ==========================================
  // 📦 الطلبات (Orders)
  // ==========================================

  // 1. إتمام الطلب (Checkout)
  Future<Response> checkoutOrder({
    required String phone,
    required String address,
  }) async {
    try {
      log("🔄 جاري إتمام الطلب...", name: "StoreService");

      final body = {"phoneNumber": phone, "shippingAddress": address};

      return await _dio.post('/Order/checkout', data: body);
    } catch (e) {
      log("❌ خطأ في إتمام الطلب: $e", name: "StoreService");
      rethrow;
    }
  }

  // 2. جلب طلبات اليوزر (My Orders)
  Future<Response> getMyOrders({int page = 1}) async {
    try {
      log("🔄 جاري جلب طلباتي...", name: "StoreService");
      return await _dio.get(
        '/Order/my-orders',
        queryParameters: {'page': page},
      );
    } catch (e) {
      log("❌ خطأ في جلب الطلبات: $e", name: "StoreService");
      rethrow;
    }
  }

  // 3. جلب تفاصيل طلب معين (Order by ID)
  Future<Response> getOrderById(String orderId) async {
    try {
      return await _dio.get('/Order/$orderId');
    } catch (e) {
      rethrow;
    }
  }

  // 4. (للآدمن فقط) جلب كل الطلبات
  Future<Response> getAllOrders({int page = 1}) async {
    try {
      return await _dio.get('/Order/all', queryParameters: {'page': page});
    } catch (e) {
      rethrow;
    }
  }

  // 5. (للآدمن فقط) تحديث حالة الطلب
  Future<Response> updateOrderStatus(String orderId, int status) async {
    try {
      return await _dio.put('/Order/$orderId/status', data: {"status": status});
    } catch (e) {
      rethrow;
    }
  }

  // 6. (لليوزر فقط) إلغاء الطلب
  Future<Response> cancelOrder(String orderId) async {
    try {
      return await _dio.put('/Order/$orderId/cancel');
    } catch (e) {
      rethrow;
    }
  }
}
