import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_input_area.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_item.dart';
import 'package:rafiq/features/community/presentation/widgets/comment_state_banner.dart';
import 'package:rafiq/features/community/presentation/widgets/empty_comments_view.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CommentsBottomSheet extends StatefulWidget {
  const CommentsBottomSheet({super.key});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();

  // State
  int? _replyingToCommentIndex;
  String? _replyingToUserName;
  bool _isEditing = false;
  int? _editingParentIndex;
  int? _editingReplyIndex;

  List<Map<String, dynamic>> comments = [];

  @override
  void dispose() {
    _commentController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  // --- Logic ---
  void _handleSend() {
    if (_commentController.text.trim().isEmpty) return;
    if (_isEditing) {
      _updateComment();
    } else {
      _addComment();
    }
  }

  void _addComment() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;
    if (currentUser == null) return;

    final newComment = {
      "name": currentUser.fullName,
      "image": currentUser.photoUrl ?? "",
      "text": _commentController.text,
      "time": DateHelper.timeAgoShort(DateTime.now(), context),
      "isLiked": false,
      "likesCount": 0,
      "isEdited": false,
    };

    setState(() {
      if (_replyingToCommentIndex != null) {
        comments[_replyingToCommentIndex!]['replies'].add(newComment);
      } else {
        newComment['replies'] = [];
        comments.add(newComment);
      }
      _resetState();
    });
    FocusScope.of(context).unfocus();
  }

  void _updateComment() {
    setState(() {
      if (_editingReplyIndex != null) {
        var reply =
            comments[_editingParentIndex!]['replies'][_editingReplyIndex!];
        reply['text'] = _commentController.text;
        reply['isEdited'] = true;
      } else {
        var comment = comments[_editingParentIndex!];
        comment['text'] = _commentController.text;
        comment['isEdited'] = true;
      }
      _resetState();
    });
    FocusScope.of(context).unfocus();
  }

  void _deleteComment(int parentIndex, int? replyIndex) {
    setState(() {
      if (replyIndex != null) {
        comments[parentIndex]['replies'].removeAt(replyIndex);
      } else {
        comments.removeAt(parentIndex);
      }
    });
  }

  void _resetState() {
    setState(() {
      _commentController.clear();
      _replyingToCommentIndex = null;
      _replyingToUserName = null;
      _isEditing = false;
      _editingParentIndex = null;
      _editingReplyIndex = null;
    });
  }

  void _onReplyTap(int index, String name) {
    setState(() {
      _isEditing = false;
      _replyingToCommentIndex = index;
      _replyingToUserName = name;
    });
    FocusScope.of(context).requestFocus(_replyFocusNode);
  }

  void _startEditing(int parentIndex, int? replyIndex) {
    setState(() {
      _isEditing = true;
      _editingParentIndex = parentIndex;
      _editingReplyIndex = replyIndex;
      _replyingToUserName = null;
      _replyingToCommentIndex = null;

      if (replyIndex != null) {
        _commentController.text =
            comments[parentIndex]['replies'][replyIndex]['text'];
      } else {
        _commentController.text = comments[parentIndex]['text'];
      }
    });
    FocusScope.of(context).requestFocus(_replyFocusNode);
  }

  void _toggleLike(Map<String, dynamic> item) {
    setState(() {
      bool isLiked = item['isLiked'];
      item['isLiked'] = !isLiked;
      item['likesCount'] += isLiked ? -1 : 1;
    });
  }

  void _showOptions(int parentIndex, int? replyIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SvgPicture.asset("assets/icons/edit.svg", width: 20.w),
                title: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(AppLocalizations.of(context)!.editAction),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _startEditing(parentIndex, replyIndex);
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/trash.svg",
                  width: 20.w,
                ),
                title: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    AppLocalizations.of(context)!.deleteAction,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomInfoDialog(
                        title: AppLocalizations.of(context)!.deleteCommentTitle,
                        description: AppLocalizations.of(
                          context,
                        )!.deleteCommentMessage,
                        confirmBtnText: AppLocalizations.of(
                          context,
                        )!.deleteAction,
                        mainColor: Colors.red,
                        onConfirm: () {
                          _deleteComment(parentIndex, replyIndex);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 0.9.sh,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // شرطة السحب اللي فوق
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.grey[300],
                  ),
                ),
              ),

              // الكومنتات
              Expanded(
                child: comments.isEmpty
                    ? const EmptyCommentsView()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        itemCount: comments.length,
                        itemBuilder: (context, index) =>
                            _buildCommentTree(index),
                      ),
              ),
              const Divider(height: 1),
              if (_replyingToUserName != null || _isEditing)
                CommentStatusBanner(
                  text: _isEditing
                      ? AppLocalizations.of(context)!.editingCommentHint
                      : "${AppLocalizations.of(context)!.replyingToHint} $_replyingToUserName",
                  onCancel: _resetState,
                ),

              CommentInputArea(
                controller: _commentController,
                focusNode: _replyFocusNode,
                onSend: _handleSend,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentTree(int index) {
    final comment = comments[index];
    final replies = comment['replies'] as List;

    final currentUser = Provider.of<UserProvider>(context, listen: false).user;

    bool isMyComment(Map<String, dynamic> item) {
      return currentUser != null && item['name'] == currentUser.fullName;
    }

    return Column(
      children: [
        // الكومنت الرئيسي
        CommentItem(
          commentData: comment,
          isReply: false,
          onReplyTap: () => _onReplyTap(index, comment['name']),
          onLikeTap: () => _toggleLike(comment),
          onLongPress: isMyComment(comment)
              ? () => _showOptions(index, null)
              : null,
          isReplyingToThis: _replyingToCommentIndex == index,
        ),

        // الردود
        if (replies.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 35.w, top: 4.h),
            child: Column(
              children: replies.asMap().entries.map((entry) {
                final replyIndex = entry.key;
                final reply = entry.value;

                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: CommentItem(
                    commentData: reply,
                    isReply: true,
                    onReplyTap: () => _onReplyTap(index, reply['name']),
                    onLikeTap: () => _toggleLike(reply),
                    onLongPress: isMyComment(reply)
                        ? () => _showOptions(index, replyIndex)
                        : null,
                    isReplyingToThis: false,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
