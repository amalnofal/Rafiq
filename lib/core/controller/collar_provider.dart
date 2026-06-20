import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rafiq/features/collar/data/models/ai_diagnosis_model.dart';
import 'package:rafiq/features/collar/data/models/collar_reading_model.dart';
import '../services/collar_service.dart';

class CollarProvider extends ChangeNotifier {
  final CollarService _collarService;

  CollarProvider(this._collarService);

  CollarReadingModel? latestReading;
  Timer? _pollingTimer;
  bool isLoading = false;
  String? errorMessage;

  AiDiagnosisModel? aiDiagnosis;
  Timer? _aiPollingTimer;
  bool isAiLoading = false;
  String? aiErrorMessage;

  // ==========================================
  //        Collar Readings Methods
  // ==========================================

  void startPolling(int petId) {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _fetchReading(petId);

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchReading(petId, after: latestReading?.timestamp);
    });
  }

  Future<void> _fetchReading(int petId, {String? after}) async {
    try {
      final reading = await _collarService.getLatestReading(
        petId,
        after: after,
      );

      isLoading = false;

      if (reading != null) {
        latestReading = reading;
        errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      log("[CollarProvider]: Error - $errorMessage");
      notifyListeners();
    }
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  // ==========================================
  //        AI Diagnosis Methods
  // ==========================================

  void startAiPolling(int petId) {
    fetchAiDiagnosis(petId);

    _aiPollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchAiDiagnosis(petId);
    });
  }

  void stopAiPolling() {
    _aiPollingTimer?.cancel();
    _aiPollingTimer = null;
  }

  Future<void> fetchAiDiagnosis(int petId) async {
    if (aiDiagnosis == null) {
      isAiLoading = true;
      aiErrorMessage = null;
      notifyListeners();
    }

    try {
      final diagnosis = await _collarService.getAiDiagnosis(petId);
      aiDiagnosis = diagnosis;
      aiErrorMessage = null;
    } catch (e) {
      aiErrorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isAiLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopPolling();
    stopAiPolling();
    super.dispose();
  }
}
