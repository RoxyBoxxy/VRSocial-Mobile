import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(1),
      child: const Center(
        child: CircularProgressIndicator(),),
    );
  }
}
