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
  int _selectedIndex = 0;

  final List<String> _urls = [
    'assets/index.html',
    'assets/assistant.html',
    'assets/favorite.html',
    'assets/settings.html',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      body: WebViewPage(initialUrl: _urls[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF552980),
        unselectedItemColor: Color(0xFF5D526C),
        onTap: _onItemTapped,
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
