import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/images.dart';
import 'package:colibri/core/widgets/animations/fade_widget.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/profile/domain/entity/follower_entity.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/presentation/bloc/followers_following_cubit.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FollowingFollowersScreen extends StatefulWidget {
  final FollowUnFollowScreenEnum followScreenEnum;
  final String userId;

  const FollowingFollowersScreen(
      {Key key,
      this.followScreenEnum = FollowUnFollowScreenEnum.FOLLOWERS,
      this.userId})
      : super(key: key);

  @override
  _FollowingFollowersScreenState createState() =>
      _FollowingFollowersScreenState();
}

class _FollowingFollowersScreenState extends State<FollowingFollowersScreen>
    with SingleTickerProviderStateMixin {
  FollowersFollowingCubit followersFollowingCubit;
  TabController tabController;
  FeedCubit feedCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    followersFollowingCubit = getIt<FollowersFollowingCubit>()
      ..getProfile(widget.userId)
      ..followerPagination.userId = widget.userId
      ..followingPagination.userId = widget.userId;
    // feedCubit=BlocProvider.of<FeedCubit>(context);
    tabController = TabController(length: 2, vsync: this);
    switch (widget.followScreenEnum) {
      case FollowUnFollowScreenEnum.FOLLOWERS:
        tabController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInBack);
        break;
      case FollowUnFollowScreenEnum.FOLLOWING:
        tabController.animateTo(1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInBack);
        break;
      case FollowUnFollowScreenEnum.PEOPLE:
        tabController.animateTo(2,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInBack);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                title: AppIcons.appLogo.toContainer(height: 35, width: 35),
                centerTitle: true,
                automaticallyImplyLeading: true,
                leading: const BackButton(
                  color: AppColors.colorPrimary,
                ),
                elevation: 0.0,
                // expandedHeight: context.getScreenWidth>320?480.toHeight:520.toHeight,
                floating: true,
                pinned: true,
                // title: Text('Profile'),
                backgroundColor: Colors.white,
                // flexibleSpace: FlexibleSpaceBar(
                //   collapseMode: CollapseMode.parallax,
                //   background: StreamBuilder<ProfileEntity>(
                //       stream: _profileCubit.profileEntity,
                //       builder: (context, snapshot) {
                //
                //         return snapshot.data==null?Container():TopAppBar(otherUser: widget.otherUser,profileEntity: snapshot.data,);
                //       }
                //   ),
                // ),
                bottom: PreferredSize(
                  child: StreamBuilder<ProfileEntity>(
                      stream: followersFollowingCubit.profileEntity,
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? const SizedBox()
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.2))),
                                    ),
                                  ),
                                  TabBar(
                                    controller: tabController,
                                    indicatorWeight: 1,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelPadding: const EdgeInsets.all(0),
                                    tabs: [
                                      Tab(
                                        text:
                                            "Followers (${snapshot.data.followerCount})",
                                      ).toContainer(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2)))),
                                      Tab(
                                        text:
                                            "Following (${snapshot.data.followingCount})",
                                      ).toContainer(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2))))
                                      // Tab(
                                      //   text: "Requests",
                                      // ).toContainer(
                                      //     alignment: Alignment.center,
                                      //     decoration: BoxDecoration(
                                      //         color: Colors.white,
                                      //         border: Border(
                                      //             top: BorderSide(
                                      //                 color: Colors.grey, width: 0.2)))),
                                    ],
                                  )
                                ],
                              );
                      }),
                  preferredSize: const Size(500, 56),
                ), systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              RefreshIndicator(
                onRefresh: () {
                  followersFollowingCubit.getProfile(widget.userId);
                  followersFollowingCubit.followerPagination.onRefresh();
                  return Future.value();
                },
                child: PagedListView.separated(
                  padding: const EdgeInsets.only(bottom: 10),
                  pagingController: followersFollowingCubit
                      .followerPagination.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<FollowerEntity>(
                      noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                            buttonText: "GO BACK!",
                            icon: Images.people.toSvg(
                                color: AppColors.colorPrimary,
                                height: 30,
                                width: 30),
                            title: "No followers yet",
                            message:
                                'You have no followers yet. The list of all people who follow you will be displayed here',
                            onTapButton: () {
                              ExtendedNavigator.root.pop();
                              // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                            },
                          ),
                      itemBuilder: (BuildContext context, item, int index) =>
                          CustomAnimatedWidget(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: index == 0 ? 8 : 0.0),
                              child: followerTile(item, () {
                                followersFollowingCubit.followUnFollow(
                                    index, FollowUnFollowEnums.FOLLOWERS);
                              }).onTapWidget(() {
                                // feedCubit.changeCurrentPage(ScreenType.home());
                                // feedCubit.changeCurrentPage(ScreenType.profile(
                                //
                                // ProfileScreenArguments(otherUserId: item.id.toString(),profileNavigationEnum: ProfileNavigationEnum.FROM_SEARCH)));
                                ExtendedNavigator.root.pop();
                                // context.showSnackBar(message: followerEntity.id.toString());
                              }),
                            ),
                          )),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 2,
                    color: AppColors.sfBgColor,
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () {
                  followersFollowingCubit.getProfile(widget.userId);
                  followersFollowingCubit.followingPagination.onRefresh();
                  return Future.value();
                },
                child: PagedListView.separated(
                  padding: const EdgeInsets.only(bottom: 10),
                  pagingController: followersFollowingCubit
                      .followingPagination.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<FollowerEntity>(
                      noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                            buttonText: "GO BACK!",
                            icon: AppIcons.personOption(
                                size: 35, color: AppColors.colorPrimary),
                            title: "Not following yet",
                            message:
                                'You are not following any user yet. The list of all people you follow will be displayed here',
                            onTapButton: () {
                              ExtendedNavigator.root.pop();
                              // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                            },
                          ),
                      itemBuilder: (BuildContext context, item, int index) =>
                          CustomAnimatedWidget(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: index == 0 ? 8 : 0.0),
                              child: followerTile(item, () {
                                followersFollowingCubit.followUnFollow(
                                    index, FollowUnFollowEnums.FOLLOWING);
                              }),
                            ),
                          )),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 2,
                    color: AppColors.sfBgColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget followTile() {
    return [
      "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"
          .toRoundNetworkImage(radius: 12),
      [
        faker.person.name().toSubTitle2(fontWeight: FontWeight.bold),
        faker.person.firstName().toCaption(),
        faker.job.title().toCaption()
      ].toColumn().toHorizontalPadding(8).toExpanded(),
      "follow"
          .toButton(color: AppColors.colorPrimary)
          .toOutlinedBorder(() {})
          .toContainer(height: 25)
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).toPadding(8);
  }

  Widget followerTile(
      FollowerEntity followerEntity, VoidCallback voidCallback) {
    return [
      followerEntity.profileUrl.toRoundNetworkImage(radius: 12),
      [
        5.toSizedBox,
        followerEntity.fullName.toSubTitle2(fontWeight: FontWeight.bold),
        2.toSizedBox,
        followerEntity.username.toCaption(),
        5.toSizedBox,
        followerEntity.about
            .toCaption()
            .toVisibility(followerEntity.about.isNotEmpty)
      ].toColumn().toHorizontalPadding(8).toExpanded(),
      getFollowUnFollowButton(followerEntity, voidCallback)
          .toVisibility(!followerEntity.isCurrentLoggedInUser),
    ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.start)
        .toHorizontalPadding(8)
        .onTapWidget(() {
      // context.showSnackBar(message: followerEntity.id.toString());
      ExtendedNavigator.root.push(Routes.profileScreen,
          arguments: ProfileScreenArguments(
              otherUserId: followerEntity.isCurrentLoggedInUser
                  ? null
                  : followerEntity.id.toString()));
    }).toHorizontalPadding(8);
  }

  @override
  void dispose() {
    // followersFollowingCubit.close();
    super.dispose();
  }

  Widget getFollowUnFollowButton(
      FollowerEntity followerEntity, VoidCallback voidCallback) {
    if (followerEntity.buttonText == "Unfollow")
      return followerEntity.buttonText
          .toSubTitle2(color: Colors.white, fontWeight: FontWeight.w600)
          .toVerticalPadding(2)
          .toMaterialButton(() {
        context.showOkCancelAlertDialog(
            desc:
                "Please note that, if you unsubscribe then this user's posts will no longer appear in the feed on your main page.",
            title: "Please confirm your actions!",
            onTapOk: () {
              ExtendedNavigator.root.pop();
              voidCallback.call();
            },
            okButtonTitle: "UnFollow");
      }).toContainer(height: 30, alignment: Alignment.topCenter);
    else
      return followerEntity.buttonText
          .toSubTitle2(
              color: AppColors.colorPrimary, fontWeight: FontWeight.w600)
          .toVerticalPadding(2)
          .toOutlinedBorder(() {
        voidCallback.call();
      }).toContainer(height: 30, alignment: Alignment.topCenter);
  }
}

enum FollowUnFollowScreenEnum { FOLLOWERS, FOLLOWING, PEOPLE }
