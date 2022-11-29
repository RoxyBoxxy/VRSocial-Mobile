



import 'package:colibri/core/common/animations.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/widgets/animations/fade_widget.dart';
import 'package:colibri/core/widgets/animations/slide_bottom_widget.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/notifications/domain/entity/notification_entity.dart';
import 'package:colibri/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:colibri/features/notifications/presentation/widgets/notification_item.dart';
import 'package:colibri/features/profile/domain/entity/follower_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:colibri/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationCubit _notificationCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationCubit=BlocProvider.of<NotificationCubit>(context);


    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if(_notificationCubit.animatedListState.currentState != null)
    //
    //     // List<int>.generate(10, (i) => i + 1).forEach((element) {
    //     //   Future.delayed(Duration(milliseconds: 800),(){
    //     //     animatedListState.currentState.insertItem(element);
    //     //   });
    //     // });
    //
    // });
    _notificationCubit.notificationPagination.deletedItems.listen((event) {
      print("inside listener ${event.length}");
    });
  }
  @override
  Widget build(BuildContext context) {

    return BlocProvider<NotificationCubit>(
          create: (_)=>_notificationCubit,
          child: Stack(children: [

            StreamBuilder<Set<int>>(
                initialData: Set(),
                stream: _notificationCubit.notificationPagination.deletedItems,
                builder: (context, snapshot) {
                  return RefreshIndicator(
                    onRefresh: (){
                      _notificationCubit.notificationPagination.onRefresh();
                      return Future.value();
                    },
                    child: PagedListView(
                        padding: const EdgeInsets.only(bottom: 80),
                        pagingController: _notificationCubit.notificationPagination.pagingController, builderDelegate: PagedChildBuilderDelegate<NotificationEntity>(
                        noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                          title: "No notifications yet!",
                          buttonText: "GO TO THE HOMEPAGE",
                          message: 'There seems to be you have no notifications yet. All notifications about replies to your posts, likes, etc., will be displayed here.',
                          icon: const Icon(FontAwesomeIcons.bell,size: 40,color: AppColors.colorPrimary,),
                          onTapButton: () {
                            BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
                            // ExtendedNavigator.root.push(Routes.createPost);
                          },
                        ),
                        itemBuilder: (_,item,index)=>CustomAnimatedWidget(
                          child: NotificationItem(
                            notificationEntity: item,onChanged: (v){
                            if(v)_notificationCubit.notificationPagination.addDeletedItem(index);
                            else _notificationCubit.notificationPagination.deleteSelectedItem(index);
                          },
                            isSelected: snapshot.data.toList().contains(index),
                          ),
                        )
                    )),
                  );
                }
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder<Set<int>>(
                  initialData: Set(),
                  stream: _notificationCubit.notificationPagination.deletedItems,
                  builder: (context, snapshot) {
                    return SlideBottomWidget(
                      doForward: snapshot.data.isNotEmpty,
                      child: Material(
                        elevation: 10.0,
                        child: ListTile(
                          title: StreamBuilder<Set<int>>(
                            initialData: Set(),
                          stream: _notificationCubit.notificationPagination.deletedItems,
                          builder: (context, snapshot) {
                            return "Delete Selected (${snapshot.data.length})".toSubTitle2(fontWeight: FontWeight.w600);
                          }
                        ),trailing: AppIcons.deleteOption(),tileColor: Colors.white,onTap: (){
                            context.showOkCancelAlertDialog(desc: "Are you sure you want to delete the selected notifications? Please note that this action cannot be undone!",
                                title: "Please confirm your actions!",okButtonTitle: "Delete",onTapOk: (){
                                  Navigator.of(context).pop();
                                  _notificationCubit.notificationPagination.deleteNotification();
                                });

                        },),
                      ),
                    );
                  }
                )),
          ],),
        );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
