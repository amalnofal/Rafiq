class ConversationModel {
  final int otherUserId;
  final String otherUserFirstName;
  final String otherUserLastName;
  final String lastMessageContent;
  final DateTime lastMessageSentAt;
  final String? photoUrl;

  ConversationModel({
    required this.otherUserId,
    required this.otherUserFirstName,
    required this.otherUserLastName,
    required this.lastMessageContent,
    required this.lastMessageSentAt,
    this.photoUrl,
  });

  String get fullName => '$otherUserFirstName $otherUserLastName';

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    String timeStr = json['lastMessageSentAt']?.toString() ?? '';
    DateTime parsedTime;

    if (timeStr.isNotEmpty) {
      if (!timeStr.endsWith('Z') && !timeStr.contains('+')) {
        timeStr = '${timeStr}Z';
      }
      parsedTime = DateTime.parse(timeStr).toLocal();
    } else {
      parsedTime = DateTime.now();
    }

    return ConversationModel(
      otherUserId: json['otherUserId'] ?? 0,
      otherUserFirstName: json['otherUserFirstName'] ?? '',
      otherUserLastName: json['otherUserLastName'] ?? '',
      lastMessageContent: json['lastMessageContent'] ?? '',
      lastMessageSentAt: parsedTime,
      photoUrl:
          json['otherUserProfilePhotoUrl'] ??
          json['photoUrl'] ??
          json['otherUserPhotoUrl'],
    );
  }

  // الدالة الجديدة هنا
  ConversationModel copyWith({
    String? lastMessageContent,
    DateTime? lastMessageSentAt,
  }) {
    return ConversationModel(
      otherUserId: otherUserId,
      otherUserFirstName: otherUserFirstName,
      otherUserLastName: otherUserLastName,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
      photoUrl: photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otherUserId': otherUserId,
      'otherUserFirstName': otherUserFirstName,
      'otherUserLastName': otherUserLastName,
      'lastMessageContent': lastMessageContent,
      'lastMessageSentAt': lastMessageSentAt.toIso8601String(),
      'photoUrl': photoUrl,
    };
  }
}
