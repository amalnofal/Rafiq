import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/animated_input_area.dart';
import 'package:rafiq/features/community/data/models/comment_model.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_item.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_shimmer_item.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_state_banner.dart';
import 'package:rafiq/features/community/presentation/widgets/empty_comments_view.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  const CommentsBottomSheet({super.key, required this.postId});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ScrollController? _scrollController;

  List<CommentModel> _comments = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  bool _isEditing = false;
  CommentModel? _commentToEdit;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialComments() async {
    final provider = context.read<CommunityProvider>();

    final data = await provider.getComments(widget.postId, page: 1);

    if (mounted) {
      setState(() {
        _comments = data;
        _isLoading = false;
        if (data.length < 20) _hasMoreData = false;
      });
    }
  }

  Future<void> _loadMoreComments() async {
    if (_isFetchingMore || !_hasMoreData) return;
    setState(() => _isFetchingMore = true);

    _currentPage++;
    final provider = context.read<CommunityProvider>();
    final data = await provider.getComments(widget.postId, page: _currentPage);

    if (mounted) {
      setState(() {
        if (data.isEmpty || data.length < 20) _hasMoreData = false;
        _comments.addAll(data);
        _isFetchingMore = false;
      });
    }
  }

  Future<void> _handleSend() async {
    if (_commentController.text.trim().isEmpty) return;

    final text = _commentController.text.trim();
    final provider = context.read<CommunityProvider>();
    final user = context.read<UserProvider>().user;

    FocusScope.of(context).unfocus();

    if (_isEditing && _commentToEdit != null) {
      final success = await provider.editComment(_commentToEdit!.id, text);
      if (success && mounted) {
        final index = _comments.indexWhere((c) => c.id == _commentToEdit!.id);
        if (index != -1) {
          setState(() {
            _comments[index] = _commentToEdit!.copyWith(
              content: text,
              isEdited: true,
            );
            _resetState();
          });
        }
      } else {
        if (mounted) {
          showSnackBar(context, context.l10n.unexpectedError, isError: true);
        }
      }
    } else {
      _commentController.clear();

      // 1. بناء كومنت وهمي عشان يظهر في الـ UI فوراً
      final tempComment = CommentModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        content: text,
        createdAt: DateTime.now(),
        user: user!,
        isMine: true,
      );

      setState(() {
        _comments = [tempComment, ..._comments];
      });

      if (_scrollController != null && _scrollController!.hasClients) {
        _scrollController!.jumpTo(0);
      }

      // 2. إرسال الكومنت للسيرفر
      await provider.addComment(widget.postId, text);

      // 3. تحديث عدد التعليقات في الـ Bar والـ UI وتحديث القائمة بالبيانات الحقيقية
      provider.incrementCommentCount(widget.postId);
      _fetchInitialComments();
    }
  }

  Future<void> _deleteComment(CommentModel comment) async {
    final provider = context.read<CommunityProvider>();
    final success = await provider.deleteComment(comment.id);

    if (success && mounted) {
      setState(() {
        _comments.removeWhere((c) => c.id == comment.id);
      });

      provider.decrementCommentCount(widget.postId);

      showSnackBar(context, context.l10n.commentDeletedSuccessfully);
    }
  }

  void _resetState() {
    setState(() {
      _commentController.clear();
      _isEditing = false;
      _commentToEdit = null;
    });
  }

  void _showOptions(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SvgPicture.asset("assets/icons/edit.svg", width: 20.w),
                title: Text(context.l10n.editAction),
                onTap: () {
                  Navigator.pop(sheetContext);
                  setState(() {
                    _isEditing = true;
                    _commentToEdit = comment;
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
                  context.l10n.deleteAction,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog(
                    context: context,
                    builder: (dialogContext) => CustomInfoDialog(
                      title: context.l10n.deleteCommentTitle,
                      description: context.l10n.deleteCommentMessage,
                      confirmBtnText: context.l10n.deleteAction,
                      mainColor: Colors.red,
                      onConfirm: () {
                        Navigator.pop(dialogContext);
                        _deleteComment(comment);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),

          // قائمة التعليقات (قابلة للسحب)
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              // إغلاق الشاشة بأمان عندما تصل لحد الإغلاق (النص)
              if (notification.extent <= notification.minExtent + 0.02 &&
                  !_isClosing) {
                _isClosing = true;
                Future.microtask(() {
                  if (context.mounted && Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                });
              }
              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.95,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              snap: true,
              builder: (context, scrollController) {
                _scrollController = scrollController;
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      // Pagination
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 50) {
                        _loadMoreComments();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(bottom: 120.h),
                      itemCount:
                          1 + _comments.length + (_isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // أ. شريط السحب وحالة التحميل
                        if (index == 0) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Container(
                                  width: 40.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                              if (_isLoading)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 6,
                                  itemBuilder: (context, _) =>
                                      const CommentShimmerItem(),
                                ),
                              if (!_isLoading && _comments.isEmpty)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: const EmptyCommentsView(),
                                ),
                            ],
                          );
                        }

                        // ب. التعليقات
                        final commentIndex = index - 1;
                        if (commentIndex < _comments.length) {
                          final comment = _comments[commentIndex];
                          return CommentItem(
                            comment: comment,
                            onLongPress: comment.isMine
                                ? () => _showOptions(comment)
                                : null,
                          );
                        }

                        // ج. مؤشر تحميل المزيد
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. حقل الكتابة الملتصق بالأسفل
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1),
                  if (_isEditing)
                    CommentStatusBanner(
                      text: context.l10n.editingCommentHint,
                      onCancel: _resetState,
                    ),
                  AnimatedInputArea(
                    controller: _commentController,
                    focusNode: _focusNode,
                    maxLines: 3,
                    hintText: context.l10n.writeCommentHint,
                    textDirection:
                        ArabicToEnglishNumbersFormatter.getTextDirection(
                          _commentController.text,
                        ),
                    onChanged: (text) => setState(() {}),
                    onSend: _handleSend,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
