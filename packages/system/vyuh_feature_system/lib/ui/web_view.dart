import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final class WebView extends StatefulWidget {
  final Uri uri;

  const WebView({super.key, required this.uri});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  // ignore: unused_field
  InAppWebViewController? _controller;

  final settings = InAppWebViewSettings(
    userAgent: 'vyuh',
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  int _progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.uri.toString())),
        body: Stack(
          children: [
            Positioned.fill(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri.uri(widget.uri)),
                initialSettings: settings,
                onWebViewCreated: (controller) => _controller = controller,
                onReceivedError: (controller, request, errorResponse) =>
                    debugPrint(errorResponse.toString()),
                onProgressChanged: (_, progress) {
                  setState(() {
                    _progress = progress;
                  });
                },
                gestureRecognizers: {
                  // This is required to allow scrolling on the page. Without this the page can't be scrolled
                  // and the scroll happens on the outside container instead.
                  Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()),
                },
              ),
            ),
            if (_progress < 100)
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: LinearProgressIndicator(
                    value: _progress / 100.0,
                  ))
          ],
        ));
  }
}
