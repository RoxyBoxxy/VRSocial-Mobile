import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:flutter/material.dart';
import 'package:colibri/core/routes/routes.gr.dart';

class PeopleItem extends StatelessWidget {
  final PeopleEntity peopleEntity;
  final VoidCallback onFollowTap;

  const PeopleItem({Key key, this.peopleEntity, this.onFollowTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      20.toSizedBoxHorizontal,
      peopleEntity.profileUrl.toRoundNetworkImage(radius: 11),
      20.toSizedBoxHorizontal,
      [
        [
          peopleEntity.fullName
              .toSubTitle2(fontWeight: FontWeight.w600)
              .toEllipsis
              .toFlexible(),
          5.toSizedBoxHorizontal,
          AppIcons.verifiedIcons.toVisibility(peopleEntity.isVerified),
          5.toSizedBoxHorizontal
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
        peopleEntity.userName.toCaption(
            fontSize: 10.toSp,
            fontWeight: FontWeight.w600,
            color: Colors.black54)
      ].toColumn().toExpanded(),
      [
        if (peopleEntity.buttonText == "Unfollow")
          peopleEntity.buttonText
              .toSubTitle2(color: Colors.white, fontWeight: FontWeight.w600)
              .toVerticalPadding(2)
              .toMaterialButton(() {
            context.showOkCancelAlertDialog(
                desc:
                    "Please note that, if you unsubscribe then this user's posts will no longer appear in the feed on your main page.",
                title: "Please confirm your actions!",
                onTapOk: () {
                  ExtendedNavigator.root.pop();
                  onFollowTap.call();
                },
                okButtonTitle: "UnFollow");
          })
        else
          peopleEntity.buttonText
              .toSubTitle2(
                  color: AppColors.colorPrimary, fontWeight: FontWeight.w600)
              .toVerticalPadding(2)
              .toOutlinedBorder(() {
            onFollowTap.call();
          }).toContainer(height: 30, alignment: Alignment.topCenter)
        // peopleEntity.buttonText
        //     .toCaption(
        //         color: AppColors.colorPrimary, fontWeight: FontWeight.w600)
        //     .toHorizontalPadding(12)
        //     .toVerticalPadding(4)
        //     .toContainer(
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(20),
        //             border:
        //                 Border.all(color: AppColors.colorPrimary, width: 1)),
        //         alignment: Alignment.centerRight)
        //     .onTap(onFollowTap)
      ]
          .toRow(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center)
          .toContainer(alignment: Alignment.center)
          .toVisibility(!peopleEntity.isCurrentLoggedInUser),
      20.toSizedBoxHorizontal,
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {
      ExtendedNavigator.root.push(Routes.profileScreen,
          arguments: ProfileScreenArguments(
              otherUserId:
                  peopleEntity.isCurrentLoggedInUser ? null : peopleEntity.id));
      // BlocProvider.of<FeedCubit>(context)
      //     .changeCurrentPage(ScreenType.profile(ProfileScreenArguments(
      //   otherUserId: peopleEntity.id.toString(),
      //   profileNavigationEnum: ProfileNavigationEnum.FROM_SEARCH
      // )));
      // ExtendedNavigator.root.push(Routes.profileScreen,arguments: ProfileScreenArguments(otherUserId: peopleEntity.id));
    });
  }
}
