import 'package:colibri/core/theme/strings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AffiliatesPage extends StatefulWidget {
  @override
  _AffiliatesPageState createState() => _AffiliatesPageState();
}

class _AffiliatesPageState extends State<AffiliatesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Widget webview'),
      ),
      body: WebView(
        initialUrl: Strings.affiliates,
        // withZoom: true,
        // withLocalStorage: true,
        // hidden: true,
        // initialChild: Container(
        //   color: Colors.redAccent,
        //   child: const Center(
        //     child: Text('Waiting.....'),
        //   ),
        // ),
      ),
    );
  }
}
