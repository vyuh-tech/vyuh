import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String videoId;
  final double aspectRatio;
  final bool enableFullScreenOnVerticalDrag;
  final Color? backgroundColor;

  const YoutubeVideoPlayer({
    super.key,
    required this.videoId,
    required this.aspectRatio,
    this.enableFullScreenOnVerticalDrag = true,
    this.backgroundColor,
  });

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  bool _loading = true;
  final _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showFullscreenButton: false,
      loop: false,
      playsInline: false,
      mute: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.cueVideoById(videoId: widget.videoId);

    // To show loading indicator until video is loaded
    // and to avoid showing the flicker of the webview
    _controller.videoData.then((_) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            VisibilityDetector(
              key: const Key('youtube_player'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _controller.pauseVideo();
                }
              },
              child: YoutubePlayer(
                controller: _controller,
                enableFullScreenOnVerticalDrag:
                    widget.enableFullScreenOnVerticalDrag,
                aspectRatio: widget.aspectRatio,
                backgroundColor: widget.backgroundColor,
              ),
            ),
            if (_loading)
              Container(
                color: widget.backgroundColor ?? Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      );
}
