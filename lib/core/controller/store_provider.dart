import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rafiq/core/services/store_service.dart';
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
}
