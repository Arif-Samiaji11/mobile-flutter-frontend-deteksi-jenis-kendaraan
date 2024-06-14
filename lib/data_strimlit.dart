import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Streamlit'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('http://192.168.1.10:8501/')),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onLoadStart: (controller, url) {
          print('Page started loading: $url');
        },
        onLoadStop: (controller, url) {
          print('Page finished loading: $url');
        },
        onLoadError: (controller, url, code, message) {
          print('''
            Page resource error:
            url: $url
            code: $code
            message: $message
          ''');
        },
      ),
    );
  }
}
