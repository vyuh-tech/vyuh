import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:video_player/video_player.dart' as video;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'video_player.g.dart';

@JsonSerializable()
final class VideoPlayerItem extends ContentItem {
  static const schemaName = 'vyuh.videoPlayer';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Video Player',
    fromJson: VideoPlayerItem.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: VideoPlayerItem.typeDescriptor,
    defaultLayout: VideoPlayerDefaultLayout(),
    defaultLayoutDescriptor: VideoPlayerDefaultLayout.typeDescriptor,
  );

  factory VideoPlayerItem.fromJson(Map<String, dynamic> json) =>
      _$VideoPlayerItemFromJson(json);

  /// Optional title for the video that can be used as a caption
  final String? title;

  /// The URL of the video.
  final String url;

  /// Whether the video should loop.
  final bool loop;

  /// Whether the video should autoplay.
  final bool autoplay;

  /// Whether the video should be muted.
  final bool muted;

  VideoPlayerItem({
    this.title,
    required this.url,
    this.loop = false,
    this.autoplay = false,
    this.muted = false,
  }) : super(schemaType: schemaName);
}

/// LayoutConfiguration for the default VideoPlayer layout.
@JsonSerializable()
final class VideoPlayerDefaultLayout
    extends LayoutConfiguration<VideoPlayerItem> {
  static const schemaName = '${VideoPlayerItem.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default VideoPlayer Layout',
    fromJson: VideoPlayerDefaultLayout.fromJson,
  );

  VideoPlayerDefaultLayout()
      : super(schemaType: '${VideoPlayerItem.schemaName}.layout.default');

  factory VideoPlayerDefaultLayout.fromJson(Map<String, dynamic> json) =>
      _$VideoPlayerDefaultLayoutFromJson(json);

  @override
  Widget build(BuildContext context, VideoPlayerItem content) {
    return VideoPlayerWidget(content: content);
  }
}

final class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerItem content;

  const VideoPlayerWidget({
    super.key,
    required this.content,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late video.VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _controller =
        video.VideoPlayerController.networkUrl(Uri.parse(widget.content.url));

    _controller.initialize().then((_) {
      _controller.setVolume(widget.content.muted ? 0 : 1);

      _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: widget.content.autoplay,
          deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
          looping: widget.content.loop,
          hideControlsTimer: const Duration(seconds: 1),
          errorBuilder: (context, errorMessage) {
            return vyuh.widgetBuilder.errorView(context,
                title: 'Failed to play video', error: errorMessage);
          });

      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized;

    final theme = Theme.of(context);

    return ready
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: widget.content.title == null
                          ? BorderRadius.circular(8)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Chewie(controller: _chewieController!)),
                ),
                if (widget.content.title != null)
                  Container(
                    color: theme.colorScheme.inverseSurface,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      widget.content.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.apply(color: theme.colorScheme.onInverseSurface),
                    ),
                  ),
              ],
            ),
          )
        : vyuh.widgetBuilder.contentLoader(context);
  }
}
