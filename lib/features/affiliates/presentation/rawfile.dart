import 'package:colibri/core/theme/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AffiliatesPage extends StatefulWidget {
  @override
  _AffiliatesPageState createState() => _AffiliatesPageState();
}

class _AffiliatesPageState extends State<AffiliatesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: Strings.affiliates,
        appBar: new AppBar(
          title: const Text('Widget webview'),
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.redAccent,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
      ),
    );
  }
}
