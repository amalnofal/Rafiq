import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rafiq/core/services/store_service.dart';
import 'package:rafiq/features/store/data/cart_model.dart';
import 'package:rafiq/features/store/data/order_model.dart';
import 'package:rafiq/features/store/data/product_model.dart';

class StoreProvider extends ChangeNotifier {
  final StoreService _storeService;
  StoreProvider(this._storeService);

  Future<List<ProductModel>> getProducts({int page = 1}) async {
    try {
      final response = await _storeService.getProducts(page: page);

      debugPrint("📦 الداتا اللي جاية من السيرفر: ${response.data}");

      List dataList = [];

      if (response.data is List) {
        dataList = response.data;
      } else if (response.data is Map) {
        final dataField = response.data['data'];
        if (dataField is List) {
          dataList = dataField;
        } else if (dataField is Map && dataField['products'] != null) {
          // 👈 السر هنا: دخلنا جوه products
          dataList = dataField['products'];
        }
      }

      return dataList
          .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, stacktrace) {
      debugPrint("❌ إيرور في قراءة المنتجات: $e");
      debugPrint(stacktrace.toString());
      return [];
    }
  }

  // دالة الإضافة
  Future<bool> addProduct(FormData data) async {
    try {
      await _storeService.addProduct(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // دالة التعديل
  Future<bool> editProduct(String id, FormData data) async {
    try {
      await _storeService.updateProduct(id, data);
      return true;
    } catch (e) {
      debugPrint("Error updating product: $e");
      return false;
    }
  }

  // دالة الحذف
  Future<bool> deleteProduct(String id) async {
    try {
      await _storeService.deleteProduct(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // 🔍 البحث
  // ==========================================
  Future<List<ProductModel>> searchProducts(
    String query, {
    int page = 1,
  }) async {
    try {
      final response = await _storeService.searchProducts(query, page: page);

      debugPrint("📦 الداتا اللي جاية من البحث: ${response.data}");

      List dataList = [];

      if (response.data is List) {
        dataList = response.data;
      } else if (response.data is Map) {
        final dataField = response.data['data'];
        if (dataField is List) {
          dataList = dataField;
        } else if (dataField is Map && dataField['products'] != null) {
          dataList = dataField['products'];
        }
      }

      return dataList
          .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, stacktrace) {
      debugPrint("❌ إيرور في بحث المنتجات: $e");
      debugPrint(stacktrace.toString());
      return [];
    }
  }

  // ==========================================
  // 🛒 إدارة حالة السلة (Cart State)
  // ==========================================
  CartModel? _cart;
  bool _isCartLoading = false;

  CartModel? get cart => _cart;
  bool get isCartLoading => _isCartLoading;

  // جلب السلة
  Future<void> fetchCart() async {
    _isCartLoading = true;
    notifyListeners();
    try {
      final response = await _storeService.getCart();
      final data = response.data['data'] ?? response.data;
      _cart = CartModel.fromMap(data);
    } catch (e) {
      debugPrint("❌ إيرور في قراءة السلة: $e");
      _cart = null;
    } finally {
      _isCartLoading = false;
      notifyListeners();
    }
  }

  // إضافة منتج للسلة
  Future<bool> addToCart(String productId, int quantity) async {
    try {
      await _storeService.addToCart(productId, quantity);
      await fetchCart(); // تحديث السلة تلقائياً بعد الإضافة
      return true;
    } catch (e) {
      return false;
    }
  }

  // تحديث كمية منتج في السلة
  Future<bool> updateCartQuantity(String cartItemId, int quantity) async {
    try {
      await _storeService.updateCartItem(cartItemId, quantity);
      await fetchCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  // حذف منتج من السلة
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      await _storeService.removeCartItem(cartItemId);
      await fetchCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  // تفريغ السلة بالكامل
  Future<bool> clearCart() async {
    try {
      await _storeService.clearCart();
      _cart = null;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // جلب تفاصيل منتج واحد
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final response = await _storeService.getProductById(productId);
      final data = response.data['data'] ?? response.data;

      return ProductModel.fromMap(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint("❌ إيرور في جلب تفاصيل المنتج: $e");
      return null;
    }
  }

  // ==========================================
  // 📦 إدارة الطلبات (Orders State)
  // ==========================================

  // تحويل السلة لطلب
  Future<bool> checkout({
    required String phone,
    required String address,
  }) async {
    try {
      await _storeService.checkoutOrder(phone: phone, address: address);
      _cart = null;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("❌ إيرور في الكاش أوت: $e");
      return false;
    }
  }

  // جلب طلباتي
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _storeService.getMyOrders();
      final data = response.data['data']?['orders'] ?? [];

      if (data is List) {
        return data
            .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ إيرور في جلب الطلبات: $e");
      return [];
    }
  }

  // ==========================================
  // جلب كل الطلبات (للأدمن)
  // ==========================================
  Future<List<OrderModel>> getAllOrders({int page = 1}) async {
    try {
      final response = await _storeService.getAllOrders(page: page);
      final data = response.data['data']?['orders'] ?? [];

      if (data is List) {
        return data
            .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ إيرور في جلب كل الطلبات للأدمن: $e");
      return [];
    }
  }

  // ==========================================
  // (للآدمن) تحديث حالة الطلب (قبول الطلب)
  // ==========================================
  Future<bool> updateOrderStatus(String orderId, int status) async {
    try {
      await _storeService.updateOrderStatus(orderId, status);
      return true;
    } catch (e) {
      debugPrint("❌ إيرور في تحديث حالة الطلب: $e");
      return false;
    }
  }

  // ==========================================
  // (لليوزر) إلغاء الطلب الخاص به
  // ==========================================
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _storeService.cancelOrder(orderId);
      return true;
    } catch (e) {
      debugPrint("❌ إيرور في إلغاء الطلب: $e");
      return false;
    }
  }
}
