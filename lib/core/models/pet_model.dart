class PetModel {
  final String id;
  final String name;
  final int type;
  final int gender;
  final double weight;
  final String breed;
  final String color;
  final DateTime dob;
  final String? imageUrl;
  final String? collarId;

  // حقول إضافية للمواعيد والتذكيرات
  final String lastVaccine;
  final String lastVaccineDate;
  final String nextAppointment;
  final String nextAppointmentDate;
  final String reminderTitle;
  final String reminderDesc;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.weight,
    required this.color,
    required this.dob,
    this.imageUrl,
    this.collarId,
    this.lastVaccine = "",
    this.lastVaccineDate = "",
    this.nextAppointment = "",
    this.nextAppointmentDate = "",
    this.reminderTitle = "",
    this.reminderDesc = "",
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  factory PetModel.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      if (val is String) {
        final parsed = int.tryParse(val);
        if (parsed != null) return parsed;

        final lower = val.toLowerCase().trim();

        // ظبط أرقام الأنواع
        if (lower == 'dog') return 1;
        if (lower == 'cat') return 2;
        if (lower == 'bird') return 3;
        if (lower == 'rabbit') return 4;
        if (lower == 'turtle') return 5;

        // ظبط أرقام الجنس (1 للذكر، و 0 للأنثى)
        if (lower == 'male') return 1;
        if (lower == 'female') return 0;
      }
      return 0;
    }

    double safeDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return PetModel(
      id: (json['petId'] ?? json['id'] ?? json['PetId'] ?? '').toString(),
      name: json['petName'] ?? json['PetName'] ?? json['name'] ?? '',

      type: safeInt(json['type'] ?? json['Type']),
      gender: safeInt(json['gender'] ?? json['Gender']),
      weight: safeDouble(json['weight'] ?? json['Weight']),

      breed: json['breed'] ?? json['Breed'] ?? '',
      color: json['color'] ?? json['Color'] ?? '',
      dob:
          DateTime.tryParse(json['dateOfBirth'] ?? json['DateOfBirth'] ?? '') ??
          DateTime.now(),
      imageUrl:
          json['petPhotoUrl'] ??
          json['PetPhotoUrl'] ??
          json['imageUrl'] ??
          json['PhotoUrl'],

      collarId: json['collar'] != null
          ? json['collar']['id']?.toString()
          : json['collarId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PetName': name,
      'Type': type,
      'Gender': gender,
      'Breed': breed,
      'DateOfBirth': dob.toIso8601String().split('T')[0],
      'Weight': weight,
      'Color': color,
      'PetPhotoUrl': imageUrl,
    };
  }

  PetModel copyWith({
    String? id,
    String? name,
    int? type,
    int? gender,
    double? weight,
    String? breed,
    String? color,
    DateTime? dob,
    String? imageUrl,
    String? collarId,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      breed: breed ?? this.breed,
      color: color ?? this.color,
      dob: dob ?? this.dob,
      imageUrl: imageUrl ?? this.imageUrl,
      collarId: collarId ?? this.collarId,
    );
  }
}
