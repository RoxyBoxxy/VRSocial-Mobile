import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colibri/core/common/push_notification/push_notification_helper.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/app_theme.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/images.dart';
import 'package:colibri/core/widgets/animations/slide_bottom_widget.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/core/widgets/media_picker.dart';
import 'package:colibri/core/widgets/slider.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/domain/entity/post_media.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/messages/data/models/request/delete_chat_request_model.dart';
import 'package:colibri/features/messages/domain/entity/chat_entity.dart';
import 'package:colibri/features/messages/presentation/bloc/chat_cubit.dart';
import 'package:colibri/features/messages/presentation/widgets/reviever_chat_item.dart';
import 'package:colibri/features/messages/presentation/widgets/sender_chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ChatScreen extends StatefulWidget {
  final String otherPersonUserId;
  final String otherUserFullName;
  final String otherPersonProfileUrl;
  const ChatScreen(
      {Key key,
      this.otherPersonUserId,
      this.otherUserFullName,
      this.otherPersonProfileUrl})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  ChatCubit chatCubit;
  ScrollController controller = ScrollController();
  bool chatCleared = false;
  bool chatDeleted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatCubit = getIt<ChatCubit>()
      ..chatPagination.userId = widget.otherPersonUserId;
    chatCubit.chatPagination.searchChat = false;
    PushNotificationHelper.listenNotificationOnChatScreen = (notificationItem) {
      chatCubit.changeMessageList(
          chatCubit.chatPagination.pagingController.itemList
            ..insert(0, notificationItem));
      chatCubit.chatPagination.pagingController.notifyListeners();
      // chatCubit.animatedKey?.currentState?.insertItem(0);
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.initScreenUtil();
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context,'asdas');
        // send results to prev screen
        // so that we can change data accordingly
        navigateToBackWithResult();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 120,
              width: context.getScreenWidth,
              // left: 0,
              bottom: 70,
              // height: context.getScreenHeight,
              child: BlocListener<ChatCubit, CommonUIState>(
                bloc: chatCubit,
                listener: (BuildContext context, state) {
                  state.maybeWhen(
                      orElse: () {},
                      success: (s) {
                        if (s is String) {
                          if (s.toLowerCase().contains("cleared"))
                            chatCleared = true;
                          else if (s.toLowerCase().contains("deleted")) {
                            chatDeleted = true;
                            navigateToBackWithResult();
                          }
                          context.showSnackBar(message: s);
                        }
                      },
                      error: (e) =>
                          context.showSnackBar(isError: true, message: e));
                },
                child: BlocBuilder<ChatCubit, CommonUIState>(
                  bloc: chatCubit,
                  builder: (c, state) => state.maybeWhen(
                      orElse: () => const LoadingBar(),
                      success: (s) => buildRefreshIndicator(),
                      error: (e) => buildRefreshIndicator()),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                width: context.getScreenWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: chatCubit.message.onChange,
                      controller: chatCubit.message.textController,
                      // style: AppTheme.button.copyWith(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "Send a Message",
                        contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintStyle: context.subTitle2,
                        labelStyle: AppTheme.caption
                            .copyWith(fontWeight: FontWeight.bold),
                        suffixIcon: SvgPicture.asset(
                          Images.chatImage,
                          height: 10,
                          width: 10,
                        ).toPadding(14).onTapWidget(() async {
                          await openMediaPicker(context, (image) async {
                            chatCubit.sendImage(
                                image, widget.otherPersonUserId);
                          }, mediaType: MediaTypeEnum.IMAGE);
                        }),
                      ),
                    )
                        .toContainer(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: const Color(0xFFECF1F6),
                                borderRadius: BorderRadius.circular(40)))
                        .toFlexible(),
                    // TextField(
                    //   onChanged: chatCubit.message.onChange,
                    //   controller: chatCubit.message.textController,
                    //   style: AppTheme.button.copyWith(fontWeight: FontWeight.w500),
                    //   decoration: InputDecoration(
                    //       labelStyle: AppTheme.caption.copyWith(fontWeight: FontWeight.bold),
                    //       // suffixIcon: SvgPicture.asset(Images.chatImage,height: 10,width: 10,).toPadding(14).onTap(() {
                    //       //   openMediaPicker(context,(image)async{
                    //       //           chatCubit.sendImage(image, widget.otherPersonUserId);
                    //       //   },mediaType: MediaTypeEnum.IMAGE);
                    //       // }),
                    //       // contentPadding: const EdgeInsets.only(top: 20,left: 20),
                    //       hintText: "Send a message",border: InputBorder.none),).toContainer(
                    //     height: 56,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xFFECF1F6),
                    //         borderRadius: BorderRadius.circular(40))
                    // ).toFlexible(),
                    SvgPicture.asset(
                      Images.sendIcon,
                      height: 24,
                    ).toHorizontalPadding(12).onTapWidget(() async {
                      if (chatCubit.message.text.trim().isNotEmpty) {
                        chatCubit.sendMessage(widget.otherPersonUserId);
                        chatCubit.message.textController.clear();
                      } else {
                        context.showSnackBar(
                            message: "Please enter a valid text",
                            isError: true);
                      }
                    }, removeFocus: false)
                    // ,
                  ],
                ).toPadding(8)),
            buildFloatingSearchBar(),
          ],
        ),
      ),
    );
  }

  RefreshIndicator buildRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: () {
        chatCubit.chatPagination.searchChat = false;
        chatCubit.chatPagination.onRefresh();
        return Future.value();
      },
      child: PagedListView(
        reverse: true,
        pagingController: chatCubit.chatPagination.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ChatEntity>(
            noItemsFoundIndicatorBuilder: (i) => NoDataFoundScreen(
                  onTapButton: () {
                    // ExtendedNavigator.root.push(Routes.createPost);
                  },
                  title: "No Messages yet!",
                  buttonText: "GO TO THE HOMEPAGE",
                  message: "",
                  buttonVisibility: false,
                ),
            itemBuilder: (BuildContext context, item, int index) => Container(
                    width: context.getScreenWidth,
                    child: item.isSender
                        ? SenderChatItem(chatEntity: item)
                        : ReceiverChatItem(
                            otherUserProfileUrl: widget.otherPersonProfileUrl,
                            chatEntity: item))
                .toSwipeToDelete(
                    key: UniqueKey(),
                    onDismissed: () {
                      chatCubit.deleteMessage(index);
                      // context.showSnackBar(;
                    })),
      ),
    );
  }

  AnimatedList buildAnimatedList(BuildContext context, List<ChatEntity> chat,
      AsyncSnapshot<List<ChatEntity>> snapshot) {
    print("Message data ==> $chat");

    return AnimatedList(
      physics: const AlwaysScrollableScrollPhysics(),
      key: chatCubit.animatedKey,
      reverse: true,
      itemBuilder: (c, index, animation) => SizeTransition(
        key: ValueKey(index),
        sizeFactor: animation,
        child: Container(
          width: context.getScreenWidth,
          child: chat[index].isSender
              ? SenderChatItem(chatEntity: chat[index])
              : ReceiverChatItem(
                  otherUserProfileUrl: widget.otherPersonProfileUrl,
                  chatEntity: chat[index]),
        ).toSwipeToDelete(
            key: ValueKey(index),
            onDismissed: () {
              chatCubit.deleteMessage(index);
              // context.showSnackBar(;
            }),
      ),
      initialItemCount: snapshot.data.length,
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final floatingSearchBarController = FloatingSearchBarController();

    return FloatingSearchBar(
      controller: floatingSearchBarController,
      hint: 'search messages...',
      hintStyle: context.subTitle2.copyWith(fontWeight: FontWeight.w600),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 400),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      automaticallyImplyBackButton: false,

      leadingActions: [
        BackButton(
          onPressed: () {
            // if(isPortrait)
            if (floatingSearchBarController.isClosed)
              navigateToBackWithResult();
            else
              floatingSearchBarController.close();
            // else

            // ExtendedNavigator.root.pop();
          },
        )
      ],
      openAxisAlignment: 0.0,
      openWidth: isPortrait ? 600 : 500,
      // elevation: isPortrait?2.0:10,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        chatCubit.chatPagination.searchChat = true;
        chatCubit.chatPagination.queryText = query;
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        ["Delete Chat", "Clear Chat"].toPopUpMenuButton(onTapOptions,
            icon: RotatedBox(quarterTurns: 45, child: AppIcons.optionIcon)),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return const SizedBox();
      },
    );
  }

  onTapOptions(String value) async {
    if (value == "Delete Chat") {
      return await context.showOkCancelAlertDialog<bool>(
          title: "Please confirm your actions!",
          desc:
              "Do you want to delete this chat with ${widget.otherUserFullName}? Please note that this action cannot be undone!",
          okButtonTitle: "Delete",
          onTapOk: () async {
            // var result=await messageCubit.deleteMessage(index);
            Navigator.of(context).pop();
            chatCubit.deleteAllMessages(DeleteChatRequestModel(
                userId: widget.otherPersonUserId, deleteChat: true));
          });
      // context.showOkCancelAlertDialog(desc: null, title: null);

    } else {
      return await context.showOkCancelAlertDialog<bool>(
          title: "Please confirm your actions!",
          desc:
              "Are you sure you want to delete all messages in the chat with ${widget.otherUserFullName}?"
              " Please note that this action cannot be undone!",
          okButtonTitle: "Clear",
          onTapOk: () async {
            // var result=await messageCubit.deleteMessage(index);
            Navigator.of(context).pop();
            chatCubit.deleteAllMessages(DeleteChatRequestModel(
                userId: widget.otherPersonUserId, deleteChat: false));
          });
    }
  }

  void navigateToBackWithResult() {
    if (chatDeleted) {
      ExtendedNavigator.root.pop("deleted");
    } else if (chatCleared) {
      ExtendedNavigator.root.pop("cleared");
    } else
      ExtendedNavigator.root.pop(chatCubit.getLastMessage());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // clearing listener
    PushNotificationHelper.listenNotificationOnChatScreen = null;
    super.dispose();
  }
}
