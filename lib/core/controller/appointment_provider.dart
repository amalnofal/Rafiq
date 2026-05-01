import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/services/appointment_service.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  List<dynamic> _doctorClinics = [];
  List<dynamic> get doctorClinics => _doctorClinics;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetched = false;
  bool get isFetched => _isFetched;

  // فلاتر جاهزة للشاشة بتاعتك
  List<AppointmentModel> get pendingAppointments =>
      _appointments.where((a) => a.status.toLowerCase() == 'pending').toList();

  List<AppointmentModel> get confirmedAppointments => _appointments
      .where((a) => a.status.toLowerCase() == 'confirmed')
      .toList();

  List<AppointmentModel> get completedAppointments => _appointments
      .where((a) => a.status.toLowerCase() == 'completed')
      .toList();

  // ==========================================
  // 1. جلب المواعيد
  // ==========================================
  Future<void> fetchMyAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await getIt<AppointmentService>().getMyAppointments();

      // تفريغ الداتا (عشان لو الباك إند مغلفها في 'data' زي العادة)
      final dynamic responseData = response.data['data'] ?? response.data;

      if (responseData is List) {
        _appointments = responseData
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
      }
      _isFetched = true;
      log(
        "[AppointmentProvider]: Fetched ${_appointments.length} appointments.",
      );
    } catch (e) {
      log("[AppointmentProvider]: Fetch failed - $e");
      _appointments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 2. إضافة موعد خاص
  // ==========================================
  Future<void> createPrivateAppointment(Map<String, dynamic> data) async {
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
  // 2. دالة إنهاء الموعد
  // ==========================================
  Future<bool> completeAppointment(String appointmentId) async {
    try {
      await getIt<AppointmentService>().completeAppointment(appointmentId);
      await fetchMyAppointments();
      return true; // نجاح
    } catch (e) {
      return false; // فشل
    }
  }

  // ==========================================
  // 3. حذف موعد
  // ==========================================
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await getIt<AppointmentService>().deleteAppointment(appointmentId);
      _appointments.removeWhere((a) => a.id == appointmentId);
      notifyListeners();
      log("[AppointmentProvider]: Appointment deleted successfully.");
      return true;
    } catch (e) {
      log("[AppointmentProvider]: Delete failed - $e");
      return false;
    }
  }

  // ==========================================
  // تحديث موعد عيادة (Update Appointment)
  // ==========================================
  Future<void> updateAppointment(
    String appointmentId,
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

  // ==========================================
  // حجز موعد في عيادة
  // ==========================================
  Future<void> bookClinicAppointment(Map<String, dynamic> data) async {
    try {
      await getIt<AppointmentService>().bookClinicAppointment(data);
    } catch (e) {
      log("❌ [AppointmentProvider]: Error booking clinic appointment: $e");
      rethrow;
    }
  }

  // ==========================================
  // قبول الموعد (للدكتور)
  // ==========================================
  Future<bool> approveClinicAppointment(String appointmentId) async {
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
  Future<bool> rejectClinicAppointment(String appointmentId) async {
    try {
      await getIt<AppointmentService>().rejectAppointment(appointmentId);
      await fetchMyAppointments();
      return true;
    } catch (e) {
      return false;
    }
  }
}
