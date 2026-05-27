import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/services/community_service.dart';
import 'package:rafiq/features/community/data/models/comment_model.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';

class CommunityProvider extends ChangeNotifier {
  final CommunityService _communityService;

  CommunityProvider(this._communityService);

  // ==========================================
  // المتغيرات الأساسية
  // ==========================================

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasConnectionError = false;
  bool get hasConnectionError => _hasConnectionError;

  int _currentPage = 1;
  bool _hasMoreData = true; // عشان نعرف لو السيرفر خلص البوستات
  bool _isFetchingMore = false; // عشان مانبعتش ريكويستات ورا بعض
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreData => _hasMoreData;

  // 1. دالة حفظ البوستات في الكاش
  Future<void> _savePostsToCache(List<PostModel> posts) async {
    // بنستخدم .toMap() اللي موجودة جاهزة في الموديل
    final encoded = jsonEncode(posts.map((p) => p.toMap()).toList());
    await CacheHelper.saveData(key: 'cached_posts', value: encoded);
  }

  // 2. دالة تحميل البوستات من الكاش
  Future<void> _loadPostsFromCache() async {
    final cachedData = CacheHelper.getData(key: 'cached_posts');
    if (cachedData != null) {
      try {
        final List decoded = jsonDecode(cachedData);
        // بنستخدم .fromMap() اللي موجودة جاهزة في الموديل
        _posts.addAll(decoded.map((e) => PostModel.fromMap(e)).toList());
        notifyListeners();
      } catch (e) {
        log("❌ خطأ في تحميل كاش البوستات: $e");
      }
    }
  }

  Future<void> _saveCommentsToCache(
    String postId,
    List<CommentModel> comments,
  ) async {
    final encoded = jsonEncode(comments.map((c) => c.toMap()).toList());
    await CacheHelper.saveData(key: 'cached_comments_$postId', value: encoded);
  }

  Future<List<CommentModel>> _loadCommentsFromCache(String postId) async {
    final cachedData = CacheHelper.getData(key: 'cached_comments_$postId');
    if (cachedData != null) {
      try {
        final List decoded = jsonDecode(cachedData);
        return decoded.map((e) => CommentModel.fromMap(e)).toList();
      } catch (e) {
        log("❌ خطأ في تحميل كاش الكومنتات: $e");
      }
    }
    return [];
  }

