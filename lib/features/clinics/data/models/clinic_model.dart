class ClinicModel {
  final int id;
  final String name;
  final String specialization;
  final String? description;
  final String address;
  final String phone;
  final String? imageUrl;

  final String openingTime;
  final String closingTime;
  final Map<String, bool> workingDays;

  final String? doctorId;
  final String? doctorName;
  final String? doctorProfilePhotoUrl;
  final String? doctorSpecialization;
  final String? doctorSubSpecialization;

  final double averageRating;
  final int totalReviews;
  final List<ReviewModel> reviews;

  ClinicModel({
    required this.id,
    required this.name,
    required this.specialization,
    this.description,
    required this.address,
    required this.phone,
    required this.openingTime,
    required this.closingTime,
    required this.workingDays,
    this.imageUrl,
    this.doctorId,
    required this.doctorName,
    this.doctorProfilePhotoUrl,
    required this.doctorSpecialization,
    required this.doctorSubSpecialization,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.reviews = const [],
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['clinicId'] is int
          ? json['clinicId']
          : json['clinicID'] is int
          ? json['clinicID']
          : json['ClinicId'] is int
          ? json['ClinicId']
          : json['id'] is int
          ? json['id']
          : int.tryParse(
                  json['clinicId']?.toString() ??
                      json['clinicID']?.toString() ??
                      json['ClinicId']?.toString() ??
                      json['id']?.toString() ??
                      '0',
                ) ??
                0,
      name: json['clinicName']?.toString() ?? json['name']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      description: json['description']?.toString(),
      address:
          json['address']?.toString() ??
          json['clinicAddress']?.toString() ??
          '',
      phone:
          json['phoneNumber']?.toString() ??
          json['clinicPhoneNumber']?.toString() ??
          '',
      openingTime: json['openingTime']?.toString() ?? '',
      closingTime: json['closingTime']?.toString() ?? '',
      workingDays: {
        'Saturday': json['saturday'] == true || json['saturday'] == 'true',
        'Sunday': json['sunday'] == true || json['sunday'] == 'true',
        'Monday': json['monday'] == true || json['monday'] == 'true',
        'Tuesday': json['tuesday'] == true || json['tuesday'] == 'true',
        'Wednesday': json['wednesday'] == true || json['wednesday'] == 'true',
        'Thursday': json['thursday'] == true || json['thursday'] == 'true',
        'Friday': json['friday'] == true || json['friday'] == 'true',
      },
      imageUrl:
          json['clinicPhotoURL']?.toString() ?? json['imageUrl']?.toString(),

      doctorId: json['doctorID']?.toString() ?? json['doctorId']?.toString(),
      doctorName: json['doctorName']?.toString(),
      doctorProfilePhotoUrl: json['doctorProfilePhotoURL']?.toString(),
      doctorSpecialization: json['doctorSpecialization']?.toString(),
      doctorSubSpecialization: json['doctorSubSpecialization']?.toString(),

      averageRating:
          double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0.0,
      totalReviews:
          int.tryParse(
            json['totalReviews']?.toString() ??
                json['totalRating']?.toString() ??
                '0',
          ) ??
          0,

      reviews:
          (json['reviews'] as List?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != 0) 'id': id,
      'ClinicName': name,
      'Specialization': specialization,
      if (description != null && description!.isNotEmpty)
        'Description': description,
      'Address': address,
      'PhoneNumber': phone,
      'OpeningTime': openingTime,
      'ClosingTime': closingTime,
      'Saturday': workingDays['Saturday'],
      'Sunday': workingDays['Sunday'],
      'Monday': workingDays['Monday'],
      'Tuesday': workingDays['Tuesday'],
      'Wednesday': workingDays['Wednesday'],
      'Thursday': workingDays['Thursday'],
      'Friday': workingDays['Friday'],
    };
  }
}

// ==========================================
// Review Model
// ==========================================
class ReviewModel {
  final int id;
  final String reviewerId;
  final String userName;
  final String? userImageUrl;
  final double rating;
  final String comment;
  final String timeAgo;
  final bool isOwner;

  ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.userName,
    this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.timeAgo,
    this.isOwner = false,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['reviewID'] is int
          ? json['reviewID']
          : int.tryParse(
                  json['reviewID']?.toString() ?? json['id']?.toString() ?? '0',
                ) ??
                0,
      reviewerId:
          json['userID']?.toString() ?? json['reviewerId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'Rafiq User',
      userImageUrl:
          json['userProfilePhotoURL']?.toString() ??
          json['userImageUrl']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      comment:
          json['reviewText']?.toString() ?? json['comment']?.toString() ?? '',
      timeAgo:
          json['createdAt']?.toString() ?? json['timeAgo']?.toString() ?? '',
      isOwner: json['isOwner'] == true || json['isOwner'] == 'true',
    );
  }
}
