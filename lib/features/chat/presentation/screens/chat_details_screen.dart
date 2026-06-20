import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/animated_input_area.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:rafiq/features/profile/presentation/pages/profile_screen.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/chat_shimmer_loading.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhotoUrl;

  const ChatDetailsScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserPhotoUrl,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().startChatSession(widget.otherUserId);
    _messageController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatCubit>().sendMessage(widget.otherUserId, text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // دالة لمقارنة إذا كان التاريخين في نفس اليوم
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // دالة لرسم فاصل التاريخ (اليوم، أمس، أو التاريخ كامل)
  Widget _buildDateSeparator(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(messageDate).inDays;

    String dateText;
    if (difference == 0) {
      dateText = context.l10n.today;
    } else if (difference == 1) {
      dateText = context.l10n.yesterday;
    } else {
      // صيغة التاريخ العادية لباقي الأيام
      dateText =
          "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        dateText,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final basicUserModel = UserModel(
              id: widget.otherUserId,
              firstName: widget.otherUserName,
              lastName: '',
              email: '',
              role: UserType.petOwner,
              photoUrl: widget.otherUserPhotoUrl,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(user: basicUserModel, isMe: false),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.r),
                width: 45.r,
                height: 45.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    width: 2.w,
                  ),
                ),
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.grey[100],
                  onBackgroundImageError: (exception, stackTrace) {
                    debugPrint(
                      "⚠️ فشل تحميل الصورة، تم استخدام الصورة البديلة.",
                    );
                  },
                  backgroundImage:
                      widget.otherUserPhotoUrl != null &&
                          widget.otherUserPhotoUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(
                          widget.otherUserPhotoUrl!,
                          cacheKey: widget.otherUserPhotoUrl!.contains('?')
                              ? widget.otherUserPhotoUrl!.split('?').first
                              : widget.otherUserPhotoUrl!,
                        )
                      : const AssetImage("assets/images/user_placeholder.jpg")
                            as ImageProvider,
                ),
              ),
              SizedBox(width: 12.w),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  bool isOnline = false;
                  bool isTyping = false;

                  if (state is ChatMessagesLoaded) {
                    isOnline = state.isOtherUserOnline;
                    isTyping = state.isOtherUserTyping;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherUserName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // إظهار "يكتب الآن..." أو "أونلاين"
                      if (isTyping)
                        Text(
                          context.l10n.isTyping,
                          style: Theme.of(context).textTheme.labelSmall!,
                        )
                      else if (isOnline)
                        Text(
                          context.l10n.online,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatMessagesLoaded) _scrollToBottom();
              },
              builder: (context, state) {
                if (state is ChatLoading) return const ChatShimmerLoading();

                if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 60.sp),
                        SizedBox(height: 16.h),
                        Text(context.l10n.unexpectedError),
                        SizedBox(height: 24.h),
                        CustomButton(
                          title: context.l10n.retryBtn,
                          onPressed: () => context
                              .read<ChatCubit>()
                              .startChatSession(widget.otherUserId),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ChatMessagesLoaded) {
                  final messages = state.messages;
                  final reversedMessages = messages.reversed.toList();

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: EdgeInsets.all(AppDimensions.padding),
                    itemCount: reversedMessages.length,
                    itemBuilder: (context, index) {
                      final message = reversedMessages[index];
                      final currentMessageDate = message.sentAt.toLocal();

                      bool showDateSeparator = false;

                      if (index == reversedMessages.length - 1) {
                        showDateSeparator = true;
                      } else {
                        final previousMessageInTime =
                            reversedMessages[index + 1];
                        final previousMessageDate = previousMessageInTime.sentAt
                            .toLocal();

                        if (!_isSameDay(
                          currentMessageDate,
                          previousMessageDate,
                        )) {
                          showDateSeparator = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDateSeparator)
                            _buildDateSeparator(currentMessageDate, context),

                          ChatBubble(
                            message: message.content,
                            time: TimeOfDay.fromDateTime(
                              currentMessageDate,
                            ).format(context),
                            isMe: message.senderId != widget.otherUserId,
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          Container(
            color: Theme.of(context).cardColor,
            child: AnimatedInputArea(
              controller: _messageController,
              hintText: context.l10n.writeMessageHint,
              textDirection: ArabicToEnglishNumbersFormatter.getTextDirection(
                _messageController.text,
              ),
              onChanged: (text) {
                setState(() {});
                context.read<ChatCubit>().notifyTyping(widget.otherUserId);
              },
              onSend: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
