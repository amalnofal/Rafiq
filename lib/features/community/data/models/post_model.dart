import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/models/user_model.dart';

class PostModel {
  final String id;
  final String userId;
  final UserModel user;
  final String text;
  final DateTime createdAt;
  final List<PostCategory> categories;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isEdited;

  PostModel({
    required this.id,
    required this.userId,
    required this.user,
    required this.text,
    required this.createdAt,
    required this.categories,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isEdited = false,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',

      user: map['user'] != null
          ? UserModel.fromJson(map['user'])
          : UserModel(
              id: 'unknown',
              firstName: 'مستخدم',
              lastName: 'رفيق',
              email: '',
              role: UserType.petOwner,
            ),

      text: map['text'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      imageUrl: map['imageUrl'],

      categories:
          (map['categories'] as List<dynamic>?)
              ?.map(
                (e) => PostCategory.values.firstWhere(
                  (cat) => cat.name == e,
                  orElse: () => PostCategory.values.first,
                ),
              )
              .toList() ??
          [],

      likesCount: map['likesCount']?.toInt() ?? 0,
      commentsCount: map['commentsCount']?.toInt() ?? 0,
      isLiked: map['isLiked'] ?? false,
      isEdited: map['isEdited'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'user': user.toJson(),
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'categories': categories.map((e) => e.name).toList(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'isEdited': isEdited,
    };
  }

  // ==========================================================
  // copyWith: مهمة لتحديث اللايكات والكومنتات محلياً
  // ==========================================================
  PostModel copyWith({
    String? id,
    String? userId,
    UserModel? user,
    String? text,
    DateTime? createdAt,
    List<PostCategory>? categories, 
    String? imageUrl,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isEdited,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      categories: categories ?? this.categories,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
