import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ==========================================
//  مدير الذاكرة المؤقتة للفيديوهات (LRU Cache)
// بيحفظ آخر 15 فيديو عشان مايحملوش من الصفر كل شوية
// ==========================================
class VideoCacheManager {
  static final Map<String, VideoPlayerController> _cache = {};
  static final List<String> _queue = [];

  // دالة لتنظيف الذاكرة بالكامل (مهمة جداً عند تسجيل الخروج)
  static void clearAllCache() {
    for (var controller in _cache.values) {
      controller.dispose();
    }
    _cache.clear();
    _queue.clear();
  }

  static VideoPlayerController getController(String url, bool isLocal) {
    // 1. لو الكنترولر موجود في الذاكرة، نرجعه فوراً (ده اللي بيمنع التحميل التاني)
    if (_cache.containsKey(url)) {
      _queue.remove(url);
      _queue.add(url); // نخليه الأحدث عشان ماينمسحش
      return _cache[url]!;
    }

    // 2. لو مش موجود، نعمل واحد جديد
    final controller = isLocal
        ? VideoPlayerController.file(File(url))
        : VideoPlayerController.networkUrl(Uri.parse(url));

    _cache[url] = controller;
    _queue.add(url);

    // 3. حماية للميموري: لو زادوا عن 15 فيديو، ندمر أقدم واحد عشان الموبايل ميهنجش
    if (_queue.length > 15) {
      final oldestUrl = _queue.removeAt(0);
      _cache[oldestUrl]?.dispose();
      _cache.remove(oldestUrl);
    }

    return controller;
  }
}

class PostVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isLocal;
  final bool isPreview;

  const PostVideoPlayer({
    super.key,
    required this.videoUrl,
    this.isLocal = false,
    this.isPreview = false,
  });

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isMuted = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoCacheManager.getController(
      widget.videoUrl,
      widget.isLocal,
    );

    _controller.addListener(_videoErrorListener);

    if (_controller.value.isInitialized) {
      _isInitialized = true;
      if (widget.isPreview) _controller.setVolume(0);
    } else {
      _controller
          .initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
              });
              if (widget.isPreview) {
                _controller.setVolume(0);
              }
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
              debugPrint("Video Load Error: $error");
            }
          });
    }
  }

  // دالة لمراقبة أي خطأ يحصل أثناء تشغيل الفيديو
  void _videoErrorListener() {
    if (_controller.value.hasError && !_hasError) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        debugPrint(
          "Video Playback Error: ${_controller.value.errorDescription}",
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoErrorListener);
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey.shade900,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.white54,
            size: widget.isPreview ? 30.sp : 50.sp,
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: widget.isPreview
              ? Icon(Icons.play_arrow, color: Colors.white38, size: 30.sp)
              : const CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
        ),
      );
    }

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0 &&
            _controller.value.isPlaying &&
            mounted) {
          _controller.pause();
          setState(() {});
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

            if (!_controller.value.isPlaying)
              Container(
                padding: EdgeInsets.all(widget.isPreview ? 6.r : 12.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: widget.isPreview ? 25.sp : 35.sp,
                ),
              ),

            if (!widget.isPreview)
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: _toggleMute,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
