import 'package:colibri/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:colibri/extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewScreen extends StatefulWidget {
  final String url;
  final String name;
  const WebViewScreen({Key key, this.url, this.name}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: widget.name.toSubTitle1(color: Colors.white,fontWeight: FontWeight.w600),),
      body: WebView(

        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,),);
}
