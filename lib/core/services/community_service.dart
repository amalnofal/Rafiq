import 'dart:io';
import 'package:dio/dio.dart';

class CommunityService {
  final Dio _dio;

  CommunityService(this._dio);

  Future<Response> getFeed({int pageNumber = 1, int pageSize = 50}) async {
    return await _dio.get(
      '/Post/feed',
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );
  }

  // إنشاء بوست جديد
  Future<Response> createPost({
    required String contentText,
    List<File>? mediaFiles,
    required Map<String, bool> categoriesBooleans,
  }) async {
    Map<String, dynamic> dataMap = {};
    if (contentText.isNotEmpty) {
      dataMap["ContentText"] = contentText;
    }

    dataMap.addAll(categoriesBooleans);

    FormData formData = FormData.fromMap(dataMap);

    if (mediaFiles != null && mediaFiles.isNotEmpty) {
      for (var file in mediaFiles) {
        formData.files.add(
          MapEntry(
            "MediaFiles",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    return await _dio.post('/Post/create', data: formData);
  }

  // حذف بوست
  Future<Response> deletePost(String postId) async {
    return await _dio.delete('/Post/delete/$postId');
  }

  // تعديل بوست
  Future<Response> updatePost({
    required String postId,
    required String contentText,
    List<File>? newMediaFiles,
    required Map<String, bool> categoriesBooleans,
    List<int>? mediaIdsToRemove,
  }) async {
    Map<String, dynamic> dataMap = {};
    if (contentText.isNotEmpty) dataMap["ContentText"] = contentText;
    dataMap.addAll(categoriesBooleans);

    FormData formData = FormData.fromMap(dataMap);

    if (mediaIdsToRemove != null && mediaIdsToRemove.isNotEmpty) {
      for (var id in mediaIdsToRemove) {
        formData.fields.add(MapEntry('MediaIdsToRemove', id.toString()));
      }
    }

    if (newMediaFiles != null && newMediaFiles.isNotEmpty) {
      for (var file in newMediaFiles) {
        formData.files.add(
          MapEntry(
            "NewMediaFiles",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    return await _dio.put('/Post/update/$postId', data: formData);
  }

  // like post
  Future<Response> likePost(String postId) async {
    return await _dio.post('/Post/$postId/like');
  }

  // unlike post
  Future<Response> unlikePost(String postId) async {
    return await _dio.delete('/Post/$postId/like');
  }

  // جلب تفاصيل بوست معين
  Future<Response> getPostDetails(String postId) async {
    return await _dio.get('/Post/$postId');
  }

  // جلب تعليقات بوست 
  Future<Response> getPostComments(
    String postId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    return await _dio.get(
      '/Post/$postId/comments',
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );
  }

  // إضافة تعليق
  Future<Response> addComment(String postId, String text) async {
    return await _dio.post(
      '/Post/$postId/comments',
      data: {'commentText': text},
    );
  }

  // تعديل تعليق
  Future<Response> editComment(String commentId, String text) async {
    return await _dio.put(
      '/Post/comment/$commentId',
      data: {'commentText': text},
    );
  }

  // حذف تعليق
  Future<Response> deleteComment(String commentId) async {
    return await _dio.delete('/Post/comment/$commentId');
  }
}
