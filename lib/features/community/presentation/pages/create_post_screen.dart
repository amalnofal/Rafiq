import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/widgets/choose_pet_card.dart';
import 'package:rafiq/features/community/presentation/widgets/post_categories_selector.dart';
import 'package:rafiq/features/community/presentation/widgets/post_input_area.dart';
import 'package:rafiq/features/community/presentation/widgets/post_tips_card.dart';
import 'package:rafiq/features/community/presentation/widgets/post_user_header.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CreatePostScreen extends StatefulWidget {
  final PostModel? postToEdit;

  const CreatePostScreen({super.key, this.postToEdit});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;

  String? _selectedPetName;
  final List<int> _selectedCategoryIds = [];

  final List<Map<String, dynamic>> myPets = [
    {"name": "ماكس", "emoji": "🐕"},
    {"name": "لونا", "emoji": "🐱"},
    {"name": "بندق", "emoji": "🐰"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.postToEdit != null) {
      final post = widget.postToEdit!;
      _postController.text = post.text;
      _selectedCategoryIds.addAll(post.categories.map((c) => c.id));
      _existingImageUrl = post.imageUrl;
    }
    _postController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.user;
    final isEditing = widget.postToEdit != null;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    bool hasContent =
        _postController.text.trim().isNotEmpty ||
        _selectedImage != null ||
        (_existingImageUrl != null && _existingImageUrl!.isNotEmpty);

    bool hasCategory = _selectedCategoryIds.isNotEmpty;
    bool isButtonEnabled = hasContent && hasCategory;

    return RafiqScaffold(
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
              onpressed: isButtonEnabled
                  ? () {
                      final selectedCategories = _selectedCategoryIds
                          .map((id) => PostCategory.fromId(id))
                          .toList();

                      final newPost = PostModel(
                        id: isEditing ? widget.postToEdit!.id : '',
                        createdAt: isEditing
                            ? widget.postToEdit!.createdAt
                            : DateTime.now(),
                        isEdited: isEditing,
                        userId: currentUser.id,
                        user: currentUser,
                        text: _postController.text.trim(),
                        categories: selectedCategories,
                        imageUrl: _selectedImage?.path ?? _existingImageUrl,
                        likesCount: isEditing
                            ? widget.postToEdit!.likesCount
                            : 0,
                        commentsCount: isEditing
                            ? widget.postToEdit!.commentsCount
                            : 0,
                        isLiked: isEditing ? widget.postToEdit!.isLiked : false,
                      );

                      showSnackBar(
                        context,
                        isEditing
                            ? "تم تعديل المنشور بنجاح"
                            : AppLocalizations.of(context)!.postCreatedSuccess,
                      );

                      Navigator.pop(context, newPost);
                    }
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

            PostInputArea(
              controller: _postController,
              selectedImage: _selectedImage,
              existingImageUrl: _existingImageUrl,

              onImageSelected: (file) {
                setState(() {
                  _selectedImage = file;
                });
              },
              onImageRemoved: () {
                setState(() {
                  _selectedImage = null;
                  _existingImageUrl = null;
                });
              },
            ),

            SizedBox(height: 16.h),

            PostCategoriesSelector(
              selectedIds: _selectedCategoryIds,
              onToggle: (id) {
                setState(() {
                  if (_selectedCategoryIds.contains(id)) {
                    _selectedCategoryIds.remove(id);
                  } else {
                    _selectedCategoryIds.add(id);
                  }
                });
              },
            ),

            SizedBox(height: 16.h),

            ChoosePetCard(
              pets: myPets,
              selectedPetName: _selectedPetName,
              onPetSelected: (name) {
                setState(() {
                  if (_selectedPetName == name) {
                    _selectedPetName = null;
                  } else {
                    _selectedPetName = name;
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
    );
  }
}
