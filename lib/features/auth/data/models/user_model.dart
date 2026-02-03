class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String userType; // "pet_owner" or "vet"
  final String? gender;
  final DateTime? birthDate;

  // بيانات الطبيب (لو موجودة)
  final String? vetLicenseUrl;
  final bool isVerified;

  // بيانات عامة
  final String? photoUrl;
  final DateTime? joinedAt;

  // ✅ القائمة دي عشان الـ UI بتاعنا (SelectionChips) يفضل شغال
  final List<int> interestIds;

  UserModel({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.userType,
    this.gender,
    this.birthDate,
    this.vetLicenseUrl,
    this.isVerified = false,
    this.photoUrl,
    this.joinedAt,
    this.interestIds = const [],
  });

  String get fullName => "$firstName $lastName";

  // ==========================================================
  // 1. fromJson: تحويل الـ Booleans القادمة من الباك إند إلى List IDs
  // ==========================================================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // تجميع الاهتمامات: بنحول الـ true/false اللي جاي من السيرفر لـ أرقام
    // عشان نعرضها في الـ UI بتاعنا كـ Selected Chips
    List<int> interests = [];

    // ملاحظة: تأكدي من أسماء المفاتيح (Keys) مع الباك إند ديفلوبر
    if (json['isHealthInterested'] == true) interests.add(1);
    if (json['isTrainingInterested'] == true) interests.add(2);
    if (json['isFoodInterested'] == true) interests.add(3);
    if (json['isGroomingInterested'] == true) interests.add(4);
    if (json['isActivitiesInterested'] == true) interests.add(5);
    if (json['isAdoptionInterested'] == true) interests.add(6);
    if (json['isTravelInterested'] == true) interests.add(7);
    if (json['isStoriesInterested'] == true) interests.add(8);

    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNumber'], // ممكن ييجي null وعادي
      userType: json['userType'] ?? 'pet owner',
      gender: json['gender'], // هييجي String زي ما اخترتيه
      // استقبال التاريخ
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'].toString())
          : null,

      vetLicenseUrl: json['vetLicenseUrl'],
      isVerified: json['isVerified'] ?? false,
      photoUrl: json['photoUrl'],

      // تمرير القائمة المجمعة
      interestIds: interests,
    );
  }

  // ==========================================================
  // 2. toJson: تحويل الـ List IDs إلى Booleans للإرسال
  // ==========================================================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phone, 
      'userType': userType,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'joinedAt': joinedAt?.toIso8601String(),
      'vetLicenseUrl': vetLicenseUrl,
      'isVerified': isVerified,
      'photoUrl': photoUrl,

      // ✅ تحويل الليستة لـ Booleans عشان الباك إند يفهمها ويخزنها صح
      'isHealthInterested': interestIds.contains(1),
      'isTrainingInterested': interestIds.contains(2),
      'isFoodInterested': interestIds.contains(3),
      'isGroomingInterested': interestIds.contains(4),
      'isActivitiesInterested': interestIds.contains(5),
      'isAdoptionInterested': interestIds.contains(6),
      'isTravelInterested': interestIds.contains(7),
      'isStoriesInterested': interestIds.contains(8),
    };
  }

  // ==========================================================
  // 3. copyWith: للتحديث الجزئي (تعديل البروفايل)
  // ==========================================================
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    DateTime? birthDate,
    String? userType,
    String? vetLicenseUrl,
    bool? isVerified,
    String? photoUrl,
    DateTime? joinedAt,
    List<int>? interestIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      userType: userType ?? this.userType,
      vetLicenseUrl: vetLicenseUrl ?? this.vetLicenseUrl,
      isVerified: isVerified ?? this.isVerified,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      interestIds: interestIds ?? this.interestIds,
    );
  }
}
