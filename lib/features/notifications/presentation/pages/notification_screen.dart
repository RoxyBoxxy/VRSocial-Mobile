import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/images.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/notifications/domain/entity/notification_entity.dart';
import 'package:colibri/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:colibri/features/notifications/presentation/pages/mentions_page.dart';
import 'package:colibri/features/notifications/presentation/pages/notification_page.dart';
import 'package:colibri/features/notifications/presentation/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = getIt<NotificationCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => _notificationCubit,
      child: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: null,
                  elevation: 5.0,
                  expandedHeight: 60.toHeight,
                  floating: true,
                  pinned: true,
                  // title: Text('Profile'),
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                    preferredSize: Size(context.getScreenWidth, 56.toHeight),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          top: 0.0,
                          child: Container(
                            color: Colors.white,
                          ).makeBottomBorder,
                        ),
                        const TabBar(
                          tabs: [
                            // "Hashtags".toTab(),
                            Tab(text: "Notifications"),
                            Tab(text: "Mentions"),
                            // "People".toTab(),
                            // "Posts".toTab(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // bottom: TabBar(
                  //   tabs: [
                  //     Tab(text: "Notifications"),
                  //     Tab(text: "Mentions"),
                  //   ],
                  // ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      NotificationPage(),
                      MentionsPage()
                      // [
                      //   SvgPicture.asset(Images.atRate,height: 80,),
                      //   "No mentions yet!".toSubTitle2(),
                      //     10.toSizedBox,
                      //   "There seems to be no mention, All links to you in user application will be displayed here".toCaption(textAlign: TextAlign.center).toHorizontalPadding(32),
                      //   10.toSizedBox,
                      //   "Go to homepage".toButton().toFlatButton(() {
                      //     BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                      //   },border: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(24.0),
                      //       side: BorderSide(color: Colors.black)
                      //   ))
                      // ].toColumn(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center)
                      // ListView(children: List<Widget>.generate(5, (index) => NotificationItem()),),
                    ],
                  ),
                )
              ],
            ).toSafeArea,
          ],
        ),
      ),
    );
  }
}
