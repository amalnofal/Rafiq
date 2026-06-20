// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';

enum UserType { petOwner, vet, admin }

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  final UserType role;

  final int? gender;
  final DateTime? birthDate;

  // بيانات الطبيب
  final String? specialization;
  final String? subSpecialization;
  final String? vetLicenseUrl;
  final String? frontNationalIdUrl;
  final String? backNationalIdUrl;
  final bool isVerified;
  final bool isFollowing;

  // عام
  final String? photoUrl;
  final String? coverUrl;
  final DateTime? joinedAt;

  final int postsCount;
  final int followersCount;
  final int followingCount;
  final List<PostCategory> interests;

  final Map<String, dynamic>? petOwnerDetails;
  final Map<String, dynamic>? doctorDetails;

  final List<PostModel>? posts;

  final bool publicPetView;
  final bool receiveChatFromOtherUsers;

  UserModel({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.role,
    this.gender,
    this.birthDate,
    this.specialization,
    this.subSpecialization,
    this.vetLicenseUrl,
    this.frontNationalIdUrl,
    this.backNationalIdUrl,
    this.isVerified = false,
    this.isFollowing = false,
    this.photoUrl,
    this.coverUrl,
    this.joinedAt,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.interests = const [],
    this.petOwnerDetails,
    this.doctorDetails,
    this.posts,
    this.publicPetView = true,
    this.receiveChatFromOtherUsers = true,
  });

  String get fullName => "$firstName $lastName";

  // ==========================================================
  // fromJson
  // ==========================================================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    List<PostCategory> loadedInterests = [];

    // الاهتمامات
    if (data['isHealthAndCare'] == true || data['IsHealthAndCare'] == true)
      loadedInterests.add(PostCategory.health);
    if (data['isNutritionAndFood'] == true ||
        data['IsNutritionAndFood'] == true)
      loadedInterests.add(PostCategory.food);
    if (data['isTrainingAndBehavior'] == true ||
        data['IsTrainingAndBehavior'] == true)
      loadedInterests.add(PostCategory.training);
    if (data['isGroomingAndAppearances'] == true ||
        data['IsGroomingAndAppearances'] == true)
      loadedInterests.add(PostCategory.grooming);
    if (data['isStoriesAndExperiences'] == true ||
        data['IsStoriesAndExperiences'] == true)
      loadedInterests.add(PostCategory.stories);
    if (data['isTravelAndTransport'] == true ||
        data['IsTravelAndTransport'] == true)
      loadedInterests.add(PostCategory.travel);
    if (data['isAdoptionAndRescue'] == true ||
        data['IsAdoptionAndRescue'] == true)
      loadedInterests.add(PostCategory.adoption);
    if (data['isUpbringingAndParenting'] == true ||
        data['IsUpbringingAndParenting'] == true)
      loadedInterests.add(PostCategory.activities);

    final String parsedId =
        data['id']?.toString() ??
        data['userId']?.toString() ??
        data['UserId']?.toString() ??
        '';

    String fName = data['firstName'] ?? data['FirstName'] ?? '';
    String lName = data['lastName'] ?? data['LastName'] ?? '';

    if (fName.isEmpty && lName.isEmpty && data['fullName'] != null) {
      final parts = data['fullName'].toString().trim().split(' ');
      fName = parts.isNotEmpty ? parts.first : '';
      lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    final String parsedPhoto =
        data['photoUrl']?.toString() ??
        data['profilePhotoUrl']?.toString() ??
        data['ProfilePhotoUrl']?.toString() ??
        data['profilePicture']?.toString() ??
        data['ProfilePicture']?.toString() ??
        '';

    // Gender
    int? genderVal;
    var rawGender = data['gender'] ?? data['Gender'];
    if (rawGender != null) {
      if (rawGender is int) {
        genderVal = rawGender;
      } else {
        genderVal = int.tryParse(rawGender.toString());
      }
    }

    // Role Mapping
    UserType type = UserType.petOwner;
    final roleString = (data['roleName'] ?? data['role'] ?? data['Role'])
        ?.toString()
        .toLowerCase();

    if (roleString == 'doctor' || roleString == 'vet') {
      type = UserType.vet;
    } else if (roleString == 'admin') {
      type = UserType.admin;
    }

    final docDetails = data['doctorDetails'] ?? {};

    // بناء الموديل مع تمرير المتغيرات المستخرجة الجديدة بذكاء
    final parsedUser = UserModel(
      id: parsedId,
      firstName: fName,
      lastName: lName,
      photoUrl: parsedPhoto,
      email: data['email'] ?? data['Email'] ?? '',
      phone: data['phoneNumber'] ?? data['PhoneNumber'],
      role: type,
      gender: genderVal,
      birthDate: (data['dateOfBirth'] ?? data['DateOfBirth']) != null
          ? DateTime.tryParse(
              (data['dateOfBirth'] ?? data['DateOfBirth']).toString(),
            )
          : null,
      joinedAt:
          (data['joinedDate'] ?? data['joinedAt'] ?? data['JoinedAt']) != null
          ? DateTime.tryParse(
              (data['joinedDate'] ?? data['joinedAt'] ?? data['JoinedAt'])
                  .toString(),
            )
          : null,
      specialization:
          docDetails['specialization'] ??
          data['specialization'] ??
          data['Specialization'],
      subSpecialization:
          docDetails['subSpecialization'] ??
          data['subSpecialization'] ??
          data['SubSpecialization'],
      vetLicenseUrl:
          docDetails['unionMembershipCard'] ??
          data['vetLicenseUrl'] ??
          data['UnionMembershipCard'],
      frontNationalIdUrl:
          docDetails['frontNationalId'] ??
          data['frontNationalIdUrl'] ??
          data['FrontNationalID'],
      backNationalIdUrl:
          docDetails['backNationalId'] ??
          data['backNationalIdUrl'] ??
          data['BackNationalID'],
      isVerified: data['isVerified'] ?? data['IsVerified'] ?? false,
      isFollowing: data['isFollowing'] ?? data['IsFollowing'] ?? false,
      coverUrl:
          data['coverPhotoUrl'] ?? data['coverPicture'] ?? data['CoverPicture'],
      postsCount:
          data['numberOfPosts'] ??
          data['postsCount'] ??
          data['PostsCount'] ??
          0,
      followersCount:
          data['numberOfFollowers'] ??
          data['followersCount'] ??
          data['FollowersCount'] ??
          0,
      followingCount:
          data['numberOfFollowing'] ??
          data['followingCount'] ??
          data['FollowingCount'] ??
          0,
      interests: loadedInterests,
      petOwnerDetails: data['petOwnerDetails'],
      doctorDetails: data['doctorDetails'],
      posts: const [],

      publicPetView: data['publicPetView'] ?? data['PublicPetView'] ?? true,
      receiveChatFromOtherUsers:
          data['reciveChatFromOtherUsers'] ??
          data['recivechatfromotherusers'] ??
          data['Recivechatfromotherusers'] ??
          true,
    );

    // بنقرأ البوستات ونديها بيانات اليوزر ده
    final parsedPosts = data['posts'] != null
        ? (data['posts'] as List).map((p) {
            final post = PostModel.fromMap(p);
            return post.copyWith(user: parsedUser);
          }).toList()
        : <PostModel>[];

    // نرجع اليوزر كامل ببوستاته
    return parsedUser.copyWith(posts: parsedPosts);
  }



  // ==========================================================
  // toJson
  // ==========================================================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'PhoneNumber': phone,
      'Role': role == UserType.admin
          ? 'Admin'
          : (role == UserType.vet ? 'Doctor' : 'PetOwner'),
      'Gender': gender,
      'DateOfBirth': birthDate?.toIso8601String(),
      'JoinedAt': joinedAt?.toIso8601String(),
      'IsVerified': isVerified,
      'ProfilePicture': photoUrl,
      'CoverPicture': coverUrl,

      'Specialization': specialization,
      'SupSpecialization': subSpecialization,
      'UnionMembershipCard': vetLicenseUrl,
      'FrontNationalID': frontNationalIdUrl,
      'BackNationalID': backNationalIdUrl,

      'IsHealthAndCare': interests.contains(PostCategory.health),
      'IsNutritionAndFood': interests.contains(PostCategory.food),
      'IsTrainingAndBehavior': interests.contains(PostCategory.training),
      'IsGroomingAndAppearances': interests.contains(PostCategory.grooming),
      'IsStoriesAndExperiences': interests.contains(PostCategory.stories),
      'IsTravelAndTransport': interests.contains(PostCategory.travel),
      'IsAdoptionAndRescue': interests.contains(PostCategory.adoption),
      'IsUpbringingAndParenting': interests.contains(PostCategory.activities),

      'petOwnerDetails': petOwnerDetails,
      'doctorDetails': doctorDetails,
      'posts': posts?.map((p) => p.toMap()).toList(),
      'publicPetView': publicPetView,
      'recivechatfromotherusers': receiveChatFromOtherUsers,
    };
  }

  Map<String, dynamic> toSettingsJson({String langCode = "ar"}) {
    return {
      "userId": int.tryParse(id) ?? 0,
      "preferredLanguage": langCode,
      "publicPetView": publicPetView,
      "publicProfileView": true,
      "showPhoneNumber": true,
      "recivechatfromotherusers": receiveChatFromOtherUsers,
    };
  }

  // ==========================================================
  // copyWith
  // ==========================================================
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? gender,
    DateTime? birthDate,
    UserType? role,
    String? specialization,
    String? subSpecialization,
    String? vetLicenseUrl,
    String? frontNationalIdUrl,
    String? backNationalIdUrl,
    bool? isVerified,
    bool? isFollowing,
    String? photoUrl,
    String? coverUrl,
    DateTime? joinedAt,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    List<PostCategory>? interests,
    Map<String, dynamic>? petOwnerDetails,
    Map<String, dynamic>? doctorDetails,
    List<PostModel>? posts,
    bool? publicPetView,
    bool? receiveChatFromOtherUsers,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
      specialization: specialization ?? this.specialization,
      subSpecialization: subSpecialization ?? this.subSpecialization,
      vetLicenseUrl: vetLicenseUrl ?? this.vetLicenseUrl,
      frontNationalIdUrl: frontNationalIdUrl ?? this.frontNationalIdUrl,
      backNationalIdUrl: backNationalIdUrl ?? this.backNationalIdUrl,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      photoUrl: photoUrl ?? this.photoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      interests: interests ?? this.interests,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      petOwnerDetails: petOwnerDetails ?? this.petOwnerDetails,
      doctorDetails: doctorDetails ?? this.doctorDetails,
      posts: posts ?? this.posts,
      publicPetView: publicPetView ?? this.publicPetView,
      receiveChatFromOtherUsers:
          receiveChatFromOtherUsers ?? this.receiveChatFromOtherUsers,
    );
  }
}
