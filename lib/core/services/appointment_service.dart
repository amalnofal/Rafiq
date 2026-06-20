import 'dart:developer';
import 'package:dio/dio.dart';

class AppointmentService {
  final Dio _dio;

  AppointmentService(this._dio);

  // 1. جلب كل مواعيد اليوزر
  Future<Response> getMyAppointments() async {
    try {
      final response = await _dio.get('/Appointment/my');
      log("📥 Appointments Data From Backend: ${response.data}");
      return response;
    } catch (e) {
      log("[AppointmentService]: Error fetching appointments - $e");
      rethrow;
    }
  }

  // 2. إضافة موعد خاص (Private)
  Future<Response> addPrivateAppointment(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await _dio.post('/Appointment/private', data: formData);
      return response;
    } on DioException catch (e) {
      log("❌ Backend Error Response: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log("[AppointmentService]: Error adding private appointment - $e");
      rethrow;
    }
  }

  // 3. تعديل موعد (Update)
  Future<Response> updateAppointment(
    int appointmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await _dio.put(
        '/Appointment/$appointmentId',
        data: formData,
      );
      return response;
    } on DioException catch (e) {
      log("❌ Backend Update Error: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log("[AppointmentService]: Error updating appointment - $e");
      rethrow;
    }
  }

  // 4. إنهاء الموعد (تحديد كمكتمل)
  Future<Response> completeAppointment(int appointmentId) async {
    log("👉 Trying to complete appointment with ID: $appointmentId");
    try {
      final response = await _dio.post(
        '/Appointment/$appointmentId/complete',
        data: {},
      );
      return response;
    } on DioException catch (e) {
      // هذا السطر سيكشف لك بالضبط لماذا رفض السيرفر الطلب (400)
      log("❌ Backend Complete Error Data: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log("[AppointmentService]: Error completing appointment - $e");
      rethrow;
    }
  }

  // 5. حذف موعد
  Future<Response> deleteAppointment(int appointmentId) async {
    try {
      final response = await _dio.delete('/Appointment/$appointmentId');
      return response;
    } catch (e) {
      log("[AppointmentService]: Error deleting appointment - $e");
      rethrow;
    }
  }

  // جلب عيادات الدكتور
  Future<Response> getDoctorClinics() async {
    try {
      return await _dio.get('/Appointment/doctor/clinics');
    } catch (e) {
      log("[AppointmentService]: Error fetching clinics - $e");
      rethrow;
    }
  }

  // حجز الدكتور موعد في عيادته (Block Time)
  Future<Response> addDoctorClinicAppointment(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      return await _dio.post('/Appointment/clinic/doctor', data: formData);
    } catch (e) {
      log("[AppointmentService]: Error adding doctor clinic appointment - $e");
      rethrow;
    }
  }

  // ==========================================
  // حجز موعد في عيادة (للمالك) - الحالة المبدئية Pending
  // ==========================================
  Future<Response> bookClinicAppointment(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final response = await _dio.post(
        '/Appointment/clinic/book',
        data: formData,
      );
      return response;
    } catch (e) {
      log("[AppointmentService]: فشل حجز موعد العيادة: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب الأوقات المتاحة للحجز (لليوزر)
  // ==========================================
  Future<Response> getAvailableSlots(int clinicId, String date) async {
    try {
      return await _dio.get(
        '/Appointment/available-slots',
        queryParameters: {'clinicId': clinicId, 'date': date},
      );
    } catch (e) {
      log("[AppointmentService]: Error fetching available slots - $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب مواعيد العيادة المحجوزة (للدكتور - Calendar)
  // ==========================================
  Future<Response> getClinicCalendar(int clinicId) async {
    try {
      return await _dio.get('/Appointment/clinic/$clinicId/calendar');
    } catch (e) {
      log("[AppointmentService]: Error fetching clinic calendar - $e");
      rethrow;
    }
  }

  // قبول الموعد (للدكتور)
  Future<Response> approveAppointment(int appointmentId) async {
    try {
      final response = await _dio.post('/Appointment/$appointmentId/approve');
      return response;
    } catch (e) {
      log("[AppointmentService]: Error approving appointment - $e");
      rethrow;
    }
  }

  // رفض الموعد (للدكتور)
  Future<Response> rejectAppointment(int appointmentId) async {
    try {
      final response = await _dio.post('/Appointment/$appointmentId/reject');
      return response;
    } on DioException catch (e) {
      log("🚨 [Backend Error Data]: ${e.response?.data}");
      log("🚨 [Backend Status Code]: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      log("[AppointmentService]: Error rejecting appointment - $e");
      rethrow;
    }
  }
}
