// import 'package:flutter/material.dart';
//
// import '../../extensions.dart';
//
// class ExpandablePageView extends StatefulWidget {
//   final List<Widget> children;
//   final int currentPage;
//   final IntToVoidFunc onPageChange;
//   const ExpandablePageView({
//     Key key,
//     @required this.children, this.currentPage, this.onPageChange,
//   }) : super(key: key);
//
//   @override
//   _ExpandablePageViewState createState() => _ExpandablePageViewState();
// }
//
// class _ExpandablePageViewState extends State<ExpandablePageView> with TickerProviderStateMixin {
//   PageController _pageController;
//   List<double> _heights;
//   int _currentPage = 0;
//
//   double get _currentHeight => _heights[_currentPage];
//
//   @override
//   void initState() {
//     _heights = widget.children.map((e) => 0.0).toList();
//     super.initState();
//     _pageController = PageController() //
//       ..addListener(() {
//         if(widget.onPageChange!=null)
//         widget?.onPageChange(_pageController.page.round());
//         final _newPage = _pageController.page.round();
//         if (_currentPage != _newPage) {
//           setState(() => _currentPage = _newPage);
//         }
//       });
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//      if(widget.currentPage!=null)
//        _pageController.jumpToPage(widget.currentPage);
//    });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       curve: Curves.easeInOutCubic,
//       duration: const Duration(milliseconds: 100),
//       tween: Tween<double>(begin: _heights[0], end: _currentHeight),
//       builder: (context, value, child) => SizedBox(height: value, child: child),
//       child: PageView(
//         controller: _pageController,
//         children: _sizeReportingChildren
//             .asMap() //
//             .map((index, child) => MapEntry(index, child))
//             .values
//             .toList(),
//       ),
//     );
//   }
//
//   List<Widget> get _sizeReportingChildren => widget.children
//       .asMap() //
//       .map(
//         (index, child) => MapEntry(
//       index,
//       OverflowBox(
//         //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
//         minHeight: 0,
//         maxHeight: double.infinity,
//         alignment: Alignment.topCenter,
//         child: SizeReportingWidget(
//           onSizeChange: (size) {
//             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//               Future.delayed(Duration(milliseconds: 500),(){
//                 if(this.mounted)
//                   setState(() => _heights[index] = size?.height ?? 0);
//               });
//             });
//           },
//           child: Align(child: child),
//         ),
//       ),
//     ),
//   )
//       .values
//       .toList();
// }
// import 'package:flutter/cupertino.dart';
//
// class SizeReportingWidget extends StatefulWidget {
//   final Widget child;
//   final ValueChanged<Size> onSizeChange;
//
//   const SizeReportingWidget({
//     Key key,
//     @required this.child,
//     @required this.onSizeChange,
//   }) : super(key: key);
//
//   @override
//   _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
// }
//
// class _SizeReportingWidgetState extends State<SizeReportingWidget> {
//   Size _oldSize;
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _notifySize();
//     });
//     return widget.child;
//   }
//
//   void _notifySize() {
//     final size = context?.size;
//     if (_oldSize != size) {
//       _oldSize = size;
//       widget.onSizeChange(size);
//     }
//   }
// }