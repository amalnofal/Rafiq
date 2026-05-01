import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/services/pet_service.dart';
import 'package:rafiq/features/profile/data/models/pet_model.dart';

class PetProvider extends ChangeNotifier {
  final List<PetModel> _pets = [];
  List<PetModel> get pets => _pets;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAddingPet = false;
  bool get isAddingPet => _isAddingPet;

  Map<String, dynamic>? _currentPetProfile;
  Map<String, dynamic>? get currentPetProfile => _currentPetProfile;

  List<dynamic> get upcomingAppointments =>
      _currentPetProfile?['upcomingAppointments'] ?? [];
  List<dynamic> get medicalRecords =>
      _currentPetProfile?['medicalRecord'] ?? [];
  // ==========================================
  // 1. استقبال وتحديث لستة الحيوانات
  // ==========================================
  void setPetsFromProfile(dynamic responseData) {
    if (responseData == null) return;

    List<dynamic>? petsList;

    if (responseData is List) {
      petsList = responseData;
    } else if (responseData is Map<String, dynamic>) {
      if (responseData['pets'] != null) {
        petsList = responseData['pets'];
      } else if (responseData['petOwnerDetails'] != null &&
          responseData['petOwnerDetails']['pets'] != null) {
        petsList = responseData['petOwnerDetails']['pets'];
      } else if (responseData['doctorDetails'] != null &&
          responseData['doctorDetails']['pets'] != null) {
        petsList = responseData['doctorDetails']['pets'];
      }
    }

    if (petsList != null) {
      _pets.clear();
      for (var petJson in petsList.reversed) {
        _pets.add(PetModel.fromJson(petJson));
      }
      log("[PetProvider]: Successfully loaded ${_pets.length} pets.");
    } else {
      _pets.clear();
      log("[PetProvider]: Warning - No pets list found in response.");
    }

    notifyListeners();
  }

  // ==========================================
  // جلب حيوان للتعديل (بترجع PetModel)
  // ==========================================
  Future<PetModel> fetchPetForEdit(String petId) async {
    try {
      final response = await getIt<PetService>().getPetForEdit(petId);

      final data = response.data['data'] ?? response.data;

      return PetModel.fromJson(data);
    } catch (e) {
      log("[PetProvider]: فشل جلب بيانات الحيوان للتعديل: $e");
      throw Exception("fetch_pet_failed");
    }
  }

  // ==========================================
  // 2. طلب تحديث بيانات الحيوانات
  // ==========================================
  Future<void> fetchMyPets(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserData();

      log("[PetProvider]: تم سحب بيانات الحيوانات من ريكويست البروفايل بنجاح.");
    } catch (e) {
      log("[PetProvider]: فشل طلب التحديث: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 3. إضافة حيوان أليف (نصوص ثم صورة)
  // ==========================================
  Future<void> addPet(
    BuildContext context,
    Map<String, dynamic> petData,
    File? imageFile,
  ) async {
    _isAddingPet = true;
    notifyListeners();

    try {
      final response = await getIt<PetService>().addPet(petData);

      String? newPetId;
      if (response.data != null) {
        newPetId = response.data['data']?.toString();
      }

      if (imageFile != null && newPetId != null) {
        await uploadPetPhoto(newPetId, imageFile);
      }

      if (context.mounted) {
        await fetchMyPets(context);
      }

      log("[PetProvider]: تم إضافة الحيوان بنجاح.");
    } catch (e, stackTrace) {
      if (e is DioException) {
        log("🚨 [Backend Error] Server response: ${e.response?.data}");
        if (e.response?.statusCode == 400) throw Exception("validationError");
        if (e.response?.statusCode == 401) throw Exception("sessionExpired");
        if (e.response?.statusCode == 500) throw Exception("serverError");
      }

      log("🚨 [Runtime Error] Exception details: $e");
      log("🚨 [Stack Trace] Execution path: $stackTrace");

      throw Exception("unexpectedError");
    } finally {
      _isAddingPet = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 4. رفع أو تحديث صورة الحيوان
  // ==========================================
  Future<void> uploadPetPhoto(String petId, File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      await getIt<Dio>().post('/Pet/$petId/photo', data: formData);
      log("[PetProvider]: تم تحديث صورة الحيوان بنجاح على السيرفر.");
    } catch (e) {
      log("[PetProvider]: فشل تحديث الصورة: $e");
      throw Exception("photo_upload_failed");
    }
  }

  // ==========================================
  // 5. تعديل بيانات الحيوان
  // ==========================================
  Future<void> updatePetInfo(
    BuildContext context,
    String petId,
    Map<String, dynamic> updatedData,
  ) async {
    _isAddingPet = true;
    notifyListeners();

    try {
      await getIt<PetService>().updatePet(petId, updatedData);

      if (context.mounted) {
        await fetchMyPets(context);
      }

      log("[PetProvider]: تم تعديل بيانات الحيوان بنجاح.");
    } catch (e) {
      if (e is DioException) {
        log("[PetProvider]: Dio Error Status: ${e.response?.statusCode}");
        log("[PetProvider]: Dio Error Data: ${e.response?.data}");
      }
      log("[PetProvider]: فشل التعديل: $e");
      throw Exception("failed_to_update");
    } finally {
      _isAddingPet = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 6. مسح الحيوان
  // ==========================================
  Future<void> deletePet(String petId) async {
    int? parsedId = int.tryParse(petId.trim());
    if (parsedId == null) throw Exception("invalid_id");

    try {
      await getIt<PetService>()
          .deletePet(parsedId)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw Exception("timeout");
            },
          );

      _pets.removeWhere((p) => p.id == petId);
      notifyListeners();

      // log("[PetProvider]: تم حذف الحيوان من السيرفر بنجاح.");
    } catch (e) {
      log("[PetProvider]: فشل الحذف: $e");
      throw Exception("failed_to_delete");
    }
  }

  // ==========================================
  // 7. عرض بروفايل الحيوان
  // ==========================================
  Future<void> fetchPetProfile(String petId) async {
    final currentId =
        _currentPetProfile?['id']?.toString() ??
        _currentPetProfile?['petId']?.toString();

    if (currentId != petId.toString()) {
      _currentPetProfile = null;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final response = await getIt<PetService>().getPetProfile(petId);

      // بنحفظ الداتا اللي راجعة
      _currentPetProfile = response.data['data'] ?? response.data;
      log("[PetProvider]: تم جلب بروفايل الحيوان الشامل بنجاح.");
      log("[PetProvider]: الداتا الراجعة: $_currentPetProfile");
    } catch (e) {
      log("[PetProvider]: فشل جلب بروفايل الحيوان: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
