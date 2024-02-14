import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(Testing());

class Testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _urls = [
    'assets/index.html',
    'assets/moves.html',
    'assets/pokemon.html',
    'assets/move_details.html',
    'assets/settings.html',
    'assets/chatbot.html',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview Example'),
      ),
      body: ListView.builder(
        itemCount: _urls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Open ${_urls[index].split('/').last}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(initialUrl: _urls[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String initialUrl;

  WebViewPage({required this.initialUrl});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: '',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _loadHtmlFromAssets(widget.initialUrl);
      },
    );
  }

  _loadHtmlFromAssets(String initialUrl) async {
    String fileText = await DefaultAssetBundle.of(context).loadString(initialUrl);
    _webViewController.loadUrl(
      Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }

  @override
  void didUpdateWidget(covariant WebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrl != widget.initialUrl) {
      _loadHtmlFromAssets(widget.initialUrl);
    }
  }
}
