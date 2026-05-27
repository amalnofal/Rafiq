import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rafiq/features/chat/data/conversation_model.dart';
import 'package:rafiq/features/chat/data/message_model.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';

class ChatService {
  final Dio _dio;
  HubConnection? _hubConnection;

  // Callbacks عشان نمرر البيانات للـ Cubit أول ما توصل من السيرفر
  Function(Map<String, dynamic>)? onMessageReceived;
  Function(String, bool)? onUserOnlineStatusChanged;
  Function(String, bool)? onUserTypingStatusChanged;

  ChatService(this._dio);

  // =========================================================
  // 1. HTTP Requests (REST API) لجلب البيانات القديمة
  // =========================================================

  /// جلب قائمة المحادثات لشاشة الـ Inbox
  /// جلب قائمة المحادثات لشاشة الـ Inbox
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _dio.get('/Chat/conversations');

      log("💬 [ChatService]: ريسبونس المحادثات الحقيقي: ${response.data}");

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => ConversationModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log('❌ [ChatService]: الريكويست ضرب إيرور أو علّق: $e');
      return [];
    }
  }

  /// جلب رسائل محادثة معينة
  Future<List<MessageModel>> getChatMessages(
    String otherUserId, {
    int? beforeMessageId,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/Chat/$otherUserId/messages',
        queryParameters: {
          if (beforeMessageId != null) 'beforeMessageId': beforeMessageId,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => MessageModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log('❌ Error fetching messages', name: 'ChatService', error: e);
      throw Exception('فشل في تحميل الرسائل');
    }
  }

  /// التحقق من حالة المستخدم (أونلاين أم لا)
  Future<bool> checkUserOnlineStatus(String userId) async {
    try {
      final response = await _dio.get('/Chat/online/$userId');
      if (response.statusCode == 200) {
        return response.data['data']['isOnline'] ?? false;
      }
      return false;
    } catch (e) {
      log('❌ Error checking online status', name: 'ChatService', error: e);
      return false;
    }
  }

  // =========================================================
  // 2. SignalR Connection (Real-time)
  // =========================================================

  /// بناء الاتصال وتجهيز الـ Listeners
  Future<void> initConnection({
    required String baseUrl,
    required String accessToken,
  }) async {
    // إعداد الـ Logger لتتبع حالة الاتصال
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      log('${rec.time}: ${rec.message}', name: 'SignalR ${rec.level.name}');
    });

    final hubUrl = '$baseUrl/hubs/chat';

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
            transport: HttpTransportType.WebSockets,
            requestTimeout:
                15000, // 15 ثانية بالمللي ثانية لإنهاء ريكويست الـ Handshake بنجاح
          ),
        )
        .withAutomaticReconnect()
        .build();

    // 🚀 زيادة وقت الـ Server Timeout الإجمالي للـ Hub لضمان عدم الفصل المفاجئ
    _hubConnection?.serverTimeoutInMilliseconds = 30000; // 30 ثانية

    // ربط الـ Events اللي جاية من الباك إند بالـ Handlers بتاعتك زي ما هي بالضبط
    _hubConnection?.on('ReceiveMessage', _handleReceiveMessage);
    _hubConnection?.on('UserOnline', _handleUserOnline);
    _hubConnection?.on('UserOffline', _handleUserOffline);
    _hubConnection?.on('UserTyping', _handleUserTyping);

    try {
      await _hubConnection?.start();
      log('✅ SignalR Connected Successfully to $hubUrl', name: 'ChatService');
    } catch (e) {
      log('❌ SignalR Connection Error', name: 'ChatService', error: e);
      throw Exception('Failed to connect to chat server');
    }
  }

  Future<void> sendMessage(String otherUserId, String content) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        // 🚨 استخدمنا send بدل invoke
        await _hubConnection?.send('SendMessage', args: [otherUserId, content]);
      } catch (e) {
        log('⚠️ Send message error: $e', name: 'ChatService');
      }
    }
  }

  /// إرسال حالة "يكتب الآن..." للـ Hub
  Future<void> sendTyping(String otherUserId, bool isTyping) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        await _hubConnection?.send('Typing', args: [otherUserId, isTyping]);
      } catch (e) {
        log('⚠️ Typing status error: $e', name: 'ChatService');
      }
    }
  }

  /// إنهاء الاتصال
  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _hubConnection = null;
    log('🔌 SignalR Disconnected', name: 'ChatService');
  }

  // =========================================================
  // 3. Private Handlers (لمعالجة البيانات القادمة من السيرفر)
  // =========================================================

  void _handleReceiveMessage(List<Object?>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      final messageData = arguments[0] as Map<String, dynamic>;
      onMessageReceived?.call(messageData);
    }
  }

  void _handleUserOnline(List<Object?>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      final payload = arguments[0] as Map<String, dynamic>;
      final userId =
          payload['userId']?.toString() ?? payload['UserId']?.toString() ?? '';
      onUserOnlineStatusChanged?.call(userId, true);
    }
  }

  void _handleUserOffline(List<Object?>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      final payload = arguments[0] as Map<String, dynamic>;
      final userId =
          payload['userId']?.toString() ?? payload['UserId']?.toString() ?? '';
      onUserOnlineStatusChanged?.call(userId, false);
    }
  }

  void _handleUserTyping(List<Object?>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      final payload = arguments[0] as Map<String, dynamic>;
      final senderId =
          payload['senderId']?.toString() ??
          payload['SenderId']?.toString() ??
          '';
      final isTyping = payload['isTyping'] ?? payload['IsTyping'] ?? false;
      onUserTypingStatusChanged?.call(senderId, isTyping);
    }
  }
}
