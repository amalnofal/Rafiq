import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/animated_input_area.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/community/data/models/comment_model.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/widgets/post_item.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_item.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_state_banner.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late PostModel _currentPost;
  bool _isLoadingDetails = false;

  List<CommentModel> _comments = [];
  bool _isLoadingComments = true;
  bool _isFetchingMoreComments = false;
  int _currentPage = 1;
  bool _hasMoreComments = true;

  bool _isEditing = false;
  String? _commentToEditId;
  @override
  void initState() {
    super.initState();
    _currentPost = widget.post;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPageData();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        _loadMoreComments();
      }
    });
  }

  Future<void> _initPageData() async {
    await _fetchFullPostData();
    if (mounted) {
      await _fetchInitialComments();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchFullPostData() async {
    if (!mounted) return;
    setState(() => _isLoadingDetails = true);

    final provider = context.read<CommunityProvider>();
    final fullPost = await provider.getPostDetails(_currentPost.id);

    if (mounted) {
      setState(() {
        if (fullPost != null) {
          _currentPost = fullPost;
        }
        _isLoadingDetails = false;
      });
    }
  }

  Future<void> _fetchInitialComments() async {
    if (!mounted) return;
    setState(() => _isLoadingComments = true);

    final provider = context.read<CommunityProvider>();
    final realComments = await provider.getComments(_currentPost.id, page: 1);

    if (mounted) {
      setState(() {
        _comments = realComments;
        _isLoadingComments = false;
        _currentPage = 1;
        _hasMoreComments = realComments.length >= 20;
      });
    }
  }

  Future<void> _loadMoreComments() async {
    if (_isFetchingMoreComments || !_hasMoreComments) return;
    setState(() => _isFetchingMoreComments = true);

    _currentPage++;
    final provider = context.read<CommunityProvider>();
    final realComments = await provider.getComments(
      _currentPost.id,
      page: _currentPage,
    );

    if (mounted) {
      setState(() {
        if (realComments.isEmpty || realComments.length < 20) {
          _hasMoreComments = false;
        }
        _comments.addAll(realComments);
        _isFetchingMoreComments = false;
      });
    }
  }

  Future<void> _handleSend() async {
    if (_commentController.text.trim().isEmpty) return;
    final text = _commentController.text.trim();
    final provider = context.read<CommunityProvider>();
    final user = context.read<UserProvider>().user;

    FocusScope.of(context).unfocus();

    if (_isEditing && _commentToEditId != null) {
      final success = await provider.editComment(_commentToEditId!, text);
      if (success && mounted) {
        setState(() {
          final index = _comments.indexWhere((c) => c.id == _commentToEditId);
          if (index != -1) {
            _comments[index] = _comments[index].copyWith(
              content: text,
              isEdited: true,
            );
          }
          _resetCommentInputState();
        });
      }
    } else {
      _commentController.clear();

      // نبني كومنت وهمي ليظهر فوراً في الواجهة
      final tempComment = CommentModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        content: text,
        createdAt: DateTime.now(),
        user: user!,
        isMine: true,
      );

      // تحديث الواجهة فوراً (إضافة الكومنت وزيادة العدد)
      setState(() {
        _comments = [tempComment, ..._comments];
        _currentPost = _currentPost.copyWith(
          commentsCount: _currentPost.commentsCount + 1,
        );
      });
      provider.updateLocalPost(_currentPost);

      final newComment = await provider.addComment(_currentPost.id, text);

      if (newComment != null) {
        setState(() {
          _comments = _comments
              .map((c) => c.id == tempComment.id ? newComment : c)
              .toList();
        });
      } else {
        log("Comment added successfully");
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final provider = context.read<CommunityProvider>();
    final success = await provider.deleteComment(commentId);
    if (success && mounted) {
      setState(() {
        _comments.removeWhere((c) => c.id == commentId);
        _currentPost = _currentPost.copyWith(
          commentsCount: (_currentPost.commentsCount - 1).clamp(0, 999999),
        );
        provider.updateLocalPost(_currentPost);
      });
    }
  }

  void _resetCommentInputState() {
    setState(() {
      _commentController.clear();
      _isEditing = false;
      _commentToEditId = null;
    });
  }

  void _showCommentOptions(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SvgPicture.asset("assets/icons/edit.svg", width: 20.w),
                title: Text(
                  AppLocalizations.of(bottomSheetContext)!.editAction,
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  setState(() {
                    _isEditing = true;
                    _commentToEditId = comment.id;
                    _commentController.text = comment.content;
                  });
                  _focusNode.requestFocus();
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/trash.svg",
                  width: 20.w,
                ),
                title: Text(
                  AppLocalizations.of(bottomSheetContext)!.deleteAction,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  showDialog(
                    context: context,
                    builder: (dialogContext) => CustomInfoDialog(
                      title: AppLocalizations.of(
                        dialogContext,
                      )!.deleteCommentTitle,
                      description: AppLocalizations.of(
                        dialogContext,
                      )!.deleteCommentMessage,
                      confirmBtnText: AppLocalizations.of(
                        dialogContext,
                      )!.deleteAction,
                      mainColor: Colors.red,
                      onConfirm: () {
                        Navigator.pop(dialogContext);
                        _deleteComment(comment.id);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await _fetchFullPostData();
    await _fetchInitialComments();
    if (!mounted) return;
    await context.read<CommunityProvider>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();

    final displayPost = provider.posts.firstWhere(
      (p) => p.id == _currentPost.id,
      orElse: () => _currentPost,
    );

    return RafiqScaffold(
      padding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(size: 24.sp),
        toolbarHeight: 50.h,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoadingDetails)
              LinearProgressIndicator(
                minHeight: 2.h,
                color: Theme.of(context).colorScheme.primary,
              ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: Theme.of(context).colorScheme.primary,
                child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  children: [
                    // البوست
                    PostItem(
                      post: displayPost,
                      author: displayPost.user,
                      timeAgo: DateHelper.timeAgoShort(
                        displayPost.createdAt,
                        context,
                      ),
                      postText: displayPost.text,
                      categories: displayPost.categories,
                      likesCount: displayPost.likesCount,
                      commentsCount: displayPost.commentsCount,
                      postMedia: displayPost.media,
                      onDelete: () => Navigator.pop(context),
                      onEdit: (updatedPost) {
                        setState(() {
                          _currentPost = updatedPost;
                        });
                      },
                    ),
                    Divider(thickness: 2.h),
                    SizedBox(height: 16.h),

                    // التعليقات
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXS,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.padding,
                            ),
                            child: Text(
                              context.l10n.commentsWithCount(_comments.length),
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          if (_isLoadingComments)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (_comments.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  context.l10n.firstCommentPlaceholder,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            )
                          else
                            ..._comments.map((comment) {
                              final isMyComment = comment.isMine;

                              return CommentItem(
                                comment: comment,
                                onLongPress: isMyComment
                                    ? () => _showCommentOptions(comment)
                                    : null,
                              );
                            }),

                          if (_isFetchingMoreComments)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(thickness: 2.h),

            if (_isEditing)
              CommentStatusBanner(
                text: AppLocalizations.of(context)!.editingCommentHint,
                onCancel: _resetCommentInputState,
              ),

            // حقل إدخال التعليق
            AnimatedInputArea(
              controller: _commentController,
              focusNode: _focusNode,
              maxLines: 3,
              hintText: context.l10n.writeCommentHint,
              textDirection: ArabicToEnglishNumbersFormatter.getTextDirection(
                _commentController.text,
              ),
              onChanged: (text) => setState(() {}),
              onSend: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
