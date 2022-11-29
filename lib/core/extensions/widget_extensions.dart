import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/images.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

extension PaddingExtension on Widget {
  Widget toOutlinedBorder(VoidCallback callback, {double borderRadius = 20}) =>
      OutlinedButton(
        child: this.toPadding(6),
        onPressed: callback,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.colorPrimary, width: 1),
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
      );

  Widget toVisibility(bool visibility) => Visibility(
        child: this,
        visible: visibility,
      );

  Widget toSwipeToDelete({required Key key, VoidCallback? onDismissed}) =>
      Dismissible(
        onDismissed: (direction) {
          onDismissed?.call();
        },
        direction: DismissDirection.endToStart,
        child: this,
        key: key,
        background: Container(
          color: AppColors.colorPrimary,
          child: [
            TextButton.icon(
              icon: SvgPicture.asset(
                Images.delete,
                color: Colors.white,
                height: 16,
                width: 16,
              ),
              label: "Delete"
                  .toCaption(color: Colors.white, fontWeight: FontWeight.bold),
              onPressed: () {},
            ),
          ]
              .toRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center)
              .toHorizontalPadding(12),
        ),
      );
  Widget toPadding(num value) => Padding(
        child: this,
        padding: EdgeInsets.symmetric(
            vertical: value.toVertical as double,
            horizontal: value.toHorizontal as double),
      );

  Widget toVerticalPadding(num value) => Padding(
        child: this,
        padding: EdgeInsets.symmetric(vertical: value.toVertical as double),
      );
  Widget toPaddingOnly(
          {num top = 0, num bottom = 0, num right = 0, num left = 0}) =>
      Padding(
        padding: EdgeInsets.only(
            top: top as double,
            right: right as double,
            left: left as double,
            bottom: bottom as double),
      );

  Widget toHorizontalPadding(num value) => Padding(
        child: this,
        padding: EdgeInsets.symmetric(horizontal: value.toHorizontal as double),
      );

  Widget toSymmetricPadding(num horizontal, num vertical) => Padding(
        child: this,
        padding: EdgeInsets.symmetric(
            horizontal: horizontal.toHorizontal as double,
            vertical: vertical.toVertical as double),
      );

  Container toContainer(
          {AlignmentGeometry alignment = Alignment.centerLeft,
          double? height,
          Color? color,
          BoxDecoration? decoration,
          double? width}) =>
      Container(
        alignment: alignment,
        color: color,
        decoration: decoration,
        child: this,
        height: height?.toHeight as double?,
        width: width?.toWidth as double?,
      );

  Expanded toExpanded({int flex = 1}) => Expanded(
        child: this,
        flex: flex,
      );

  Flexible toFlexible({int flex = 1}) => Flexible(
        child: this,
        flex: flex,
      );

  TextButton toFlatButton(VoidCallback callback, {Color? color}) => TextButton(
        child: this,
        style: TextButton.styleFrom(foregroundColor: color),
        onPressed: callback,
      );

  Widget onTapWidget(VoidCallback callback,
          {bool removeFocus = true, VoidCallback? onLongPress}) =>
      InkWell(
        // customBorder: new CircleBorder(),
        child: this,
        onLongPress: onLongPress,
        onTap: () {
          if (removeFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
          callback.call();
        },
      );

  Widget toIconButton({required VoidCallback onTap}) => IconButton(
        icon: this,
        onPressed: onTap,
      );

  Widget toCenter() => Container(
        child: this,
        alignment: Alignment.center,
      );

  SizedBox toSizedBox({required num height, required num width}) => SizedBox(
        child: this,
        height: height.toHeight as double?,
        width: width.toWidth as double?,
      );

  FadeTransition toFadeAnimation(AnimationController controller) =>
      FadeTransition(
        child: this,
        opacity: Tween(begin: 0.5, end: 1.0).animate(controller),
      );

  SlideTransition toSlideAnimation(AnimationController controller) =>
      SlideTransition(
        child: this,
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Curves.fastLinearToSlowEaseIn,
            reverseCurve: Curves.fastLinearToSlowEaseIn)),
      );

  ScaleTransition toScaleAnimation(AnimationController controller) =>
      ScaleTransition(
        child: this,
        scale: controller,
      );

  Widget get toSafeArea => SafeArea(
        child: this,
      );

  Widget toMaterialButton(VoidCallback callback, {bool enabled = true}) =>
      TextButton(
        child: this,
        onPressed: () {
          if (enabled) {
            FocusManager.instance.primaryFocus!.unfocus();
            callback.call();
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(6),
          foregroundColor: enabled
              ? AppColors.colorPrimary
              : AppColors.colorPrimary.withOpacity(.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        ),
      );

  Widget toSteamVisibility(Stream<bool> stream) => StreamBuilder<bool>(
        initialData: false,
        builder: (c, snapshot) => this.toVisibility(snapshot.data!),
        stream: stream,
      );
}

extension ContaninerExtension on Container {
  Widget get makeVerticalBorders => Container(
        child: this,
        decoration: BoxDecoration(
            color: this.color,
            border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.3),
                bottom: BorderSide(color: Colors.grey, width: 0.3))),
      );

  Widget get makeTopBorder => Container(
        alignment: this.alignment,
        child: this,
        decoration: BoxDecoration(
            color: this.color,
            border:
                const Border(top: BorderSide(color: Colors.grey, width: 0.2))),
        constraints: this.constraints,
      );

  Widget get makeBottomBorder => Container(
        alignment: this.alignment,
        child: this,
        decoration: BoxDecoration(
            color: this.color,
            border: const Border(
                bottom: BorderSide(color: AppColors.sfBgColor, width: 2))),
        constraints: this.constraints,
      );
}

extension DateExtension on DateTime {
  String getCurrentFormattedTime() {
    final DateFormat formatter = DateFormat('d MMM, y').add_jm();
    return formatter.format(this);
  }
}
