class AppointmentModel {
  final int id;
  final String petName;
  final String date;
  final String time;
  final String status;
  final String visitReason;
  final String? notes;
  final int? clinicId;
  final String? clinicName;
  final String? clinicAddress;
  final bool isPrivate;
  final String? petType;
  final String? breed;
  final String? dateOfBirth;
  final String? petImage;
  final int petId;
  final int? gender;

  final String? phoneNumber;
  final String? ownerName;

  AppointmentModel({
    required this.id,
    required this.petName,
    required this.date,
    required this.time,
    required this.status,
    required this.visitReason,
    this.notes,
    this.clinicId,
    this.clinicName,
    this.clinicAddress,
    this.isPrivate = false,
    this.petType,
    this.breed,
    this.dateOfBirth,
    this.petImage,
    this.gender,
    required this.petId,
    this.phoneNumber,
    this.ownerName,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    String rawDate = json['date']?.toString() ?? '';
    if (rawDate.contains('T')) {
      rawDate = rawDate.split('T')[0];
    }

    String rawTime =
        json['startTime']?.toString() ??
        json['StartTime']?.toString() ??
        json['time']?.toString() ??
        '';
    if (rawTime.length >= 5) {
      rawTime = rawTime.substring(0, 5);
    }

    int? safeGender(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is String) {
        final lower = val.toLowerCase().trim();
        if (lower == 'male') return 1;
        if (lower == 'female') return 0;
        return int.tryParse(val);
      }
      return null;
    }

    return AppointmentModel(
      id: json['appointmentId'] is int
          ? json['appointmentId']
          : int.tryParse(
                  json['appointmentId']?.toString() ??
                      json['id']?.toString() ??
                      '0',
                ) ??
                0,
      petName: json['petName']?.toString() ?? '',
      date: rawDate,
      time: rawTime,
      status: json['statusLabel']?.toString() ?? 'Pending',
      visitReason: json['visitReason']?.toString() ?? '',
      notes: json['notes']?.toString(),
      clinicId: json['clinicId'] is int
          ? json['clinicId']
          : int.tryParse(json['clinicId']?.toString() ?? ''),
      clinicName: json['clinicName']?.toString(),
      clinicAddress: json['clinicAddress']?.toString(),
      isPrivate:
          json['isPrivate'] == true ||
          json['isPrivate'] == 1 ||
          json['isPrivate'] == 'true',

      petType: json['petType']?.toString(),
      breed: json['breed']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      petImage: json['petImage']?.toString(),
      petId: json['petId'] is int
          ? json['petId']
          : int.tryParse(json['petId']?.toString() ?? '0') ?? 0,
      gender: safeGender(json['gender']),

      phoneNumber: json['phoneNumber']?.toString() ?? json['phone']?.toString(),
      ownerName:
          json['ownerName']?.toString() ??
          json['userName']?.toString() ??
          json['clientName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petName': petName,
      'date': date,
      'time': time,
      'status': status,
      'visitReason': visitReason,
      'notes': notes,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'isPrivate': isPrivate,
      'petType': petType,
      'breed': breed,
      'dateOfBirth': dateOfBirth,
      'petImage': petImage,
      'petId': petId,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'ownerName': ownerName,
    };
  }
}
