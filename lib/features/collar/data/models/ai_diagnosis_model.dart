class AiDiagnosisModel {
  final String motionStatus;
  final String vitalStatus;
  final String finalStatus;
  final List<String> motionReasons;
  final List<String> vitalReasons;
  final List<String> combinedReasons;
  final int severityScore;
  final String alertLevel;

  AiDiagnosisModel({
    required this.motionStatus,
    required this.vitalStatus,
    required this.finalStatus,
    required this.motionReasons,
    required this.vitalReasons,
    required this.combinedReasons,
    required this.severityScore,
    required this.alertLevel,
  });

  factory AiDiagnosisModel.fromJson(Map<String, dynamic> json) {
    final data = (json.containsKey('data') && json['data'] != null) ? json['data'] : json;

    List<String> motionR = [];
    List<String> vitalR = [];
    List<String> combinedR = [];

    if (data['reason'] != null && data['reason'] is Map) {
      motionR = List<String>.from(data['reason']['motion'] ?? []);
      vitalR = List<String>.from(data['reason']['vital'] ?? []);
      combinedR = List<String>.from(data['reason']['combined'] ?? []);
    } else {
      motionR = List<String>.from(data['motionReasons'] ?? data['motion_reasons'] ?? []);
      vitalR = List<String>.from(data['vitalReasons'] ?? data['vital_reasons'] ?? []);
      combinedR = List<String>.from(data['combinedReasons'] ?? data['combined_reasons'] ?? []);
    }

    return AiDiagnosisModel(
      motionStatus: data['motionStatus'] ?? data['motion_status'] ?? 'Unknown',
      vitalStatus: data['vitalStatus'] ?? data['vital_status'] ?? 'Unknown',
      finalStatus: data['finalStatus'] ?? data['final_status'] ?? 'Unknown',
      motionReasons: motionR,
      vitalReasons: vitalR,
      combinedReasons: combinedR,
      severityScore: data['severityScore'] ?? data['severity_score'] ?? 0,
      alertLevel: data['alertLevel'] ?? data['alert_level'] ?? 'Unknown',
    );
  }
}