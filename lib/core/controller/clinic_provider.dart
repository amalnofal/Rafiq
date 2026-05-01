import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/services/clinic_service.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';

class ClinicProvider extends ChangeNotifier {
  final ClinicService _clinicService;
  final List<ClinicModel> _clinics = [];

  final Map<String, File> _localClinicImages = {};
  File? getLocalClinicImage(String clinicId) => _localClinicImages[clinicId];

  ClinicProvider(this._clinicService);

  List<ClinicModel> get clinics => _clinics;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ClinicModel? _currentClinicDetails;
  ClinicModel? get currentClinicDetails => _currentClinicDetails;

  // القوائم الخاصة بالزوار
  List<ClinicModel> _allClinics = [];
  List<ClinicModel> get allClinics => _allClinics;

  // ==========================================
  // 1. استقبال وتحديث لستة العيادات من البروفايل
  // ==========================================
  void setClinicsFromProfile(dynamic responseData) {
    if (responseData == null) {
      _localClinicImages.clear();
      _clinics.clear();
      notifyListeners();
      return;
    }
    List<dynamic>? clinicsList;

    if (responseData is Map<String, dynamic>) {
      if (responseData['clinics'] != null) {
        clinicsList = responseData['clinics'];
      } else if (responseData['doctorDetails'] != null &&
          responseData['doctorDetails']['clinics'] != null) {
        clinicsList = responseData['doctorDetails']['clinics'];
      } else if (responseData['data'] != null &&
          responseData['data']['doctorDetails'] != null &&
          responseData['data']['doctorDetails']['clinics'] != null) {
        clinicsList = responseData['data']['doctorDetails']['clinics'];
      }
    }

    if (clinicsList != null) {
      _clinics.clear();
      for (var clinicJson in clinicsList.reversed) {
        try {
          _clinics.add(ClinicModel.fromJson(clinicJson));
        } catch (e) {
          log("[ClinicProvider]: ❌ Error in Clinic: $e");
        }
      }
      log("[ClinicProvider]: Successfully loaded ${_clinics.length} clinics.");
    } else {
      _clinics.clear();
      log("[ClinicProvider]: Warning - No clinics list found in profile data.");
    }

    notifyListeners();
  }

