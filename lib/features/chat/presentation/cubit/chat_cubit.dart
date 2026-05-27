import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/services/chat_service.dart';
import 'package:rafiq/features/chat/data/conversation_model.dart';
import 'package:rafiq/features/chat/data/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _chatService;
  Timer? _typingTimer;
  String? _currentUserId;
  String? _activeChatUserId;

  final Map<String, List<MessageModel>> _chatsCache = {};
  List<ConversationModel> _conversationsCache = [];

  final Set<String> onlineUsers = {};
  final Set<String> typingUsers = {};

  bool _isSignalRInitialized = false;

  Future<void> connectAppWideRealtime() async {
    final userId = CacheHelper.getData(key: 'userId');
    if (userId != null) {
      await _ensureSignalRConnected();
    }
  }

  ChatCubit(this._chatService) : super(ChatInitial()) {
    _currentUserId = CacheHelper.getData(key: 'userId')?.toString();

    _chatService.onMessageReceived = (messageData) {
      final newMessage = MessageModel.fromJson(messageData);

      // 1. تحديث الشات لو إحنا جواه
      if (state is ChatMessagesLoaded) {
        final currentState = state as ChatMessagesLoaded;

        if (newMessage.senderId != _activeChatUserId) return;

        final updatedMessages = List<MessageModel>.from(currentState.messages)
          ..add(newMessage);
        if (_activeChatUserId != null) {
          _chatsCache[_activeChatUserId!] = updatedMessages;
        }

        emit(currentState.copyWith(messages: updatedMessages));
      }
      // 2. تحديث قائمة الـ Inbox بالرسالة الجديدة لو إحنا برا الشات
      else if (state is ConversationsLoaded) {
        final conversationIndex = _conversationsCache.indexWhere(
          (c) => c.otherUserId.toString() == newMessage.senderId,
        );

        if (conversationIndex != -1) {
          final updatedConversation = _conversationsCache[conversationIndex]
              .copyWith(
                lastMessageContent: newMessage.content,
                lastMessageSentAt: newMessage.sentAt,
              );

          _conversationsCache.removeAt(conversationIndex);
          _conversationsCache.insert(0, updatedConversation);
        } else {
          // لو محادثة جديدة خالص بنجيب اللستة من السيرفر تاني
          getConversations();
          return;
        }

        emit(
          ConversationsLoaded(
            List.from(_conversationsCache),
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    };

    _chatService.onUserOnlineStatusChanged = (userId, isOnline) {
      if (isOnline) {
        onlineUsers.add(userId);
      } else {
        onlineUsers.remove(userId);
      }

      if (state is ChatMessagesLoaded && userId == _activeChatUserId) {
        emit(
          (state as ChatMessagesLoaded).copyWith(isOtherUserOnline: isOnline),
        );
      } else if (state is ConversationsLoaded) {
        emit(
          ConversationsLoaded(
            _conversationsCache,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    };

    _chatService.onUserTypingStatusChanged = (userId, isTyping) {
      if (isTyping) {
        typingUsers.add(userId);
      } else {
        typingUsers.remove(userId);
      }

      if (state is ChatMessagesLoaded && userId == _activeChatUserId) {
        emit(
          (state as ChatMessagesLoaded).copyWith(isOtherUserTyping: isTyping),
        );
      } else if (state is ConversationsLoaded) {
        emit(
          ConversationsLoaded(
            _conversationsCache,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    };
  }

  Future<void> _ensureSignalRConnected() async {
    if (!_isSignalRInitialized) {
      _isSignalRInitialized = true;
      final token = CacheHelper.getData(key: 'accessToken') ?? '';
      _chatService
          .initConnection(
            baseUrl: 'https://rafiq-app.runasp.net',
            accessToken: token,
          )
          .catchError((error) {
            _isSignalRInitialized = false;
            log(
              '⚠️ SignalR connection background error: $error',
              name: 'ChatCubit',
            );
          });
    }
  }

 // =======================================================
  // 1. جلب قائمة المحادثات (Inbox) مع دعم الـ Offline
  // =======================================================
  Future<void> getConversations() async {
    // 💡 1. محاولة القراءة من الكاش المحلي (عشان يفتح في 0 ثانية)
    if (_conversationsCache.isEmpty) {
      final cachedData = CacheHelper.getData(key: 'cached_conversations');
      if (cachedData != null) {
        try {
          final List decoded = jsonDecode(cachedData);
          // (ملاحظة: لو الموديل عندك بيستخدم fromMap بدلها)
          _conversationsCache = decoded.map((e) => ConversationModel.fromJson(e)).toList(); 
          emit(ConversationsLoaded(
            _conversationsCache,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ));
        } catch (e) {
          log('❌ خطأ في قراءة كاش المحادثات: $e', name: 'ChatCubit');
        }
      }
    }

    // لو مفيش كاش خالص (أول مرة يفتح الأبلكيشن)، نعرض الـ Shimmer
    if (_conversationsCache.isEmpty) {
      emit(ChatLoading());
    } else {
      emit(ConversationsLoaded(
        _conversationsCache,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    // 💡 2. جلب الجديد من السيرفر في الخلفية
    try {
      await _ensureSignalRConnected();
      final conversations = await _chatService.getConversations();

      _conversationsCache = conversations;
      
      // 💡 3. حفظ الداتا الجديدة في الموبايل
      final encoded = jsonEncode(conversations.map((c) => c.toJson()).toList());
      await CacheHelper.saveData(key: 'cached_conversations', value: encoded);

      emit(ConversationsLoaded(
        _conversationsCache,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    } catch (e) {
      log('❌ فشل تحديث المحادثات من السيرفر: $e', name: 'ChatCubit');
      // لو مفيش نت ومفيش كاش خالص، نعرض إيرور. غير كده هنسيبه يعرض الكاش!
      if (_conversationsCache.isEmpty) {
        emit(ChatError(e.toString()));
      }
    }
  }

  // =======================================================
  // 2. جلب رسائل شات معين مع دعم الـ Offline
  // =======================================================
  Future<void> startChatSession(String otherUserId) async {
    _activeChatUserId = otherUserId;
    final String cacheKey = 'chat_messages_$otherUserId'; // مفتاح فريد لكل شخص

    // 💡 1. محاولة القراءة من الكاش
    if (!_chatsCache.containsKey(otherUserId) || _chatsCache[otherUserId]!.isEmpty) {
      final cachedData = CacheHelper.getData(key: cacheKey);
      if (cachedData != null) {
        try {
          final List decoded = jsonDecode(cachedData);
          _chatsCache[otherUserId] = decoded.map((e) => MessageModel.fromJson(e)).toList();
        } catch (e) {
          log('❌ خطأ في قراءة كاش الرسائل: $e', name: 'ChatCubit');
        }
      }
    }

    if (_chatsCache.containsKey(otherUserId) && _chatsCache[otherUserId]!.isNotEmpty) {
      emit(ChatMessagesLoaded(
        messages: _chatsCache[otherUserId]!,
        isOtherUserOnline: onlineUsers.contains(otherUserId),
        isOtherUserTyping: false,
      ));
    } else {
      emit(ChatLoading());
    }

    // 💡 2. جلب الجديد من السيرفر
    try {
      final messages = await _chatService.getChatMessages(otherUserId);
      final isOnline = await _chatService.checkUserOnlineStatus(otherUserId);

      if (isOnline) onlineUsers.add(otherUserId);

      _chatsCache[otherUserId] = messages;

      // 💡 3. حفظ الرسائل الجديدة في الموبايل
      final encoded = jsonEncode(messages.map((m) => m.toJson()).toList());
      await CacheHelper.saveData(key: cacheKey, value: encoded);

      emit(ChatMessagesLoaded(
        messages: messages,
        isOtherUserOnline: isOnline,
        isOtherUserTyping: false,
      ));

      await _ensureSignalRConnected();
    } catch (e) {
      if (!_chatsCache.containsKey(otherUserId) || _chatsCache[otherUserId]!.isEmpty) {
        emit(ChatError(e.toString()));
      }
    }
  }
  void leaveChatSession() {
    _activeChatUserId = null;
    getConversations();
  }

  Future<void> sendMessage(String otherUserId, String content) async {
    try {
      if (state is ChatMessagesLoaded) {
        final currentState = state as ChatMessagesLoaded;
        final optimisticMessage = MessageModel(
          senderId: _currentUserId ?? '0',
          receiverId: otherUserId,
          content: content,
          sentAt: DateTime.now(),
        );

        final updatedMessages = List<MessageModel>.from(currentState.messages)
          ..add(optimisticMessage);
        _chatsCache[otherUserId] = updatedMessages;
        emit(currentState.copyWith(messages: updatedMessages));
      }

      await _chatService.sendMessage(otherUserId, content);

      // تحديث كاش الـ Inbox بالرسالة اللي إحنا بعتناها
      final conversationIndex = _conversationsCache.indexWhere(
        (c) => c.otherUserId.toString() == otherUserId,
      );
      if (conversationIndex != -1) {
        final updatedConversation = _conversationsCache[conversationIndex]
            .copyWith(
              lastMessageContent: content,
              lastMessageSentAt: DateTime.now(),
            );
        _conversationsCache.removeAt(conversationIndex);
        _conversationsCache.insert(0, updatedConversation);
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void notifyTyping(String otherUserId) {
    _chatService.sendTyping(otherUserId, true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      _chatService.sendTyping(otherUserId, false);
    });
  }

  @override
  void emit(ChatState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _activeChatUserId = null;
    _chatService.disconnect();
    return super.close();
  }
}
