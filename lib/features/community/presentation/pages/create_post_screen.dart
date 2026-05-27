import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/widgets/post_categories_selector.dart';
import 'package:rafiq/features/community/presentation/widgets/post_input_area.dart';
import 'package:rafiq/features/community/presentation/widgets/post_tips_card.dart';
import 'package:rafiq/features/community/presentation/widgets/post_user_header.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/core/controller/community_provider.dart';

class CreatePostScreen extends StatefulWidget {
  final PostModel? postToEdit;

  const CreatePostScreen({super.key, this.postToEdit});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();

  final List<File> _selectedImages = [];
  List<PostMedia> _existingMedia = [];
  final List<int> _mediaIdsToRemove = [];

  final List<int> _selectedCategoryIds = [];

  @override
  void initState() {
    super.initState();

    if (widget.postToEdit != null) {
      final post = widget.postToEdit!;
      _postController.text = post.text;
      _selectedCategoryIds.addAll(post.categories.map((c) => c.id));
      // جلب الميديا القديمة
      _existingMedia = List.from(post.media);
    }

    _postController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Map<String, bool> _getCategoryBooleans(List<int> selectedIds) {
    return {
      "isHealthAndCare": selectedIds.contains(1),
      "isNutritionAndFood": selectedIds.contains(2),
      "isTrainingAndBehavior": selectedIds.contains(3),
      "isGroomingAndAppearances": selectedIds.contains(4),
      "isTravelAndTransport": selectedIds.contains(5),
      "isAdoptionAndRescue": selectedIds.contains(6),
      "isStoriesAndExperiences": selectedIds.contains(7),
      "isUpbringingAndParenting": selectedIds.contains(8),
    };
  }

  Future<void> _handlePostAction({
    required bool isEditing,
    required UserProvider userProvider,
  }) async {
    final provider = context.read<CommunityProvider>();

    final categoryBooleans = _getCategoryBooleans(_selectedCategoryIds);

    final selectedCategories = _selectedCategoryIds
        .map((id) => PostCategory.fromId(id))
        .toList();

    // ================== حالة التعديل ==================
    if (isEditing) {
      final success = await provider.updatePost(
        postId: widget.postToEdit!.id,
        contentText: _postController.text.trim(),
        newMediaFiles: _selectedImages.isNotEmpty ? _selectedImages : null,
        categories: categoryBooleans,
        mediaIdsToRemove: _mediaIdsToRemove.isNotEmpty
            ? _mediaIdsToRemove
            : null,
      );

      if (!mounted) return;

      if (success) {
        // تحديث الموديل الوهمي عشان يظهر في الشاشة فوراً
        List<PostMedia> updatedMedia = [
          ..._existingMedia,
          ..._selectedImages.asMap().entries.map(
            (e) => PostMedia(id: e.key, url: e.value.path),
          ),
        ];

        final updatedPost = widget.postToEdit!.copyWith(
          text: _postController.text.trim(),
          categories: selectedCategories,
          media: updatedMedia,
        );

        Navigator.of(context).pop(updatedPost);
      } else {
        showSnackBar(context, context.l10n.unexpectedError, isError: true);
      }
    }
    // ================== حالة الإنشاء ==================
    else {
      final currentUser = userProvider.user;
      if (currentUser == null) return;

      // تجهيز الميديا الوهمية عشان تظهر في الشاشة فوراً
      List<PostMedia> tempMedia = _selectedImages
          .asMap()
          .entries
          .map((e) => PostMedia(id: e.key, url: e.value.path))
          .toList();

      final tempPost = PostModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        userId: currentUser.id,
        user: currentUser,
        text: _postController.text.trim(),
        categories: selectedCategories,
        media: tempMedia,
        isUploading: true,
      );

      // نبعت البوست يترفع في الخلفية
      provider.createPostInBackground(
        tempPost: tempPost,
        contentText: _postController.text.trim(),
        mediaFiles: _selectedImages,
        categories: categoryBooleans,
      );

      // نقفل الشاشة فوراً
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.user;
    final isEditing = widget.postToEdit != null;

    final isLoading = context.watch<CommunityProvider>().isActionLoading;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool hasContent =
        _postController.text.trim().isNotEmpty ||
        _selectedImages.isNotEmpty ||
        _existingMedia.isNotEmpty;

    final bool hasCategory = _selectedCategoryIds.isNotEmpty;
    final bool isButtonEnabled = hasContent && hasCategory;

    return Stack(
      children: [
        RafiqScaffold(
          appBar: AppBar(
            title: Text(
              isEditing
                  ? AppLocalizations.of(context)!.editPost
                  : AppLocalizations.of(context)!.newPostTitle,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: CustomButton(
                  title: isEditing
                      ? AppLocalizations.of(context)!.save
                      : AppLocalizations.of(context)!.postBtn,
                  height: 35.h,
                  width: 80.w,
                  radius: 50.r,
                  elevation: 0,
                  onPressed: (isButtonEnabled && !isLoading)
                      ? () => _handlePostAction(
                          isEditing: isEditing,
                          userProvider: userProvider,
                        )
                      : null,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostUserHeader(user: currentUser),
                SizedBox(height: 20.h),

                // 🚨 الـ Input Area الجديد
                PostInputArea(
                  controller: _postController,
                  selectedImages: _selectedImages,
                  existingMedia: _existingMedia,
                  onImageAdded: (file) {
                    if (!mounted) return;
                    setState(() {
                      _selectedImages.add(file);
                    });
                  },
                  onNewImageRemoved: (index) {
                    if (!mounted) return;
                    setState(() {
                      _selectedImages.removeAt(index);
                    });
                  },
                  onExistingImageRemoved: (index) {
                    if (!mounted) return;
                    setState(() {
                      _mediaIdsToRemove.add(_existingMedia[index].id);
                      _existingMedia.removeAt(index);
                    });
                  },
                ),

                SizedBox(height: 16.h),

                PostCategoriesSelector(
                  selectedIds: _selectedCategoryIds,
                  onToggle: (id) {
                    if (!mounted) return;

                    setState(() {
                      if (_selectedCategoryIds.contains(id)) {
                        _selectedCategoryIds.remove(id);
                      } else {
                        _selectedCategoryIds.add(id);
                      }
                    });
                  },
                ),

                SizedBox(height: 20.h),

                const PostTipsCard(),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),

        if (isLoading) const Positioned.fill(child: LoadingOverlay()),
      ],
    );
  }
}