  // ==========================================
  // 2. طلب تحديث بيانات العيادات
  // ==========================================
  Future<void> fetchMyClinics(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserData();
      log("[ClinicProvider]: Clinics updated from profile request.");
    } catch (e) {
      log("[ClinicProvider]: Failed to fetch clinics: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 3. إضافة عيادة جديدة للسيرفر
  // ==========================================
  Future<void> addClinicToServer(
    BuildContext context,
    Map<String, dynamic> clinicData,
  ) async {
    try {
      final newClinic = ClinicModel(
        id: '',
        name: clinicData['name'],
        specialization: clinicData['specialization'],
        description: clinicData['description'],
        address: clinicData['address'],
        phone: clinicData['phone'],
        workingHours: clinicData['workingHours'],
        doctorName: null,
        doctorProfilePhotoUrl: null,
        doctorSpecialization: null,
        doctorSubSpecialization: null,
      );

      await _clinicService.addClinic(newClinic.toJson());

      if (context.mounted) {
        await fetchMyClinics(context);
      }
      log("[ClinicProvider]: Clinic added successfully.");
    } catch (e) {
      log("[ClinicProvider]: Error adding clinic: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب عيادة للتعديل
  // ==========================================
  Future<ClinicModel> fetchClinicForEdit(String clinicId) async {
    try {
      final response = await _clinicService.getClinicForEdit(clinicId);
      final data = response.data['data'] ?? response.data;
      return ClinicModel.fromJson(data);
    } catch (e) {
      log("[ClinicProvider]: فشل جلب بيانات العيادة للتعديل: $e");
      throw Exception("fetch_clinic_failed");
    }
  }

  // ==========================================
  // 4. تعديل عيادة موجودة
  // ==========================================
  Future<void> updateClinicInServer(
    BuildContext context,
    String id,
    Map<String, dynamic> clinicData,
  ) async {
    try {
      final updatedModel = ClinicModel(
        id: id,
        name: clinicData['name'],
        specialization: clinicData['specialization'],
        description: clinicData['description'],
        address: clinicData['address'],
        phone: clinicData['phone'],
        workingHours: clinicData['workingHours'],
        doctorName: null,
        doctorProfilePhotoUrl: null,
        doctorSpecialization: null,
        doctorSubSpecialization: null,
      );

      await _clinicService.updateClinic(id, updatedModel.toJson());

      if (context.mounted) {
        await fetchMyClinics(context);
      }
      log("[ClinicProvider]: Clinic updated successfully.");
    } catch (e) {
      log("[ClinicProvider]: Error updating clinic: $e");
      rethrow;
    }
  }

  // ==========================================
  // 5. حذف عيادة
  // ==========================================
  Future<void> deleteClinicFromServer(BuildContext context, String id) async {
    try {
      await _clinicService.deleteClinic(id);

      _clinics.removeWhere((c) => c.id == id);
      _localClinicImages.remove(id);
      notifyListeners();

      log("[ClinicProvider]: Clinic deleted successfully.");
    } catch (e) {
      log("[ClinicProvider]: Error deleting clinic: $e");
      rethrow;
    }
  }

  // ==========================================
  // 6. رفع صورة العيادة
  // ==========================================
  Future<void> uploadClinicPhoto(
    BuildContext context,
    String clinicId,
    File file,
  ) async {
    try {
      _localClinicImages[clinicId] = file;
      notifyListeners();

      await _clinicService.uploadClinicPhoto(clinicId, file);

      if (context.mounted) {
        await fetchMyClinics(context);
      }
      log("[ClinicProvider]: تم تحديث صورة العيادة بنجاح.");
    } catch (e) {
      _localClinicImages.remove(clinicId);
      notifyListeners();
      log("[ClinicProvider]: Error uploading clinic photo: $e");
      rethrow;
    }
  }

  // ==========================================
  // 7. جلب تفاصيل العيادة لعرض البروفايل الخاص بها
  // ==========================================
  Future<void> fetchClinicDetails(int clinicId) async {
    if (_currentClinicDetails?.id != clinicId.toString()) {
      _currentClinicDetails = null;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final response = await _clinicService.getClinicDetails(clinicId);
      final data = response.data['data'] ?? response.data;
      _currentClinicDetails = ClinicModel.fromJson(data);
    } catch (e) {
      log("❌ [ClinicProvider]: فشل جلب التفاصيل: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 8. جلب كل العيادات للتصفح
  // ==========================================
  Future<void> fetchAllClinics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _clinicService.getAllClinics(skip: 0, take: 50);

      final List data = response.data['data'] ?? response.data ?? [];
      _allClinics = data.map((json) => ClinicModel.fromJson(json)).toList();
    } catch (e) {
      log("[ClinicProvider]: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 9. إضافة تقييم للعيادة
  // ==========================================
  Future<bool> submitReview(int clinicId, double rating, String comment) async {
    try {
      await _clinicService.addReview({
        "ClinicID": clinicId,
        "Rating": rating.toInt(),
        "ReviewText": comment,
      });

      await fetchClinicDetails(clinicId);
      return true;
    } catch (e) {
      log("[ClinicProvider]: فشل إضافة التقييم: $e");
      if (e is DioException) {
        log("⚠️ سبب الـ 400 من الباك إند: ${e.response?.data}");
      }
      return false;
    }
  }

  Future<bool> updateReview(
    int reviewId,
    int clinicId,
    double rating,
    String comment,
  ) async {
    try {
      await _clinicService.updateReview(reviewId, {
        "Rating": rating.toInt(),
        "ReviewText": comment,
      });
      // بعد التعديل بنجيب البيانات الجديدة عشان الصفحة تتحدث
      await fetchClinicDetails(clinicId);
      return true;
    } catch (e) {
      log("❌ [ClinicProvider]: فشل تعديل التقييم: $e");
      return false;
    }
  }

  // 5. حذف تقييم
  Future<bool> deleteReview(int reviewId, int clinicId) async {
    try {
      await _clinicService.deleteReview(reviewId);
      // بعد الحذف بنجيب البيانات الجديدة عشان الصفحة تتحدث
      await fetchClinicDetails(clinicId);
      return true;
    } catch (e) {
      log("❌ [ClinicProvider]: فشل حذف التقييم: $e");
      return false;
    }
  }

  // ==========================================
  // 10. البحث عن العيادات
  // ==========================================
 // متغيرات البحث الجديدة
  List<ClinicModel> _searchResults = [];
  List<ClinicModel> get searchResults => _searchResults;

  bool _isSearchLoading = false;
  bool get isSearchLoading => _isSearchLoading;

  // دالة البحث المعدلة
  Future<void> searchClinics(String keyword) async {
    if (keyword.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearchLoading = true;
    notifyListeners();

    try {
      final response = await _clinicService.searchClinics(keyword, skip: 1, take: 50);
      final List data = response.data['data'] ?? response.data ?? [];
      
      _searchResults = data.map((json) => ClinicModel.fromJson(json)).toList();
    } catch (e) {
      log("[ClinicProvider]: فشل البحث: $e");
      _searchResults = [];
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  // دالة لتنظيف البحث لما نخرج من الشاشة
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
