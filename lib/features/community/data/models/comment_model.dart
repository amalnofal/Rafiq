import 'package:rafiq/core/models/user_model.dart';

class CommentModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final UserModel user;
  final bool isEdited;
  final bool isMine;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.user,
    this.isEdited = false,
    this.isMine = false,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      // مطابقة مفاتيح الباك إند بالملي من الـ Log
      id:
          map['commentID']?.toString() ??
          map['commentId']?.toString() ??
          map['id']?.toString() ??
          '',
      content: map['commentText'] ?? map['content'] ?? map['text'] ?? '',
      createdAt: map['timestamp'] != null
          ? _parseServerDateTime(map['timestamp'].toString())
          : (map['createdAt'] != null
                ? _parseServerDateTime(map['createdAt'].toString())
                : DateTime.now()),

      user: map['user'] != null
          ? UserModel.fromJson(map['user'])
          : UserModel(
              id: map['userID']?.toString() ?? map['userId']?.toString() ?? '',
              firstName: map['userFullName'] ?? map['userName'] ?? 'مستخدم',
              lastName: '',
              email: '',
              role: UserType.petOwner,
              photoUrl:
                  map['userProfilePhotoUrl'] ??
                  map['userProfileImage'] ??
                  map['userPhotoUrl'],
            ),
      isEdited: map['isEdited'] ?? false,
      isMine: map['isMine'] ?? map['isMine'] == true,
    );
  }

  CommentModel copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    UserModel? user,
    bool? isEdited,
    bool? isMine,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      isEdited: isEdited ?? this.isEdited,
      isMine: isMine ?? this.isMine,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'user': {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'userProfilePhotoUrl': user.photoUrl,
      },
      'isEdited': isEdited,
      'isMine': isMine,
    };
  }
}

DateTime _parseServerDateTime(String dateStr) {
  if (!dateStr.endsWith('Z') && !dateStr.contains('+')) {
    dateStr = '${dateStr}Z';
  }
  return DateTime.parse(dateStr).toLocal();
}
