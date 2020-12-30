import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebview extends StatefulWidget {
  final String url;

  NewsWebview(this.url);

  @override
  createState() => _NewsWebviewState(this.url);
}

// Webview page i
class _NewsWebviewState extends State<NewsWebview> {
  final String _url;
  final _key = UniqueKey();

  _NewsWebviewState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.share), onPressed: () => Share.share(_url))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: _url),
            )
          ],
        ));
  }
}
