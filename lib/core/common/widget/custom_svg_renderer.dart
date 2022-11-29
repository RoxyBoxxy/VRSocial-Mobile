import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySvgRenderer extends CustomPainter{
  final DrawableRoot svgString;

   MySvgRenderer(this.svgString){
    shouldRepaint(this);
  }
  @override
  void paint(Canvas canvas, Size size) {

// If you only want the final Picture output, just use
    final Picture picture = svgString?.toPicture(size: const Size(20, 20));

// Otherwise, if you want to draw it to a canvas:
// Optional, but probably normally desirable: scale the canvas dimensions to
// the SVG's viewbox
    svgString?.scaleCanvasToViewBox(canvas,const Size(18, 15));

// Optional, but probably normally desireable: ensure the SVG isn't rendered
// outside of the viewbox bounds
//     svgString.clipCanvasToViewBox(canvas);
    svgString?.draw(canvas, Rect.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}