import 'package:flutter/material.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';

class CommunityProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PostModel> get posts => _posts;

  void setPosts(List<PostModel> newPosts) {
    _posts = newPosts;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ==========================================================
  // 2. الدوال (Logic)
  // ==========================================================

  // ✅ دالة جلب البوستات (محاكاة للسيرفر)
  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // محاكاة تأخير الشبكة (ثانية واحدة)
      await Future.delayed(const Duration(seconds: 1));

      // هنا المفروض نملأ _posts بالداتا اللي جاية من الـ API
      // _posts = incomingData;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "حدث خطأ أثناء تحميل المنشورات";
      notifyListeners();
    }
  }

  // دالة إضافة بوست جديد
  void addPost(PostModel post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  // دالة حذف بوست
  void deletePost(PostModel post) {
    _posts.removeWhere((element) => element.id == post.id);
    notifyListeners();
  }

  // دالة تعديل بوست
  void updatePost(PostModel updatedPost) {
    final index = _posts.indexWhere((element) => element.id == updatedPost.id);

    if (index != -1) {
      _posts[index] = updatedPost;
      notifyListeners();
    }
  }
}
