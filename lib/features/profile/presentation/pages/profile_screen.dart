import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/widgets/expandable_page_view.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/core/widgets/media_picker.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/posts/presentation/widgets/post_pagination_widget.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:colibri/features/profile/presentation/bloc/user_likes/user_likes_cubit.dart';
import 'package:colibri/features/profile/presentation/bloc/user_media/user_media_cubit.dart';
import 'package:colibri/features/profile/presentation/bloc/user_posts/user_post_cubit.dart';
import 'package:colibri/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  // final bool otherUser;

  /// will going to pass id if the login user id is different than profile owner
  /// otherwise will pass null to this param to mark the current logged in user as profile owner
  final ProfileNavigationEnum profileNavigationEnum;
  final String otherUserId;
  final String profileUrl;
  final String coverUrl;
  const ProfileScreen({
    Key key,
    this.otherUserId,
    this.profileUrl,
    this.coverUrl,
    this.profileNavigationEnum = ProfileNavigationEnum.FROM_FEED,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  ProfileCubit _profileCubit;
  UserPostCubit userPostCubit;
  UserMediaCubit userMediaCubit;
  UserLikesCubit userLikesCubit;
  TabController tabController;
  Size size;
  @override
  void initState() {
    /// passing user for getting the data
    /// in-case of null it will fetch id for local storage of the current user
    _profileCubit = getIt<ProfileCubit>();
    tabController = TabController(length: 3, vsync: this);
    // ..postPagination.userId=widget.otherUserId
    // ..mediaPagination.userId=widget.otherUserId
    // ..profileLikesPagination.userId=widget.otherUserId;
    userPostCubit = getIt<UserPostCubit>();
    userMediaCubit = getIt<UserMediaCubit>();
    userLikesCubit = getIt<UserLikesCubit>();
    _profileCubit.profileEntity.listen((event) {
      userLikesCubit.userId = event.id;
      userMediaCubit.userId = event.id;
      userPostCubit.userId = event.id;
    });

    super.initState();
    _profileCubit.getUserProfile(
        widget.otherUserId, widget.coverUrl, widget.profileUrl);
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Scaffold(
      // appBar: AppBar(),
      body: BlocProvider(
        create: (c) => _profileCubit,
        child: BlocBuilder<ProfileCubit, CommonUIState>(
          bloc: _profileCubit,
          builder: (_, state) {
            return state.when(
                initial: () => LoadingBar(),
                success: (s) => getHomeWidget(),
                loading: () => LoadingBar(),
                error: (e) => Center(
                      child: NoDataFoundScreen(
                        onTapButton: ExtendedNavigator.root.pop,
                        icon: AppIcons.personOption(
                            color: AppColors.colorPrimary, size: 40),
                        title: "Profile not found!",
                        message: e.contains("invalid")
                            ? "Sorry, we cannot find the page you are looking for."
                            : e,
                        buttonText: "Go Back",
                      ),
                    ));
          },
        ),
      ),
    );
  }

  Widget getHomeWidget() {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              StreamBuilder<ProfileEntity>(
                  stream: _profileCubit.profileEntity,
                  builder: (context, snapshot) {
                    return SliverAppBar(
                      automaticallyImplyLeading: false,
                      leading: null,
                      brightness: Brightness.light,
                      elevation: 0.0,
                      expandedHeight: calculateHeight(snapshot.data),
                      floating: true,
                      pinned: true,
                      actions: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await openMediaPicker(context, (media) async {
                                _profileCubit.changeProfileEntity(snapshot.data
                                    .copyWith(backgroundImage: media));
                                await _profileCubit.updateProfileCover(media);
                              },
                                  mediaType: MediaTypeEnum.IMAGE,
                                  allowCropping: true);
                            }).toVisibility(widget.otherUserId == null)
                      ],
                      // title: Text('Profile'),
                      backgroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: snapshot.data == null
                            ? Container()
                            : TopAppBar(
                                otherUserId: snapshot.data.id,
                                otherUser: widget.otherUserId != null,
                                profileEntity: snapshot.data,
                                profileNavigationEnum:
                                    widget.profileNavigationEnum),
                      ),
                      bottom: PreferredSize(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.2))),
                              ),
                            ),
                            TabBar(
                              indicatorWeight: 1,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding: const EdgeInsets.all(0),
                              tabs: [
                                const Tab(
                                  text: "Posts",
                                ).toContainer(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 0.2)))),
                                const Tab(
                                  text: "Media",
                                ).toContainer(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 0.2)))),
                                const Tab(
                                  text: "Likes",
                                ).toContainer(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 0.2)))),
                              ],
                            )
                          ],
                        ),
                        preferredSize: const Size(500, 56),
                      ),
                    );
                  }),
            ];
          },
          body: TabBarView(
            children: [
              Container(
                  child: RefreshIndicator(
                onRefresh: () {
                  userPostCubit.onRefresh();
                  return Future.value();
                },
                child: PostPaginationWidget(
                  isComeHome: false,
                  isFromProfileSearch: true,
                  isPrivateAccount: (value) {
                    _profileCubit.isPrivateUser = value;
                  },
                  isSliverList: false,
                  noDataFoundScreen: NoDataFoundScreen(
                    buttonText: "Go to the homepage",
                    title: "No Posts Added!",
                    message: "",
                    onTapButton: () {
                      ExtendedNavigator.root.pop();
                      // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                      // ExtendedNavigator.root.push(Routes.createPost);
                    },
                  ),
                  pagingController: userPostCubit.pagingController,
                  onTapLike: userPostCubit.likeUnlikePost,
                  onOptionItemTap: userPostCubit.onOptionItemSelected,
                  onTapRepost: userPostCubit.repost,
                ),
              )),
              Container(
                  child: RefreshIndicator(
                onRefresh: () {
                  userMediaCubit.onRefresh();
                  return Future.value();
                },
                child: PostPaginationWidget(
                  isComeHome: false,
                  isPrivateAccount: (value) {
                    _profileCubit.isPrivateUser = value;
                  },
                  isSliverList: false,
                  noDataFoundScreen: NoDataFoundScreen(
                    title: "No media yet!",
                    icon: AppIcons.imageIcon(height: 35, width: 35),
                    buttonText: "Go to the homepage",
                    message: "",
                    onTapButton: () {
                      ExtendedNavigator.root.pop();
                      // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                      // ExtendedNavigator.root.push(Routes.createPost);
                    },
                  ),
                  pagingController: userMediaCubit.pagingController,
                  onTapLike: userMediaCubit.likeUnlikePost,
                  onOptionItemTap: (PostOptionsEnum value, int index) async =>
                      await userMediaCubit.onOptionItemSelected(value, index),
                  onTapRepost: userMediaCubit.repost,
                ),
              )),
              Container(
                  child: RefreshIndicator(
                onRefresh: () {
                  userLikesCubit.onRefresh();
                  return Future.value();
                },
                child: PostPaginationWidget(
                  isComeHome: false,
                  isPrivateAccount: (value) {
                    _profileCubit.isPrivateUser = value;
                  },
                  isSliverList: false,
                  noDataFoundScreen: NoDataFoundScreen(
                    title: "No likes yet!",
                    icon: AppIcons.likeOption(
                        size: 35, color: AppColors.colorPrimary),
                    buttonText: "Go to the homepage",
                    message:
                        "You don’t have any favorite posts yet. All posts that you like will be displayed here.",
                    onTapButton: () {
                      ExtendedNavigator.root.pop();
                      // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                      // ExtendedNavigator.root.push(Routes.createPost);
                    },
                  ),
                  pagingController: userLikesCubit.pagingController,
                  onTapLike: userLikesCubit.likeUnlikePost,
                  onOptionItemTap: userLikesCubit.onOptionItemSelected,
                  onTapRepost: userLikesCubit.repost,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  num calculateHeight(ProfileEntity data) {
    if (data == null)
      return 0.toHeight;

    /// we will have to give static height to app bar
    /// in case of about is more than 40 chars we will increase height
    else if (data.about.isNotEmpty) {
      /// handling large sizes
      if (context.getScreenWidth > 320) {
        if (data.about.length > 40)
          return 450.toHeight;
        else
          // return 500;
          return 422.toHeight / (context.getScreenWidth < 361 ? 1.0 : 1);
        // else return 440.toHeight/(context.getScreenWidth<361?1.1:1);

        // if(data.about.length>40)
        return 450.toHeight;
        // else return 440.toHeight/(context.getScreenWidth<361?1.1:1);
// >>>>>>> 6d35e518d211b14c7423c336799979e409d996fc
      }

      /// handling smaller sizes
      else {
        // if(data.about.length<40)return 0.toHeight;
        return 420.toHeight;
        // else if(data.about.length<55)return 430.toHeight;
        // else if(data.about.length<80)return 460.toHeight;
        // else return 440.toHeight;
      }
    }

    //   return context.getScreenWidth>320?
    // data.about.length>40?
    // 480.toHeight:440.toHeight/(context.getScreenWidth<361?1.1:1):data.about.length>40
    //     ?530.toHeight:460.toHeight;
    // return 500.toHeight;
    return context.getScreenWidth > 320 ? 420.toHeight : 390.toHeight;
  }
}

/// helps to determine from where user navigated to profile
/// so that on back press of the profile screen we can go back the correct page

/// we're using this because according to the UI we will have the keep the bottom navigation bar under the profile page
@deprecated
enum ProfileNavigationEnum {
  FROM_BOOKMARKS,
  FROM_FEED,
  FROM_SEARCH,
  FROM_VIEW_POST,
  FROM_MY_PROFILE,
  FROM_OTHER_PROFILE,
  FROM_MESSAGES,
  FROM_NOTIFICATION
}