  /// ==========================================
  // 1. جلب البوستات (الصفحة الأولى)
  // ==========================================
  Future<void> fetchPosts() async {
    _errorMessage = null;
    _hasConnectionError = false;
    _currentPage = 1;
    _hasMoreData = true;

    await _loadPostsFromCache();

    if (_posts.isEmpty) _isLoading = true;
    notifyListeners();

    try {
      final response = await _communityService.getFeed(
        pageNumber: 1,
        pageSize: 10,
      );
      final List data = response.data['data'] ?? [];

      _posts.clear();
      for (var item in data) {
        _posts.add(PostModel.fromMap(item));
      }

      await _savePostsToCache(_posts);
    } catch (e) {
      _errorMessage = e.toString();
      _hasConnectionError = true;
      log("[Community Provider]: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 1.5 جلب المزيد من البوستات (Pagination)
  // ==========================================
  Future<void> loadMorePosts() async {
    if (_isFetchingMore || !_hasMoreData || _isLoading) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++; // نزود رقم الصفحة

      final response = await _communityService.getFeed(
        pageNumber: _currentPage,
        pageSize: 10,
      );

      final List data = response.data['data'] ?? [];

      if (data.isEmpty) {
        _hasMoreData = false;
      } else {
        for (var item in data) {
          _posts.add(PostModel.fromMap(item));
        }
        if (data.length < 10) _hasMoreData = false;
      }
      log(
        "✅ تم جلب المزيد من البوستات. الإجمالي: ${_posts.length} (الصفحة $_currentPage).",
      );
    } catch (e) {
      log("❌ Failed to load more posts - $e");
      _currentPage--;
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }
  // ==========================================
  // 2. إنشاء بوست
  // ==========================================

  Future<bool> createNewPost({
    required String contentText,
    List<File>? mediaFiles,
    required Map<String, bool> categories,
  }) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _communityService.createPost(
        contentText: contentText,
        mediaFiles: mediaFiles,
        categoriesBooleans: categories,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      _errorMessage = "Failed to create post";
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      log("❌ Failed to create post - $e");
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 3. تعديل بوست
  // ==========================================

  Future<bool> updatePost({
    required String postId,
    required String contentText,
    List<File>? newMediaFiles,
    required Map<String, bool> categories,
    List<int>? mediaIdsToRemove,
  }) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _communityService.updatePost(
        postId: postId,
        contentText: contentText,
        newMediaFiles: newMediaFiles,
        categoriesBooleans: categories,
        mediaIdsToRemove: mediaIdsToRemove,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }

      _errorMessage = "Failed to update post";
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      log("❌ Failed to update post - $e");
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 4. حذف بوست
  // ==========================================
  Future<bool> deletePost(PostModel post) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      // 1. حذف من السيرفر (لو حقيقي) أو محلي (لو temp)
      if (!post.id.startsWith('temp_')) {
        await _communityService.deletePost(post.id);
      }

      // 2. حذف من الليستة الأساسية في الـ Feed
      _posts.removeWhere((p) => p.id == post.id);

      // 3. الحل: حذف من الـ UserProvider فوراً!
      final userProv = getIt<UserProvider>();
      userProv.removePostLocally(post.id);

      return true;
    } catch (e) {
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // دوال الـ UI المحلية
  // ==========================================

  void addPost(PostModel post) {
    _posts.insert(0, post);
    notifyListeners();

    final userProv = getIt<UserProvider>();
    if (userProv.user != null && post.userId == userProv.user!.id) {
      userProv.addPostLocally(post);
    }
  }

  void updateLocalPost(PostModel updatedPost) {
    final index = _posts.indexWhere((p) => p.id == updatedPost.id);

    if (index != -1) {
      _posts[index] = updatedPost;
      notifyListeners();
    }

    getIt<UserProvider>().updatePostLocally(updatedPost);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ==========================================
  // 🚀 إنشاء بوست في الخلفية (شريط التحميل)
  // ==========================================
  Future<void> createPostInBackground({
    required PostModel tempPost,
    required String contentText,
    required List<File> mediaFiles,
    required Map<String, bool> categories,
  }) async {
    // 1. إضافة البوست الوهمي للواجهة فوراً (لو مش موجود)
    if (!_posts.any((p) => p.id == tempPost.id)) {
      _posts.insert(0, tempPost);
    }
    notifyListeners();

    try {
      // 3. رفع البوست للسيرفر
      final response = await _communityService.createPost(
        contentText: contentText,
        mediaFiles: mediaFiles.isNotEmpty ? mediaFiles : null,
        categoriesBooleans: categories,
      );

      // 4. تحديث حالة البوست لو نجح
      final index = _posts.indexWhere((p) => p.id == tempPost.id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (index != -1) {
          final rawData = response.data['data'] ?? response.data;

          if (rawData is Map<String, dynamic>) {
            final realPost = PostModel.fromMap(rawData);
            _posts[index] = realPost;

            getIt<UserProvider>().updatePostLocally(realPost);
          } else {
            _posts[index] = _posts[index].copyWith(isUploading: false);
            fetchPosts();
          }
          notifyListeners();
        }
      } else {
        // لو فشل
        if (index != -1) {
          _posts[index] = _posts[index].copyWith(
            isUploading: false,
            isUploadFailed: true,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      log("❌ Background Upload Failed - $e");
      final index = _posts.indexWhere((p) => p.id == tempPost.id);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          isUploading: false,
          isUploadFailed: true,
        );
        notifyListeners();
      }
    }
  }

  // ==========================================
  // 🚀 إعادة محاولة الرفع لو فشل
  // ==========================================
  Future<void> retryPostUpload(PostModel failedPost) async {
    // 1. نقلب حالة البوست لـ جاري التحميل
    final index = _posts.indexWhere((p) => p.id == failedPost.id);
    if (index != -1) {
      _posts[index] = failedPost.copyWith(
        isUploading: true,
        isUploadFailed: false,
      );
      notifyListeners();
    }

    // 2. نرجع المسارات لملفات حقيقية (Files) عشان تترفع
    List<File> mediaFiles = failedPost.media.map((m) => File(m.url)).toList();

    // 3. نجهز الكاتيجوريز
    Map<String, bool> categories = {
      "isHealthAndCare": failedPost.categories.any((c) => c.id == 1),
      "isNutritionAndFood": failedPost.categories.any((c) => c.id == 2),
      "isTrainingAndBehavior": failedPost.categories.any((c) => c.id == 3),
      "isGroomingAndAppearances": failedPost.categories.any((c) => c.id == 4),
      "isTravelAndTransport": failedPost.categories.any((c) => c.id == 5),
      "isAdoptionAndRescue": failedPost.categories.any((c) => c.id == 6),
      "isStoriesAndExperiences": failedPost.categories.any((c) => c.id == 7),
      "isUpbringingAndParenting": failedPost.categories.any((c) => c.id == 8),
    };

    // 4. نبعته يترفع تاني بنفس دالة الخلفية
    await createPostInBackground(
      tempPost: _posts[index],
      contentText: failedPost.text,
      mediaFiles: mediaFiles,
      categories: categories,
    );
  }

  // 🗑️ إلغاء الرفع تماماً
  void removeLocalPost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  // ==========================================
  // 5. تسجيل / إلغاء الإعجاب
  // ==========================================
  Future<void> toggleLike(String postId, bool isCurrentlyLiked) async {
    // 1. البحث عن البوست في الخلاصة أو البروفايل
    int feedIndex = _posts.indexWhere((p) => p.id == postId);
    final userProv = getIt<UserProvider>();
    int profileIndex =
        userProv.user?.posts?.indexWhere((p) => p.id == postId) ?? -1;

    // لو البوست مش موجود في أي مكان، نتوقف
    if (feedIndex == -1 && profileIndex == -1) return;

    // تحديد البوست الأصلي لمعرفة الأرقام الحالية
    PostModel? originalPost;
    if (feedIndex != -1) {
      originalPost = _posts[feedIndex];
    } else if (profileIndex != -1) {
      originalPost = userProv.user!.posts![profileIndex];
    }

    if (originalPost == null) return;

    // 2. إنشاء نسخة محدثة باللايك الجديد
    final updatedPost = originalPost.copyWith(
      isLiked: !isCurrentlyLiked,
      likesCount: isCurrentlyLiked
          ? (originalPost.likesCount - 1).clamp(0, 999999)
          : originalPost.likesCount + 1,
    );

    // 3. التحديث الفوري في الواجهة
    if (feedIndex != -1) {
      _posts[feedIndex] = updatedPost;
      notifyListeners();
    }

    userProv.updatePostLocally(updatedPost);

    // 4. إرسال الطلب للسيرفر في الخلفية
    try {
      if (isCurrentlyLiked) {
        await _communityService.unlikePost(postId);
      } else {
        await _communityService.likePost(postId);
      }
    } catch (e) {
      log("❌ Failed to toggle like: $e");
      if (feedIndex != -1) {
        _posts[feedIndex] = originalPost;
        notifyListeners();
      }
      userProv.updatePostLocally(originalPost);
    }
  }

  // ==========================================
  // 🚀 جلب تفاصيل بوست معين (النسخة التقيلة بالكومنتات واللايك)
  // ==========================================
  Future<PostModel?> getPostDetails(String postId) async {
    try {
      final response = await _communityService.getPostDetails(postId);

      final dynamic rawData = response.data['data'] ?? response.data;
      final fullPost = PostModel.fromMap(rawData);

      updateLocalPost(fullPost);

      return fullPost;
    } catch (e) {
      log("❌ Failed to get post details: $e");
      return null;
    }
  }

  // ==========================================
  // 🚀 عمليات التعليقات (Comments CRUD)
  // ==========================================
  Future<List<CommentModel>> getComments(String postId, {int page = 1}) async {
    try {
      final response = await _communityService.getPostComments(
        postId,
        pageNumber: page,
      );
      // log("🔍 API Response for Comments: ${jsonEncode(response.data)}");

      final List data = response.data['data'] ?? [];
      final fetchedComments = data.map((e) => CommentModel.fromMap(e)).toList();

      if (page == 1) {
        await _saveCommentsToCache(postId, fetchedComments);
      }

      return fetchedComments;
    } catch (e) {
      log("❌ Failed to load comments from server: $e");

      final cachedComments = await _loadCommentsFromCache(postId);
      if (cachedComments.isNotEmpty) {
        log("✅ تم استرجاع التعليقات من الكاش بنجاح.");
        return cachedComments;
      }

      return [];
    }
  }

  // ==========================================
  //  إضافة تعليق (قراءة بيانات السيرفر بالكامل)
  // ==========================================
  Future<CommentModel?> addComment(String postId, String text) async {
    try {
      final response = await _communityService.addComment(postId, text);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final rawData = response.data['data'] ?? response.data;

        if (rawData is Map<String, dynamic>) {
          return CommentModel.fromMap(rawData);
        }
        return null;
      }
      return null;
    } catch (e) {
      log("❌ Failed to add comment: $e");
      return null;
    }
  }

  void incrementCommentCount(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        commentsCount: _posts[index].commentsCount + 1,
      );
      notifyListeners();
    }
  }

  Future<bool> editComment(String commentId, String text) async {
    try {
      await _communityService.editComment(commentId, text);
      return true;
    } catch (e) {
      log("❌ Failed to edit comment: $e");
      return false;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    try {
      await _communityService.deleteComment(commentId);
      return true;
    } catch (e) {
      log("❌ Failed to delete comment: $e");
      return false;
    }
  }

  void decrementCommentCount(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1 && _posts[index].commentsCount > 0) {
      _posts[index] = _posts[index].copyWith(
        commentsCount: _posts[index].commentsCount - 1,
      );
      notifyListeners();
    }
  }
}
