class CollarModel {
  final String id;
  final String serialNumber;
  final int batteryLevel;

  final String dailyTip;

  final int heartRate;
  final int steps;
  final double temp;

  CollarModel({
    required this.id,
    required this.serialNumber,
    required this.batteryLevel,
    
    this.heartRate = 0,
    this.steps = 0,
    this.temp = 0.0,
    this.dailyTip = "حافظ على نشاط أليفك لضمان صحة جيدة.",
  });

  // تحويل البيانات اللي جاية من الباك اند (JSON)
  factory CollarModel.fromJson(Map<String, dynamic> json) {
    return CollarModel(
      id: json['id']?.toString() ?? '',
      serialNumber: json['serial_number']?.toString() ?? '',
      batteryLevel: json['battery_level'] ?? 0,

      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      heartRate: json['heart_rate'] ?? 0,
      steps: json['steps'] ?? 0,

      dailyTip:
          json['daily_tip']?.toString() ??
          "حافظ على نشاط أليفك لضمان صحة جيدة.",
    );
  }
}
