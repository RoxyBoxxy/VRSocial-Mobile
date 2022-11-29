import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/widget/custom_svg_renderer.dart';
import 'package:colibri/core/common/widget/menu_item_widget.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/images.dart';
import 'package:colibri/core/widgets/media_picker.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:colibri/features/profile/presentation/pages/followers_following_screen.dart';
import 'package:colibri/features/profile/presentation/pages/profile_screen.dart';
import 'package:colibri/features/profile/presentation/widgets/numberk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class GetStatusBar extends StatefulWidget {
  final String otherUserId;

  const GetStatusBar({Key key, this.otherUserId}) : super(key: key);

  @override
  _GetStatusBarState createState() => _GetStatusBarState();
}

class _GetStatusBarState extends State<GetStatusBar> {
  ProfileCubit profileCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileCubit = BlocProvider.of<ProfileCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileEntity>(
        stream: profileCubit.profileEntity,
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox();
          return context.getScreenWidth > 320
              ? getUserStatsBar(snapshot.data, userId: widget.otherUserId)
              : getUserSmallStatsBar(snapshot.data, userId: widget.otherUserId);
        });
  }

  Widget getUserSmallStatsBar(
    ProfileEntity profileEntity, {
    String userId,
  }) {
    return [
      Numeral(num.parse(profileEntity.postCounts)).value().toSubTitle1(
          color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
      4.toSizedBoxHorizontal,
      "Posts".toCaption(),
      15.toSizedBoxHorizontal,
      [
        Numeral(num.parse(profileEntity.followingCount)).value().toSubTitle1(
            color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
        4.toSizedBoxHorizontal,
        "Followings".toSubTitle2(),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {
        if (profileCubit.isPrivateUser) {
          context.showOkAlertDialog(
              title: "This account is private",
              desc:
                  "Only approved followers can see the posts and content of this profile, click the (Follow) button to see their posts!");
        } else
          ExtendedNavigator.root.push(Routes.followingFollowersScreen,
              arguments: FollowingFollowersScreenArguments(
                  userId: userId,
                  followScreenEnum: FollowUnFollowScreenEnum.FOLLOWING));
      }),
      15.toSizedBoxHorizontal,
      [
        Numeral(num.parse(profileEntity.followerCount)).value().toSubTitle1(
            color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
        4.toSizedBoxHorizontal,
        "Followers".toSubTitle2()
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {
        if (profileCubit.isPrivateUser) {
          context.showOkAlertDialog(
              title: "This account is private",
              desc:
                  "Only approved followers can see the posts and content of this profile, click the (Follow) button to see their posts!");
        }
        ExtendedNavigator.root.push(Routes.followingFollowersScreen,
            arguments: FollowingFollowersScreenArguments(
                userId: userId,
                followScreenEnum: FollowUnFollowScreenEnum.FOLLOWERS));
      })
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).toFlexible();
  }

  Widget getUserStatsBar(
    ProfileEntity profileEntity, {
    String userId,
  }) {
    return [
      [
        Numeral(num.parse(profileEntity.postCounts)).value().toSubTitle1(
            color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
        4.toSizedBoxHorizontal,
        "Posts".toSubTitle2()
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {}),
      15.toSizedBoxHorizontal,
      [
        Numeral(num.parse(profileEntity.followingCount)).value().toSubTitle1(
            color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
        4.toSizedBoxHorizontal,
        "Followings".toSubTitle2(),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {
        if (profileCubit.isPrivateUser) {
          context.showOkAlertDialog(
              title: "This account is private",
              desc:
                  "Only approved followers can see the posts and content of this profile, click the (Follow) button to see their posts!");
        } else
          ExtendedNavigator.root.push(Routes.followingFollowersScreen,
              arguments: FollowingFollowersScreenArguments(
                  userId: userId,
                  followScreenEnum: FollowUnFollowScreenEnum.FOLLOWING));
      }),
      15.toSizedBoxHorizontal,
      [
        Numeral(num.parse(profileEntity.followerCount)).value().toSubTitle1(
            color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
        4.toSizedBoxHorizontal,
        "Followers".toSubTitle2()
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(() {
        if (profileCubit.isPrivateUser) {
          context.showOkAlertDialog(
              title: "This account is private",
              desc:
                  "Only approved followers can see the posts and content of this profile, click the (Follow) button to see their posts!");
        } else
          ExtendedNavigator.root.push(Routes.followingFollowersScreen,
              arguments: FollowingFollowersScreenArguments(
                  userId: userId,
                  followScreenEnum: FollowUnFollowScreenEnum.FOLLOWERS));
      })
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center);
  }
}

class TopAppBar extends StatefulWidget {
  final bool otherUser;
  final ProfileEntity profileEntity;
  final ProfileNavigationEnum profileNavigationEnum;
  final String otherUserId;

  const TopAppBar(
      {Key key,
      this.otherUser = false,
      this.profileEntity,
      this.profileNavigationEnum,
      this.otherUserId})
      : super(key: key);

  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  var buttonText = '';
  ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    buttonText = widget.otherUserId != null
        ? !widget.profileEntity.isFollowing
            ? "Follow"
            : "UnFollow"
        : "SETTINGS";
  }

  @override
  Widget build(BuildContext context) {
    return getTopAppBar(otherUser: widget.otherUser);
  }

  Widget getTopAppBar({otherUser = false}) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        [
          AspectRatio(
            aspectRatio: 2.5,
            child: Container(
                child: widget.profileEntity.backgroundUrl.toNetWorkOrLocalImage(
                    width: double.infinity, borderRadius: 0)),
          ),
          [
            40.toSizedBoxHorizontal,
            [
              // SizedBox(
              //   height: widget.profileEntity.about.isNotEmpty?30.toHeight:50.toHeight,
              // ),
              // SizedBox(
              //   height: widget.profileEntity.about.isEmpty
              //       ? 40.toHeight
              //       : 40.toHeight,
              // ),
              [
                [
                  MenuItemWidget(
                    text: "Show followings",
                    icon: Images.personOption
                        .toSvg(color: AppColors.optionIconColor)
                        .toHorizontalPadding(5),
                  ),
                  MenuItemWidget(
                    text: "Show followers",
                    icon: Images.people.toSvg(
                        color: AppColors.optionIconColor.withOpacity(.8)),
                  ),
                  // MenuItemWidget(
                  //   text: "Copy link to profile",
                  //   icon: Icon(
                  //     Icons.copy,
                  //     size: 18,
                  //     color: AppColors.optionIconColor.withOpacity(.8),
                  //   ).toHorizontalPadding(4),
                  // ),
                ].toPopWithMenuItems((value) async {
                  if (profileCubit.isPrivateUser) {
                    context.showOkAlertDialog(
                        title: "This account is private",
                        desc:
                            "Only approved followers can see the posts and content of this profile, click the (Follow) button to see their posts!");
                  } else if (value == "Show followings") {
                    // Navigator.of(context).push(CupertinoPageRoute(builder: (c)=>FollowingFollowersScreen(
                    //   followScreenEnum: FollowUnFollowScreenEnum.FOLLOWING,
                    //   userId: widget.otherUserId,
                    // ),),);

                    ExtendedNavigator.root.push(Routes.followingFollowersScreen,
                        arguments: FollowingFollowersScreenArguments(
                            userId: widget.otherUserId,
                            followScreenEnum:
                                FollowUnFollowScreenEnum.FOLLOWING));
                  } else if (value == "Show followers") {
                    // Navigator.of(context).push(CupertinoPageRoute(builder: (c)=>FollowingFollowersScreen(
                    //   followScreenEnum: FollowUnFollowScreenEnum.FOLLOWERS,
                    //   userId: widget.otherUserId,
                    // ),),);
                    ExtendedNavigator.root.push(Routes.followingFollowersScreen,
                        arguments: FollowingFollowersScreenArguments(
                            userId: widget.otherUserId,
                            followScreenEnum:
                                FollowUnFollowScreenEnum.FOLLOWERS));
                  }
                  // else {
                  //   Clipboard.setData(  ClipboardData(text: "https://sm-colibri.ru/${widget.profileEntity.userName}"));
                  //   context.showSnackBar(message: "Link copied");
                  // }
                },
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 6,
                                width: 6,
                                color: AppColors.colorPrimary,
                              ),
                              5.toSizedBox,
                              Container(
                                height: 6,
                                width: 6,
                                color: AppColors.colorPrimary,
                              ),
                            ],
                          ),
                          5.toSizedBox,
                          Row(
                            children: [
                              Container(
                                height: 6,
                                width: 6,
                                color: AppColors.colorPrimary,
                              ),
                              5.toSizedBox,
                              Container(
                                height: 6,
                                width: 6,
                                color: AppColors.colorPrimary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                // AppIcons.messageProfile,
                // 5.toSizedBoxHorizontal,
                if (otherUser)
                  AppIcons.messageProfile().onTapWidget(() {
                    ExtendedNavigator.root.push(Routes.chatScreen,
                        arguments: ChatScreenArguments(
                            otherPersonProfileUrl:
                                widget.profileEntity.profileUrl,
                            otherPersonUserId: widget.profileEntity.id,
                            otherUserFullName: widget.profileEntity.fullName));
                  }),
                if (otherUser) 10.toSizedBox,
                "SETTINGS"
                    .toCaption(
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorPrimary)
                    .toOutlinedBorder(() {
                      ExtendedNavigator.root.push(Routes.settingsScreen,
                          arguments:
                              SettingsScreenArguments(fromProfile: true));
                    })
                    .toContainer(height: 30, alignment: Alignment.center)
                    .toVisibility(!widget.otherUser),
                getOtherUserButton().toVisibility(widget.otherUser)
                // "${widget.otherUserId!=null?!widget.profileEntity.isFollowing?"Follow":"UnFollow":"SETTINGS"}"
                //     .toCaption(fontWeight: FontWeight.bold,color: AppColors.colorPrimary)
                //     .toOutlinedBorder(() {
                //       if(widget.otherUser)
                //         BlocProvider.of<ProfileCubit>(context).followUnFollow();
                //       else
                //         ExtendedNavigator.root.push(Routes.settingsScreen,arguments: SettingsScreenArguments(fromProfile: true));
                //   // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.settings(true));
                // },
                // border: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(24.0),
                //     side: BorderSide(color:AppColors.colorPrimary))
                // ).toContainer(height: 25)
              ].toRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center),
              [
                widget.profileEntity.fullName
                    .toHeadLine6(fontWeight: FontWeight.bold)
                    .toEllipsis
                    .toFlexible(),
                4.toSizedBoxHorizontal,
                AppIcons.verifiedIcons
                    .toVisibility(widget.profileEntity.isVerified)
              ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
              widget.profileEntity.userName.toSubTitle2(
                  fontWeight: FontWeight.w600, color: Colors.black54),
              10.toSizedBox.toVisibility(widget.profileEntity.about.isNotEmpty),
              [
                widget.profileEntity.about
                    .toSubTitle2(
                      fontWeight: FontWeight.w600,
                      color: widget.profileEntity.about == "About not available"
                          ? AppColors.textColor.withOpacity(.4)
                          : AppColors.textColor,
                      maxLines: 1,
                    )
                    .toEllipsis
                    .toFlexible(),
                "more"
                    .toCaption(color: AppColors.colorPrimary)
                    .toPadding(4)
                    .onTapWidget(() {
                  context.showOkAlertDialog(
                      desc: widget.profileEntity.about, title: "About you");
                }).toVisibility(
                        widget.profileEntity.about != "About not available")
              ]
                  .toRow(crossAxisAlignment: CrossAxisAlignment.center)
                  .toVisibility(widget.profileEntity.about.isNotEmpty),
              13.toSizedBox,

              [
                const Icon(
                  FontAwesomeIcons.link,
                  size: 10,
                  color: Colors.black54,
                ),
                5.toSizedBoxHorizontal,
                widget.profileEntity.website
                    .toCaption(textOverflow: TextOverflow.ellipsis),
              ].toRow(),
              // 8.toSizedBox,
              [
                const Icon(
                  Icons.language,
                  size: 15,
                  color: Colors.black54,
                ),
                5.toSizedBoxHorizontal,
                "Living in - ${widget.profileEntity.country}".toCaption(),
                5.toSizedBoxHorizontal,
                FutureBuilder<DrawableRoot>(
                  builder: (_, item) => CustomPaint(
                    painter: MySvgRenderer(item.data),
                    // isComplex: true,
                    size: const Size(20, 20),
                  ),
                  future: svg.fromSvgString(widget.profileEntity.countryFlag,
                      widget.profileEntity.countryFlag),
                ),
                5.toSizedBoxHorizontal,
                2.toSizedBoxHorizontal,
              ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
              8.toSizedBox,
              // [
              //   2.toSizedBoxHorizontal,
              //   Icon(
              //     FontAwesomeIcons.link,
              //     size: 10,
              //     color: Colors.black54,
              //   ),
              //   5.toSizedBoxHorizontal,
              //   widget.profileEntity.website.toCaption()
              // ].toRow(),
              // 8.toSizedBox,
              [
                2.toSizedBoxHorizontal,
                AppIcons.folderIcon,
                5.toSizedBoxHorizontal,
                "Member since - ${widget.profileEntity.memberSince}".toCaption()
              ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
              13.toSizedBox,
              GetStatusBar(
                otherUserId: widget.otherUserId,
              ),
              13.toSizedBox,
            ].toColumn().toExpanded(),
            10.toSizedBoxHorizontal
          ].toRow().toExpanded(flex: 3),
        ].toColumn().toContainer(),
        Positioned(
          top: calculateHeightForImage(widget.profileEntity),
          left: 30.toWidth,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3.0),
                shape: BoxShape.circle),
            child:
                widget.profileEntity.profileUrl.toRoundNetworkImage(radius: 17),
          ).onTapWidget(() async {
            if (!widget.otherUser)
              await openMediaPicker(context, (media) async {
                profileCubit.changeProfileEntity(
                    widget.profileEntity.copyWith(profileImage: media));
                await profileCubit.updateProfileAvatar(media);
              });
          }),
        ),
        // Positioned(
        //   top: calculateHeightForName(widget.profileEntity),
        //   right: 10.toWidth,
        //   child: ,
        // ),
        Positioned(
          top: 10.toHeight,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              switch (widget.profileNavigationEnum) {
                case ProfileNavigationEnum.FROM_BOOKMARKS:
                  BlocProvider.of<FeedCubit>(context)
                      .changeCurrentPage(const ScreenType.home());
                  break;
                case ProfileNavigationEnum.FROM_FEED:
                  ExtendedNavigator.root.pop();
                  // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                  break;
                case ProfileNavigationEnum.FROM_SEARCH:
                  BlocProvider.of<FeedCubit>(context)
                      .changeCurrentPage(const ScreenType.search());
                  break;
                case ProfileNavigationEnum.FROM_VIEW_POST:
                  break;
                case ProfileNavigationEnum.FROM_MY_PROFILE:
                  BlocProvider.of<FeedCubit>(context)
                      .changeCurrentPage(const ScreenType.home());
                  break;
                case ProfileNavigationEnum.FROM_OTHER_PROFILE:
                  BlocProvider.of<FeedCubit>(context)
                      .changeCurrentPage(const ScreenType.home());
                  break;
                case ProfileNavigationEnum.FROM_MESSAGES:
                  BlocProvider.of<FeedCubit>(context)
                      .changeCurrentPage(const ScreenType.message());
                  break;
                case ProfileNavigationEnum.FROM_NOTIFICATION:
                  BlocProvider.of<FeedCubit>(context)
                      .changeCurrentPage(const ScreenType.notification());
                  break;
              }
            },
          ),
        )
      ],
    );
  }

  num calculateHeightForName(ProfileEntity profileEntity) {
    if (profileEntity.about.isNotEmpty)
      return context.getScreenWidth > 320
          ? profileEntity.about.length > 40
              ? 155.toHeight
              : 165.toHeight
          : 160.toHeight;
    return context.getScreenWidth > 320 ? 160.toHeight : 160.toHeight;
  }

  num calculateHeightForImage(ProfileEntity profileEntity) {
    if (profileEntity.about.isEmpty)
      return context.getScreenWidth > 320 ? 120.toHeight : 85.toHeight;
    return context.getScreenWidth > 320
        ? profileEntity.about.length > 40
            ? 115.toHeight
            : 120.toHeight
        : 90.toHeight;
  }

  Widget getOtherUserButton() {
    if (buttonText == "UnFollow")
      return buttonText
          .toCaption(color: Colors.white, fontWeight: FontWeight.w800)
          .toMaterialButton(() {
        context.showOkCancelAlertDialog(
            desc:
                "Please note that, if you unsubscribe then this user's posts will no longer appear in the feed on your main page.",
            title: "Please confirm your actions!",
            onTapOk: () {
              ExtendedNavigator.root.pop();
              profileCubit.followUnFollow();
              setState(() {
                buttonText = "Follow";
              });
            },
            okButtonTitle: "UnFollow");
      }).toContainer(height: 25);
    else
      return buttonText
          .toCaption(fontWeight: FontWeight.bold, color: AppColors.colorPrimary)
          .toOutlinedBorder(() {
        if (widget.otherUser) {
          setState(() {
            buttonText = "UnFollow";
          });
          profileCubit.followUnFollow();
        } else
          ExtendedNavigator.root.push(Routes.settingsScreen,
              arguments: SettingsScreenArguments(fromProfile: true));
      }).toContainer(height: 25);
  }
}
