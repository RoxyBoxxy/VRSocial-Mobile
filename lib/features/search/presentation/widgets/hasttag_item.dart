import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/search/domain/entity/hashtag_entity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:colibri/extensions.dart';

Widget getHastTagItem(HashTagEntity entity, StringToVoidFunc onTap) {
  return [
    10.toSizedBoxHorizontal,
    const Icon(
      FontAwesomeIcons.hashtag,
      color: AppColors.colorPrimary,
      size: 22,
    )
        .toPadding(12)
        .toContainer(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.colorPrimary, width: .3)))
        // .toExpanded(flex: 1)
        .toCenter(),
    10.toSizedBoxHorizontal,
    [
      entity.name.toSubTitle2(fontWeight: FontWeight.w600),
      3.toSizedBox,
      "${entity.totalPosts} Posts".toCaption(fontSize: 10.toSp)
    ].toColumn()
    // .toExpanded(flex: 4)
  ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {
    onTap.call(entity.name);
  });
}
