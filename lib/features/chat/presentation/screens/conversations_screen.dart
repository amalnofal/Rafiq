import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rafiq/features/chat/presentation/screens/chat_details_screen.dart';
import 'package:rafiq/features/chat/presentation/widgets/conversation_shimmer.dart';
import '../widgets/conversation_tile.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      appBar: AppBar(title: Text(context.l10n.conversationsTitle)),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      body: Stack(
        children: [
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return const ConversationShimmer();
              }

              if (state is ChatError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.unexpectedError,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        title: context.l10n.retryBtn,
                        onPressed: () =>
                            context.read<ChatCubit>().getConversations(),
                      ),
                    ],
                  ),
                );
              }

              if (state is ConversationsLoaded) {
                final conversations = state.conversations;

                if (conversations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.noConversationsYet,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ChatCubit>().getConversations();
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: conversations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final isUserOnline = context
                          .read<ChatCubit>()
                          .onlineUsers
                          .contains(conversation.otherUserId.toString());

                      final isUserTyping = context
                          .read<ChatCubit>()
                          .typingUsers
                          .contains(conversation.otherUserId.toString());

                      return ConversationTile(
                        name: conversation.fullName,
                        lastMessage: conversation.lastMessageContent,
                        time: DateHelper.timeAgo(
                          conversation.lastMessageSentAt,
                          context,
                        ),
                        isOnline: isUserOnline,
                        isTyping: isUserTyping,
                        photoUrl: conversation.photoUrl,
                        onTap: () {
                          final chatCubit = context.read<ChatCubit>();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (innerContext) => BlocProvider.value(
                                value: chatCubit,
                                child: ChatDetailsScreen(
                                  otherUserId: conversation.otherUserId
                                      .toString(),
                                  otherUserName: conversation.fullName,
                                  otherUserPhotoUrl: conversation.photoUrl,
                                ),
                              ),
                            ),
                          ).then((_) {
                            chatCubit.leaveChatSession();
                          });
                        },
                      );
                    },
                  ),
                );
              }

              return const ConversationShimmer();
            },
          ),
        ],
      ),
    );
  }
}
