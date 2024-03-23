import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String lru;
  const WebViewExample({Key? key, required this.lru}) : super(key: key);

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController controller;
  late String a;
  @override
  void initState() {
    super.initState();

    if (widget.lru.toString().contains("http://")) {
      a = widget.lru.toString().replaceAll("http://", "https://");
    } else {
      a = widget.lru;
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Let's Make Yummy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff213A50),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
