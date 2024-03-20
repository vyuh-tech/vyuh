import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final Uri uri;

  const WebView({super.key, required this.uri});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setUserAgent('vyuh')
      ..setNavigationDelegate(NavigationDelegate(onProgress: (value) {
        if (!mounted) {
          return;
        }

        setState(() {
          _progress = value;
        });
      }))
      ..loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.uri.toString())),
        body: Stack(
          children: [
            Positioned.fill(child: WebViewWidget(controller: _controller)),
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
