class MessageModel {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentAt;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentAt,
  });

  // بنعمل factory عشان نحول الـ Map اللي راجع من السيرفر لـ Object
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    String timeStr = (json['sentAt'] ?? json['SentAt'])?.toString() ?? '';
    DateTime parsedTime;

    if (timeStr.isNotEmpty) {
      if (!timeStr.endsWith('Z') && !timeStr.contains('+')) {
        timeStr = '${timeStr}Z';
      }
      // بنحوله للوقت المحلي (لو مصر هيزود الساعتين أو التلاتة بتوع الصيفي)
      parsedTime = DateTime.parse(timeStr).toLocal();
    } else {
      parsedTime = DateTime.now();
    }

    return MessageModel(
      senderId:
          json['senderId']?.toString() ?? json['SenderId']?.toString() ?? '',
      receiverId:
          json['receiverId']?.toString() ??
          json['ReceiverId']?.toString() ??
          '',
      content: json['content'] ?? json['Content'] ?? '',
      sentAt: parsedTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
