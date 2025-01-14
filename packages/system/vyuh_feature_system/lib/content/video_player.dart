import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:video_player/video_player.dart' as video;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'video_player.g.dart';

/// The type of video source to be played.
///
/// * [url] - Video from a network URL
/// * [file] - Video from a file reference (e.g., from CMS)
enum VideoLinkType { url, file }

/// A content item that plays video content from various sources.
///
/// Features:
/// * Network video playback
/// * File reference video playback (e.g., from CMS)
/// * Autoplay, loop, and mute controls
/// * Optional title/caption
/// * Full-screen support
/// * Playback controls
///
/// Example:
/// ```dart
/// final player = VideoPlayerItem(
///   title: 'My Video',
///   linkType: VideoLinkType.url,
///   url: 'https://example.com/video.mp4',
///   autoplay: true,
///   loop: true,
///   muted: false,
/// );
/// ```
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

  /// The File reference of the video.
  final VideoLinkType linkType;

  /// The File reference of the video.
  final FileReference? file;

  /// The URL of the video.
  final String? url;

  /// Whether the video should loop.
  final bool loop;

  /// Whether the video should autoplay.
  final bool autoplay;

  /// Whether the video should be muted.
  final bool muted;

  VideoPlayerItem({
    this.title,
    required this.linkType,
    this.url,
    this.file,
    this.loop = false,
    this.autoplay = false,
    this.muted = false,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);
}

/// LayoutConfiguration for the default VideoPlayer layout.
/// Default layout for video player content.
///
/// Features:
/// * Responsive aspect ratio
/// * Rounded corners
/// * Optional title/caption display
/// * Loading and error states
/// * Playback controls overlay
///
/// Example:
/// ```dart
/// final layout = VideoPlayerDefaultLayout();
/// ```
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

/// Widget that handles video playback using the Chewie player.
///
/// Features:
/// * Video initialization and cleanup
/// * Playback controls
/// * Error handling
/// * Loading states
/// * Aspect ratio management
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
  late final video.VideoPlayerController _controller;
  ChewieController? _chewieController;
  Object? _error;

  @override
  void initState() {
    super.initState();

    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final videoUrl = widget.content.linkType == VideoLinkType.file
        ? widget.content.file != null
            ? vyuh.content.provider.fileUrl(widget.content.file!)
            : null
        : widget.content.url != null
            ? Uri.parse(widget.content.url!)
            : null;

    if (videoUrl == null) {
      _error = UnsupportedError('Unable to determine video url');
      return;
    }

    _controller = video.VideoPlayerController.networkUrl(videoUrl)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }

        _controller.setVolume(widget.content.muted ? 0 : 1);

        _chewieController = _buildChewie(context, _controller);

        setState(() {});
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        _error = Exception('Failed to load video from given url or file');
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
    if (_error != null) {
      return vyuh.widgetBuilder
          .errorView(context, error: _error, title: 'Failed to load video');
    }

    final theme = Theme.of(context);

    return _chewieController != null
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

  _buildChewie(BuildContext context, video.VideoPlayerController controller) {
    return ChewieController(
        videoPlayerController: controller,
        autoPlay: widget.content.autoplay,
        deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
        looping: widget.content.loop,
        hideControlsTimer: const Duration(seconds: 1),
        placeholder: vyuh.widgetBuilder.contentLoader(context),
        errorBuilder: (context, errorMessage) {
          return vyuh.widgetBuilder.errorView(context,
              title: 'Failed to play video', error: errorMessage);
        });
  }
}
