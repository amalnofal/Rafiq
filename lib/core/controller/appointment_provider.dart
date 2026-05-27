import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/services/appointment_service.dart';
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  List<dynamic> _doctorClinics = [];
  List<dynamic> get doctorClinics => _doctorClinics;

  List<String> _availableSlots = [];
  List<String> get availableSlots => _availableSlots;

  bool _isLoadingSlots = false;
  bool get isLoadingSlots => _isLoadingSlots;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetched = false;
  bool get isFetched => _isFetched;

  List<AppointmentModel> get pendingAppointments =>
      _appointments.where((a) => a.status.toLowerCase() == 'pending').toList();

  List<AppointmentModel> get confirmedAppointments => _appointments
      .where((a) => a.status.toLowerCase() == 'confirmed')
      .toList();

  List<AppointmentModel> get completedAppointments => _appointments
      .where((a) => a.status.toLowerCase() == 'completed')
      .toList();

  // دالة لحفظ المواعيد محلياً
  Future<void> _saveAppointmentsToCache(
    List<AppointmentModel> appointments,
  ) async {
    final encoded = jsonEncode(appointments.map((a) => a.toJson()).toList());
    await CacheHelper.saveData(key: 'cached_appointments', value: encoded);
  }

  // دالة لجلب المواعيد من الكاش
  Future<void> _loadAppointmentsFromCache() async {
    final cachedData = CacheHelper.getData(key: 'cached_appointments');
    if (cachedData != null) {
      try {
        final List decoded = jsonDecode(cachedData);
        _appointments = decoded
            .map((e) => AppointmentModel.fromJson(e))
            .toList();
        notifyListeners();
      } catch (e) {
        log("❌ خطأ في تحميل كاش المواعيد: $e");
      }
    }
  }

  // تحديث دالة fetchMyAppointments
  Future<void> fetchMyAppointments() async {
    // 1. تحميل الكاش أولاً (سيظهر البيانات فوراً)
    await _loadAppointmentsFromCache();

    // لا نغير _isLoading = true إذا كان لدينا بيانات في الكاش بالفعل لتجنب اختفاء البيانات
    if (_appointments.isEmpty) _isLoading = true;
    notifyListeners();

    try {
      final response = await getIt<AppointmentService>().getMyAppointments();
      final dynamic responseData = response.data['data'] ?? response.data;

      if (responseData is List) {
        _appointments = responseData
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
        _isFetched = true;
        // 2. تحديث الكاش بالبيانات الجديدة
        await _saveAppointmentsToCache(_appointments);
      }
    } catch (e) {
      log("❌ [AppointmentProvider]: فشل التحديث من السيرفر - $e");
      // هنا لا نمسح البيانات، المستخدم سيظل يرى بيانات الكاش
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. إضافة موعد خاص
  Future<void> addPrivateAppointment(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await getIt<AppointmentService>().addPrivateAppointment(data);
      log("[AppointmentProvider]: Private appointment added successfully.");

      await fetchMyAppointments();
    } catch (e) {
      log("[AppointmentProvider]: Failed to add appointment - $e");
      throw Exception("failed_to_add_appointment");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 3. دالة إنهاء الموعد
  // ==========================================
  Future<bool> completeAppointment(int appointmentId) async {
    try {
      await getIt<AppointmentService>().completeAppointment(appointmentId);
      await fetchMyAppointments();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // 4. حذف موعد
  // ==========================================
  Future<bool> deleteAppointment(int appointmentId) async {
    try {
      await getIt<AppointmentService>().deleteAppointment(appointmentId);
      _appointments.removeWhere(
        (a) => a.id.toString() == appointmentId.toString(),
      );
      notifyListeners();
      log("[AppointmentProvider]: Appointment deleted successfully.");
      return true;
    } catch (e) {
      log("[AppointmentProvider]: Delete failed - $e");
      return false;
    }
  }

  // ==========================================
  // تحديث موعد عيادة
  // ==========================================
  Future<void> updateAppointment(
    int appointmentId,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await getIt<AppointmentService>().updateAppointment(appointmentId, data);
      log("[AppointmentProvider]: Appointment updated successfully.");
      await fetchMyAppointments();
    } catch (e) {
      log("[AppointmentProvider]: Failed to update appointment - $e");
      throw Exception("failed_to_update_appointment");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDoctorClinics() async {
    try {
      final response = await getIt<AppointmentService>().getDoctorClinics();
      _doctorClinics = response.data['data'] ?? response.data;
      notifyListeners();
    } catch (e) {
      log("[AppointmentProvider]: Failed to fetch clinics - $e");
    }
  }

  // دالة الحجز للدكتور
  Future<void> createDoctorClinicAppointment(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await getIt<AppointmentService>().addDoctorClinicAppointment(data);
      await fetchMyAppointments();
    } catch (e) {
      throw Exception("failed_to_add_clinic_appointment");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ==========================================
  // حجز موعد في عيادة (مع دعم الحجز الذاتي) 🚨
  // ==========================================
  Future<void> bookClinicAppointment(
    Map<String, dynamic> data, {
    bool isSelfBooking = false,
  }) async {
    try {
      // 1. استخراج معرف العيادة من الداتا
      final clinicId = data['ClinicId'] ?? data['clinicId'];

      // 2. التأكد هل دي عيادتي؟
      bool isMyClinic = isSelfBooking;
      if (!isMyClinic && clinicId != null) {
        if (_doctorClinics.isEmpty) {
          await fetchDoctorClinics();
        }

        isMyClinic = _doctorClinics.any((c) {
          final id = c is Map ? (c['id'] ?? c['clinicId']) : (c.id ?? 0);
          return id.toString() == clinicId.toString();
        });
      }

      // 3. تعديل الداتا قبل ما تروح للباك إند
      if (isMyClinic) {
        log(
          "✅ [AppointmentProvider]: Self-Booking Detected! Modifying status to Confirmed.",
        );
        data['Status'] = 2;
        data['status'] = 2;
        data['StatusLabel'] = 'Confirmed';
      }

      // 4. إرسال الطلب
      final response = await getIt<AppointmentService>().bookClinicAppointment(
        data,
      );

      // 5. حيلة برمجية (Fallback): لو الباك إند تجاهل التعديل وخلاه Pending
      // نعمل له Approve تلقائي فوراً
      if (isMyClinic) {
        try {
          final responseData = response.data is Map
              ? response.data['data'] ?? response.data
              : null;
          if (responseData != null) {
            final newId = responseData['appointmentId'] ?? responseData['id'];
            if (newId != null) {
              int parsedId = newId is int ? newId : int.parse(newId.toString());
              await getIt<AppointmentService>().approveAppointment(parsedId);
              log(
                "✅ [AppointmentProvider]: Auto-Approved the self-booked appointment.",
              );
            }
          }
        } catch (e) {
          log("⚠️ [AppointmentProvider]: Auto-Approve skipped. ($e)");
        }
      }

      // 6. تحديث الواجهة
      await fetchMyAppointments();
    } catch (e) {
      log("❌ [AppointmentProvider]: Error booking clinic appointment: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب الأوقات المتاحة للحجز بناءً على التاريخ
  // ==========================================
  Future<void> fetchAvailableSlots(int clinicId, String date) async {
    _isLoadingSlots = true;
    _availableSlots = [];
    notifyListeners();

    try {
      final response = await getIt<AppointmentService>().getAvailableSlots(
        clinicId,
        date,
      );

      dynamic responseData;
      if (response.data is Map && (response.data as Map).containsKey('data')) {
        responseData = response.data['data'];
      } else {
        responseData = response.data;
      }

      if (responseData is List) {
        _availableSlots = responseData.map((e) {
          if (e is Map && e.containsKey('startTime')) {
            return e['startTime'].toString();
          }
          return e.toString();
        }).toList();
      }
      log(
        "[AppointmentProvider]: Fetched ${_availableSlots.length} available slots for $date.",
      );
    } on DioException catch (e) {
      log("🚨 [Backend Error Data]: ${e.response?.data}");
      log("🚨 [Backend Status Code]: ${e.response?.statusCode}");
      log("❌ [AppointmentProvider]: Failed to fetch slots - $e");
    } catch (e) {
      log("❌ [AppointmentProvider]: Failed to fetch slots - $e");
    } finally {
      _isLoadingSlots = false;
      notifyListeners();
    }
  }

  // ==========================================
  // قبول الموعد (للدكتور)
  // ==========================================
  Future<bool> approveClinicAppointment(int appointmentId) async {
    try {
      await getIt<AppointmentService>().approveAppointment(appointmentId);
      await fetchMyAppointments();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // رفض الموعد (للدكتور)
  // ==========================================
  Future<bool> rejectClinicAppointment(int appointmentId) async {
    try {
      if (appointmentId <= 0) return false;

      await getIt<AppointmentService>().rejectAppointment(appointmentId);

      await fetchMyAppointments();
      return true;
    } catch (e) {
      log("❌ [AppointmentProvider]: Reject failed for ID $appointmentId - $e");
      return false;
    }
  }
}
