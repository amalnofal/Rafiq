import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/models/user_model.dart';

// كلاس جديد للميديا عشان يشيل الصورة أو الفيديو
class PostMedia {
  final int id;
  final String url;

  PostMedia({required this.id, required this.url});

  factory PostMedia.fromMap(Map<String, dynamic> map) {
    return PostMedia(
      id: map['mediaID'] ?? map['id'] ?? 0,
      url: map['mediaURL'] ?? map['url'] ?? map['fileUrl'] ?? '',
    );
  }

  bool get isVideo {
    final cleanUrl = url.toLowerCase().split('?').first;

    return cleanUrl.endsWith('.mp4') ||
        cleanUrl.endsWith('.mov') ||
        cleanUrl.endsWith('.avi') ||
        cleanUrl.endsWith('.mkv') ||
        url.toLowerCase().contains('.mp4');
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'url': url};
  }
}

class PostModel {
  final String id;
  final String userId;
  final UserModel user;
  final String text;
  final DateTime createdAt;
  final List<PostCategory> categories;
  final List<PostMedia> media;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isUploading;
  final bool isUploadFailed;

  PostModel({
    required this.id,
    required this.userId,
    required this.user,
    required this.text,
    required this.createdAt,
    required this.categories,
    this.media = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isUploading = false,
    this.isUploadFailed = false,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    List<PostMedia> parsedMedia = [];
    if (map['media'] != null && (map['media'] as List).isNotEmpty) {
      parsedMedia = (map['media'] as List)
          .map((m) => PostMedia.fromMap(m))
          .toList();
    } else if (map['imageUrl'] != null) {
      // عشان لو في بوستات قديمة متخزنة بصورة واحدة
      parsedMedia.add(PostMedia(id: map['mediaId'] ?? 0, url: map['imageUrl']));
    }

    return PostModel(
      id: map['postID']?.toString() ?? map['id']?.toString() ?? '',
      userId: map['userID']?.toString() ?? map['userId']?.toString() ?? '',

      user: map['user'] != null
          ? UserModel.fromJson(map['user'])
          : UserModel(
              id: map['userID']?.toString() ?? 'unknown',
              firstName: map['userFullName'] ?? map['userName'] ?? 'مستخدم',
              lastName: '',
              email: '',
              role: UserType.petOwner,
              photoUrl: map['userProfileImage']?.toString(),
            ),

      text: map['contentText'] ?? map['text'] ?? '',
      createdAt: map['timestamp'] != null
          ? _parseServerDateTime(map['timestamp'].toString())
          : (map['createdAt'] != null
                ? _parseServerDateTime(map['createdAt'].toString())
                : DateTime.now()),
      media: parsedMedia,
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

      likesCount: map['totalLikes']?.toInt() ?? map['likesCount']?.toInt() ?? 0,
      commentsCount:
          map['totalComments']?.toInt() ?? map['commentsCount']?.toInt() ?? 0,

      isLiked: map['isLiked'] ?? map['IsLiked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'user': user.toJson(),
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'media': media.map((e) => e.toMap()).toList(),
      'categories': categories.map((e) => e.name).toList(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    UserModel? user,
    String? text,
    DateTime? createdAt,
    List<PostCategory>? categories,
    List<PostMedia>? media,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isUploading,
    bool? isUploadFailed,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      categories: categories ?? this.categories,
      media: media ?? this.media,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isUploading: isUploading ?? this.isUploading,
      isUploadFailed: isUploadFailed ?? this.isUploadFailed,
    );
  }
}

DateTime _parseServerDateTime(String dateStr) {
  if (!dateStr.endsWith('Z') && !dateStr.contains('+')) {
    dateStr = '${dateStr}Z';
  }
  return DateTime.parse(dateStr).toLocal();
}
