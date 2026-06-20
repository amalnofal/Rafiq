class CollarReadingModel {
  final String timestamp;
  final double heartRateBpm;
  final double temperatureCelsius;
  final double latitude;
  final double longitude;

  CollarReadingModel({
    required this.timestamp,
    required this.heartRateBpm,
    required this.temperatureCelsius,
    required this.latitude,
    required this.longitude,
  });

  factory CollarReadingModel.fromJson(Map<String, dynamic> json) {
    return CollarReadingModel(
      timestamp: json['timestamp'] ?? '',
      heartRateBpm: (json['heartRateBpm'] as num?)?.toDouble() ?? 0.0,
      temperatureCelsius:
          (json['temperatureCelsius'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
