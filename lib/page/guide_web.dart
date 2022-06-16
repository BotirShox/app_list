import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class GuideWeb extends StatelessWidget {

  static String tag = 'guide-web';
  final String url;
  final String Names;

  GuideWeb({Key key, @required this.url, this.Names}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Names),
          centerTitle: true,
        ),
        body:new MaterialApp(
          routes: {
            "/": (_) => new WebviewScaffold(
              url: url,
              appBar: new AppBar(
                title: new Text("Guide"),
              ),
            )
          },
        )
    );
  }
}