part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ConversationsLoaded extends ChatState {
  final List<ConversationModel> conversations;
  final int timestamp;

  const ConversationsLoaded(this.conversations, {this.timestamp = 0});

  @override
  List<Object?> get props => [conversations, timestamp];
}

final class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  final bool isOtherUserTyping;
  final bool isOtherUserOnline;

  const ChatMessagesLoaded({
    required this.messages,
    this.isOtherUserTyping = false,
    this.isOtherUserOnline = false,
  });

  ChatMessagesLoaded copyWith({
    List<MessageModel>? messages,
    bool? isOtherUserTyping,
    bool? isOtherUserOnline,
  }) {
    return ChatMessagesLoaded(
      messages: messages ?? this.messages,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
    );
  }

  @override
  List<Object?> get props => [messages, isOtherUserTyping, isOtherUserOnline];
}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}