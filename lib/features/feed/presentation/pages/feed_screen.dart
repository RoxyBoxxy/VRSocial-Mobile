import 'dart:async';

import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/pagination/pagination_helper.dart';
import 'package:colibri/core/common/push_notification/push_notification_helper.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/common/widget/common_divider.dart';
import 'package:colibri/core/common/widget/promoted_widget.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/authentication/data/models/login_response.dart';
import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/entity/drawer_entity.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/messages/presentation/pages/message_screen.dart';
import 'package:colibri/features/notifications/presentation/pages/notification_page.dart';
import 'package:colibri/features/notifications/presentation/pages/notification_screen.dart';
import 'package:colibri/features/posts/presentation/bloc/createpost_cubit.dart';
import 'package:colibri/features/posts/presentation/pages/create_post.dart';
import 'package:colibri/features/posts/presentation/pages/view_post_screen.dart';
import 'package:colibri/features/posts/presentation/widgets/post_pagination_widget.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/presentation/pages/profile_screen.dart';
import 'package:colibri/features/profile/presentation/pages/settings_page.dart';
import 'package:colibri/features/search/presentation/pages/searh_screen.dart';
import 'package:colibri/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../../../profile/presentation/pages/bookmark_screen.dart';


// StreamController<double> controller = StreamController<double>();
StreamController<double> controller = StreamController<double>.broadcast();
LoginResponse loginResponseFeed;

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  FeedCubit feedCubit;
  CreatePostCubit createPostCubit;

  int prevIndex = 0;
  int currentIndex = 0;

  double _containerMaxHeight = 56, _offset, _delta = 0, _oldOffset = 0;

  bool _isVisible = true;
  // final ScrollController scrollController = ScrollController();
  ScrollController _hideButtonController = ScrollController(keepScrollOffset: true);
  // final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  bool isKeyBoardShow = false;

  SearchScreen searScreen=const SearchScreen();

  bool isMessageShow = false;
  bool isNotificationShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedCubit = getIt<FeedCubit>()..getUserData()..saveNotificationToken();
    createPostCubit=getIt<CreatePostCubit>();

    _hideButtonController = ScrollController(keepScrollOffset: true);

    loginData();

    loginUserData();
    blurDotDataGet();
    updateData();
    checkIsKeyBoardShow();

  }

  static loginData() {

    Future.delayed(Duration(seconds: 1), () async {
      AC.loginResponse = await localDataSource.getUserAuth();
    });

  }

  loginUserData() async {
    loginResponseFeed = await localDataSource.getUserData();
    print("User Name :  -  ${loginResponseFeed.data.user.userName}");
  }

  blurDotDataGet() {

    if(AC.prefs.containsKey("message")) {
      isMessageShow = AC.prefs.getBool("message");
    } else {
      AC.prefs.setBool("message", false);
    }


    if(AC.prefs.containsKey("notification")) {
      isNotificationShow = AC.prefs.getBool("notification");
    } else {
      AC.prefs.setBool("notification", false);
    }
    updateWidget();

  }

  updateData() {
    Stream stream = controller.stream;
    stream.listen((value) {
      print("vishal");
      print('Value from controller: $value');

      isMessageShow = AC.prefs.getBool("message");
      isNotificationShow = AC.prefs.getBool("notification");

      updateWidget();
    });
  }

  updateWidget() {
    setState(() { });
  }

  checkIsKeyBoardShow() {
    KeyboardVisibilityNotification().addNewListener (
      onChange: (bool visible) {
        print(visible);
        isKeyBoardShow = visible;
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    context.initScreenUtil();

    print(context.getScreenWidth.toString());
    return KeyboardActions (
      config: KeyboardActionsConfig (
        keyboardActionsPlatform:KeyboardActionsPlatform.IOS,
        actions: [
          KeyboardActionsItem (
            focusNode: createPostCubit.postTextValidator.focusNode,
          ),
        ]),
      child: SizedBox (
        height: context.getScreenHeight,
        child: MultiBlocProvider (

          providers: [BlocProvider<FeedCubit>(create:(c)=> feedCubit),BlocProvider<CreatePostCubit>(create:(c)=>createPostCubit)],
          child: BlocListener<FeedCubit, CommonUIState> (
            listener: (_, state) {
              state.maybeWhen (
                  orElse: () {},
                  error: (e) => context.showSnackBar(message: e, isError: true),
                  success: (s) {
                    if(s is String) {
                      if(s.toLowerCase().contains("log out")) {
                        ExtendedNavigator.root.pushAndRemoveUntil(Routes.loginScreen, (route) => false);
                      }
                      context.showSnackBar(message: s, isError: false);
                    }
                  });
            },
            child: StreamBuilder<ScreenType> (
                stream: feedCubit.currentPage,
                initialData: const ScreenType.home(),
                builder: (context, snapshot) {
                  return Scaffold (

                    key: scaffoldKey,
                    extendBody: true,

                    drawer: InkWell (
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container (
                        color: scaffoldKey?.currentState?.isDrawerOpen != null && scaffoldKey.currentState.isDrawerOpen ? Color(0xFF1D88F0).withOpacity(0.6) : Colors.transparent,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack (
                          children: [


                            Container (
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: StreamBuilder<ProfileEntity> (
                                  stream: feedCubit.drawerEntity,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null)
                                      return Container (
                                        color: Colors.white,
                                        child: Column (
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const CircularProgressIndicator(),
                                          ],
                                        ),
                                      );
                                    return GetDrawerMenu (
                                      profileEntity: snapshot.data,
                                    );
                                  }),
                            )

                          ],
                        ),
                      ),
                    ),

                    appBar: appBarShow(snapshot.data),

                    body: Stack (
                      alignment: Alignment.topCenter,
                      children: [


                       SafeArea (
                           bottom: false,
                           child: PageTransitionSwitcher (
                         reverse:  doReverse(),
                         child: getSelectedHomeScreen(snapshot.data),
                         transitionBuilder: (Widget child,
                             Animation<double> primaryAnimation,
                             Animation<double> secondaryAnimation) =>
                             SharedAxisTransition (
                               animation: primaryAnimation,
                               secondaryAnimation: secondaryAnimation,
                               transitionType: SharedAxisTransitionType.horizontal,
                               child: child,
                             ),
                       )),


                        currentIndex == 2 ? Container (
                          height: MediaQuery.of(context).size.height,
                          color: AppColors.alertBg.withOpacity(0.5),
                        ) : Container(),

                      ],
                    ),


                    // bottomNavigationBar: BottomNavigationView(),

                    // bottomNavigationBar: _isVisible ? Transform.translate(offset: Offset(0, -10), child: Container (
                    //   height: _isVisible ? 51 : 0,

                    bottomNavigationBar: Transform.translate (
                      offset: const Offset(0, -13),
                      child: AnimatedBuilder (
                          animation: _hideButtonController,
                          builder: (context, child) {

                            // if(_hideButtonController.positions == null || _hideButtonController.positions.isEmpty) {
                            //
                            //   if (_hideButtonController.hasClients)
                            //     _hideButtonController.jumpTo(50.0);
                            //
                            //   Future.delayed(Duration(seconds: 1), () {
                            //     if (_hideButtonController.hasClients) {
                            //        _hideButtonController.animateTo (
                            //         0.0,
                            //         curve: Curves.easeOut,
                            //         duration: const Duration(milliseconds: 300),
                            //       );
                            //     }
                            //       setState(() {});
                            //   });
                            //   return Container();
                            // }

                            return AnimatedContainer (
                              curve: Curves.bounceOut,
                              duration: Duration(microseconds: 1),

                              height: (_hideButtonController?.positions.isNotEmpty && _hideButtonController.position.userScrollDirection == ScrollDirection.reverse) ||
                                  (_hideButtonController?.positions.isNotEmpty && _hideButtonController.position.userScrollDirection == ScrollDirection.forward)
                                  ? 0 : MediaQuery.of(context).size.width / 7.5,

                              child: Container (
                                height: _isVisible ? 51 : 0,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                                // height: _containerMaxHeight,
                                decoration: ShapeDecoration (
                                  color: Colors.white,
                                  shape: MyBorderShape(),
                                  shadows: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2.0, offset: Offset(1, 1))],
                                ),
                                child: Row (
                                  // mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[

                                    InkWell (
                                      onTap: () {

                                        prevIndex=currentIndex;
                                        currentIndex=0;
                                        feedCubit.onRefresh();
                                        feedCubit.changeCurrentPage(const ScreenType.home());

                                      },

                                      child: Container (
                                        width: 24,
                                        height: 27,
                                        margin: EdgeInsets.only(left: 10),
                                        child: Image.asset(snapshot.data == const ScreenType.home() ? 'images/png_image/select_home.png' : 'images/png_image/deselect_home.png'),
                                      ),
                                    ),

                                    // AppIcons.homeIcon(screenType: snapshot.data).toIconButton(
                                    //     onTap: () {
                                    //       prevIndex=currentIndex;
                                    //       currentIndex=0;
                                    //   feedCubit.onRefresh();
                                    //   feedCubit.changeCurrentPage(const ScreenType.home());
                                    // }),


                                    // Padding (
                                    //   padding: EdgeInsets.only(right: 0),
                                    //   child: InkWell (
                                    //     onTap: () {
                                    //
                                    //     },
                                    //     child: ,
                                    //   ),
                                    // ),

                                    Padding (
                                      padding: const EdgeInsets.only(left: 0, right: 5),
                                      child: SizedBox (
                                        height: 26,
                                        width: 26,
                                        child: InkWell (
                                          onTap: () {

                                            // PushNotificationHelper.isMessageShow = false;
                                            isMessageShow = false;
                                            AC.prefs.setBool("message", false);
                                            prevIndex=currentIndex;
                                            currentIndex=1;
                                            feedCubit.changeCurrentPage(const ScreenType.message());
                                            setState(() {});

                                          },
                                          child: Padding (
                                            padding: EdgeInsets.only(top: 1),
                                            child: Stack (
                                              children: [
                                                SizedBox (
                                                  width: 24,
                                                  height: 24,
                                                  child: Image.asset(snapshot.data == const ScreenType.message() ? 'images/png_image/select_mail.png' : 'images/png_image/deselect_mail.png'),
                                                ),
                                                Positioned (
                                                    right: 0,
                                                    top: 0,
                                                    child: Container (
                                                      height: 5,
                                                      width: 5,
                                                      child: isMessageShow ? Container (
                                                        decoration: const BoxDecoration (
                                                            color: AppColors.bottomMenu,
                                                            shape: BoxShape.circle
                                                        ),
                                                      ) : Container(),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // AppIcons.messageIcon(screenType: snapshot.data)
                                    //       .toIconButton(onTap: () {
                                    //     prevIndex=currentIndex;
                                    //     currentIndex=1;
                                    //     feedCubit.changeCurrentPage(const ScreenType.message());
                                    //   }),

                                    // _buildMiddleTabItem(),
                                    // const SizedBox(height: 30, width: 0),


                                    Padding (
                                      padding: const EdgeInsets.only(left: 40),
                                      child: SizedBox (
                                        height: 26,
                                        width: 26,
                                        child: InkWell (
                                          onTap: () {

                                            isNotificationShow = false;
                                            AC.prefs.setBool("notification", false);
                                            prevIndex=currentIndex;
                                            currentIndex=3;
                                            feedCubit.changeCurrentPage(const ScreenType.notification());
                                            setState(() {});

                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Stack (
                                              children: [
                                                SizedBox (
                                                  width: 24,
                                                  height: 24,
                                                  child: Image.asset( snapshot.data == const ScreenType.notification() ? 'images/png_image/select_notification.png' : 'images/png_image/deselect_notification.png'),
                                                ),
                                                Positioned (
                                                    right: 3,
                                                    top: 0,
                                                    child: Container (
                                                      height: 5,
                                                      width: 5,
                                                      child: isNotificationShow ? Container (
                                                        decoration: const BoxDecoration (
                                                            color: Colors.blue,
                                                            shape: BoxShape.circle
                                                        ),
                                                      ) : Container(),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // AppIcons.notificationIcon(screenType: snapshot.data)
                                    //       .toIconButton(onTap: () {
                                    //     prevIndex=currentIndex;
                                    //     currentIndex=3;
                                    //     feedCubit.changeCurrentPage(const ScreenType.notification());
                                    //   }),


                                    InkWell (
                                      onTap: () {

                                        prevIndex=currentIndex;
                                        currentIndex=4;
                                        feedCubit.changeCurrentPage(const ScreenType.search());

                                      },
                                      child: Container (
                                        width: 24,
                                        height: 24,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Image.asset(snapshot.data == const ScreenType.search() ? 'images/png_image/select_search.png' : 'images/png_image/deselect_search.png'),
                                      ),
                                    ),

                                    // AppIcons.searchIcon(screenType: snapshot.data)
                                    //       .toIconButton(onTap: () {
                                    //     prevIndex=currentIndex;
                                    //     currentIndex=4;
                                    //     feedCubit.changeCurrentPage(const ScreenType.search());
                                    //   })

                                  ],
                                ),
                              ),
                            );


                            // try {
                            // } catch(e) {
                            //   print("this error $e");
                            //   return Container();
                            // }


                      })
                    ),

                    floatingActionButton: isKeyBoardShow ? Container() : Transform.translate (
                        offset: const Offset(0, -22),
                        child: AnimatedBuilder (
                      animation: _hideButtonController,
                      builder: (context, child) {
                      return AnimatedContainer (
                          curve: Curves.bounceOut,
                          duration: Duration(microseconds: 1),
                          height: (_hideButtonController?.positions.isNotEmpty && _hideButtonController.position.userScrollDirection == ScrollDirection.reverse) ||
                              (_hideButtonController?.positions.isNotEmpty && _hideButtonController.position.userScrollDirection == ScrollDirection.forward)
                              ? 0 : 65,
                          child: Container (
                          // height: 65,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration (
                            color: Colors.blue.withOpacity(0.3),
                            shape: BoxShape.circle
                          ),
                          child: FloatingActionButton (
                            backgroundColor: AppColors.bottomMenu,
                            onPressed: () {

                              Navigator.of(context).push( PageRouteBuilder (
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) => RedeemConfirmationScreen(backRefresh: () {
                                    // prevIndex=currentIndex;
                                    // currentIndex = index;
                                    feedCubit.onRefresh();
                                    // widget.backRefresh();
                                    setState(() {});
                                  })));

                              setState(() { });

                          },
                          child: Icon(currentIndex == 2 ? Icons.close : Icons.add, size: (_hideButtonController?.positions.isNotEmpty && _hideButtonController.position.userScrollDirection == ScrollDirection.reverse) ||
                              (_hideButtonController?.positions.isNotEmpty && _hideButtonController.position.userScrollDirection == ScrollDirection.forward)
                              ? 1 : 30),
                          elevation: 2.0,
                        ),
                      ));
                    },)
                    ),

                    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget getHomeWidget() {
    return RefreshIndicator(
      onRefresh: () {
        feedCubit.onRefresh();
        feedCubit.getUserData();
        return Future.value();
      },
      // Scrollbar
      child: Scrollbar (

        child: CustomScrollView (
        controller: _hideButtonController,
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        slivers: [

          /*SliverToBoxAdapter (
            child: Container (
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              alignment: Alignment.center,
              child: ListView.builder (
                  itemCount: 10,
                  padding: EdgeInsets.only(left: 12, right: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container (
                        width: 65,
                        height: 65,
                        decoration: const BoxDecoration (
                        ),
                        child: Column (
                          children: [

                            index == 1 ? Container (
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 5, left: 5),
                              decoration: BoxDecoration (
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.blue, width: 2)
                              ),
                              child: ClipRRect (
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("images/png_image/user_test.png"),
                              ),
                            ) : Container (
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 5, left: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("images/png_image/user_test.png"),
                              ),
                            ),

                            Padding (
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Text(index == 0 ? "New" : "Jonath new", style: TextStyle(color: Color(0xFF737880), fontWeight: FontWeight.w400, fontSize: 13, fontFamily: "CeraPro"), maxLines: 1,  overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)
                            )
                          ],
                        )
                    );
                  }),
            ),
          ),*/


          /*SliverToBoxAdapter (
            child: CreatePostCard(refreshHomeScreen: (){
              feedCubit.onRefresh();
            },),
          ),*/

          PostPaginationWidget(
              isComeHome: true,
              pagingController: feedCubit.pagingController ,
              onTapLike: feedCubit.likeUnlikePost,
              onTapRepost: feedCubit.repost,
              onOptionItemTap: feedCubit.onOptionItemSelected)
          // SliverFillRemaining(child:,)
        ],
      )),
    );
  }

  onTapBottomBar(int index) {
    if (index == 0)
      feedCubit.changeCurrentPage(const ScreenType.home());
    else if (index == 1)
      feedCubit.changeCurrentPage(const ScreenType.message());
    else if (index == 2)
      feedCubit.changeCurrentPage(const ScreenType.notification());
    else
      feedCubit.changeCurrentPage(const ScreenType.search());
  }

  Widget getSelectedHomeScreen(ScreenType data) {

    return data.when (
        home: getHomeWidget,
        message: () => MessageScreen(),
        notification: () => NotificationScreen(),
        search: () => searScreen,
        profile: (args) => ProfileScreen (
              otherUserId:  args.otherUserId,
          profileUrl: args.profileUrl,
          coverUrl: args.coverUrl,
          profileNavigationEnum: args.profileNavigationEnum),
        settings: (args) => SettingsScreen (
              fromProfile: args,
            ),
        bookmarks: () => BlocProvider.value (
            value: feedCubit,
            child: BookMarkScreen()));
  }

  bool doReverse() {
   if(prevIndex==currentIndex)return false;
   return currentIndex<prevIndex;
  }

  Widget _buildMiddleTabItem() {
    return const SizedBox (
      height: 60,
      width: 70,
    );
  }

  appBarShow(ScreenType data) {

    // && currentIndex != 2
    return data == const ScreenType.home()
        ? AppBar (
      elevation: 0.0,
      brightness: Brightness.light,
      actions: [

        currentIndex == 2 ? IconButton(icon: Icon(Icons.close, color: AppColors.alertBg, size: 30), onPressed: () {
          print("hello");
        }) : Container()

      ],
      leading: [

        currentIndex == 2 ? Container() : Container (
          height: 3,
          width: 25,
          margin: EdgeInsets.only(bottom: 2, left: 13),
          decoration: BoxDecoration(
              color: AppColors.sideMenu,
              borderRadius: BorderRadius.circular(3)
          ),
        ),

        3.toSizedBox,
        currentIndex == 2 ? Container() : Container (
          height: 3,
          width: 14,
          margin: EdgeInsets.only(bottom: 2, left: 13),
          decoration: BoxDecoration(
              color: AppColors.sideMenu,
              borderRadius: BorderRadius.circular(3)
          ),
        ),
      ]
          .toColumn(mainAxisAlignment: MainAxisAlignment.center)
          .toPadding(0)
          .onTapWidget(() {
        scaffoldKey.currentState.openDrawer();
      }).toPadding(4),
      backgroundColor: Colors.white,
      title: AppIcons.appLogo.toContainer(height: 35, width: 35),
      centerTitle: true,
    ) : null;

  }

}



class MyBorderShape extends ShapeBorder {
  MyBorderShape();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  double holeSize = 80;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    print(rect.height);
    return Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2.0)))
        ..close(),
      Path()
        ..addOval(Rect.fromCenter(
            center: rect.center.translate(0, -rect.height / 1.4),
            height: holeSize,
            width: holeSize))
        ..close(),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}


class TutorialOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: Container(
          color: AppColors.alertBg.withOpacity(0.5),
          child: CreatePostCard ( refreshHomeScreen: () {
            // currentIndex = 0;
            // feedCubit.onRefresh();

            Future.delayed(Duration(seconds: 1), () {
              setState(() {});
            });

          }),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'This is a nice overlay',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Dismiss'),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}


class RedeemConfirmationScreen extends StatefulWidget {

  final Function backRefresh;
  const RedeemConfirmationScreen({Key key, this.backRefresh}) : super(key: key);

  @override
  _RedeemConfirmationScreenState createState() => _RedeemConfirmationScreenState();

}

class _RedeemConfirmationScreenState extends State<RedeemConfirmationScreen> {

  // bool isAnimation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(seconds: 1), () {
    //   isAnimation = true;
    //   setState(() { });
    // });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // isAnimation = false;
    // setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea (
      child: Scaffold (
      backgroundColor: AppColors.alertBg.withOpacity(0.5),
      body: AnimatedContainer (
        // Use the properties stored in the State class.
        width: MediaQuery.of(context).size.width,
        height: 320,
        decoration: BoxDecoration (
          color: AppColors.alertBg.withOpacity(0.5),
          // borderRadius: _borderRadius,
        ),
        // Define how long the animation should take.
        duration: const Duration(microseconds: 500),

        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.easeInCirc,
        child: Container (
          color: Colors.white,
          // height: MediaQuery.of(context).size.height / 2,
          child: CreatePostCard ( backData: (index) {

            print("hello TExt123 $index");

            Future.delayed(Duration(microseconds: 300), () {
              // prevIndex=currentIndex;
              // currentIndex = index;
              // feedCubit.onRefresh();
               widget.backRefresh();
              // setState(() {});
            });

          }),
        ),
      ),
    ));
  }
}
