class ClinicModel {
  final String id;
  final String name;
  final String specialization;
  final String? description;
  final String address;
  final String phone;
  final String workingHours;
  final String? imageUrl;

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
    required this.workingHours,
    this.imageUrl,
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
      id:
          json['id']?.toString() ??
          json['clinicID']?.toString() ??
          json['clinicId']?.toString() ??
          '',
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
      workingHours: json['workingHours']?.toString() ?? '',
      imageUrl:
          json['clinicPhotoURL']?.toString() ?? json['imageUrl']?.toString(),

      doctorName: json['doctorName']?.toString(),
      doctorProfilePhotoUrl: json['doctorProfilePhotoURL']?.toString(),
      doctorSpecialization: json['doctorSpecialization']?.toString(),
      doctorSubSpecialization: json['doctorSubSpecialization']?.toString(),

      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? json['totalRating'] ?? 0,

      reviews:
          (json['reviews'] as List?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'ClinicName': name,
      'Specialization': specialization,
      if (description != null && description!.isNotEmpty)
        'Description': description,
      'Address': address,
      'PhoneNumber': phone,
      'WorkingHours': workingHours,
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
      id: json['reviewID'] ?? json['id'] ?? 0,
      reviewerId:
          json['userID']?.toString() ?? json['reviewerId']?.toString() ?? '',
      userName: json['userName'] ?? 'Rafiq User',
      userImageUrl: json['userProfilePhotoURL'] ?? json['userImageUrl'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['reviewText'] ?? json['comment'] ?? '',
      timeAgo: json['createdAt'] ?? json['timeAgo'] ?? '',
      isOwner: json['isOwner'] ?? false,
    );
  }
}
