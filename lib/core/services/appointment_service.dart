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
    String appointmentId,
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
  Future<Response> completeAppointment(String appointmentId) async {
    try {
      final response = await _dio.post('/Appointment/$appointmentId/complete');
      return response;
    } catch (e) {
      log("[AppointmentService]: Error completing appointment - $e");
      rethrow;
    }
  }

  // 5. حذف موعد
  Future<Response> deleteAppointment(String appointmentId) async {
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

  // 6. قبول الموعد (للدكتور)
  Future<Response> approveAppointment(String appointmentId) async {
    try {
      final response = await _dio.post('/Appointment/$appointmentId/approve');
      return response;
    } catch (e) {
      log("[AppointmentService]: Error approving appointment - $e");
      rethrow;
    }
  }

  // 7. رفض الموعد (للدكتور)
  Future<Response> rejectAppointment(String appointmentId) async {
    try {
      final response = await _dio.post('/Appointment/$appointmentId/reject');
      return response;
    } catch (e) {
      log("[AppointmentService]: Error rejecting appointment - $e");
      rethrow;
    }
  }
}
