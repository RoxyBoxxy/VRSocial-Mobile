import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/images.dart';
import 'package:colibri/core/widgets/animations/fade_widget.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/messages/domain/entity/message_entity.dart';
import 'package:colibri/features/messages/presentation/bloc/message_cubit.dart';
import 'package:colibri/features/messages/presentation/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageCubit messageCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageCubit = getIt<MessageCubit>()..getMessages();
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Scaffold(
      body: BlocBuilder<MessageCubit, MessageState>(
        bloc: messageCubit,
        builder: (_, state) {
          return state.when(
              initial: () => const LoadingBar(),
              success: (s) => RefreshIndicator(
                    onRefresh: () {
                      messageCubit.getMessages();
                      return Future.value();
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          leading: null,
                          elevation: 10.0,
                          expandedHeight: 100.toHeight,
                          floating: true,
                          pinned: true,
                          centerTitle: true,
                          title: "Messages".toSubTitle1(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold),
                          backgroundColor: Colors.white,
                          flexibleSpace: FlexibleSpaceBar(
                            background: [
                              'search messages...'
                                  .toSearchBarField(onTextChange: (text) {
                                    messageCubit.doSearching(text);
                                  })
                                  .toHorizontalPadding(8)
                                  .toContainer(height: 65)
                            ].toColumn(
                                mainAxisAlignment: MainAxisAlignment.end),
                          ), systemOverlayStyle: SystemUiOverlayStyle.dark,
                          // title:
                        ),
                        buildHome()
                      ],
                    ).toContainer(color: Colors.white),
                  ),
              loading: () => const LoadingBar(),
              noData: () => NoDataFoundScreen(
                    onTapButton: () {
                      BlocProvider.of<FeedCubit>(context)
                          .changeCurrentPage(const ScreenType.home());
                    },
                    icon: AppIcons.messageProfile(size: 40),
                    buttonText: "GO TO HOMEPAGE",
                    title: "No chats yet!",
                    message:
                        'Oops! It looks like you don\'t have any chat history yet. To start chatting with a user, open his profile page, then click on the chat button to start chatting',
                  ),
              error: (e) => e.toText.toCenter());
        },
      ),
    );
  }

  Widget buildHome() {
    return StreamBuilder<List<MessageEntity>>(
        stream: messageCubit.messageItems,
        initialData: [],
        builder: (context, snapshot) {
          return snapshot.data.isEmpty
              ? SliverToBoxAdapter(
                  child: StreamBuilder<String>(
                      stream: messageCubit.searchItem,
                      initialData: '',
                      builder: (context, snapshot) {
                        return NoDataFoundScreen(
                          onTapButton: () {
                            BlocProvider.of<FeedCubit>(context)
                                .changeCurrentPage(const ScreenType.home());
                          },
                          icon: Images.search.toSvg(
                              color: AppColors.colorPrimary,
                              height: 40,
                              width: 40),
                          buttonVisibility: false,
                          title: "Nothing found!",
                          message:
                              'Could not find anything in your chats history for your search query ${snapshot.data}. Please try again by typing other keywords.',
                        );
                      }),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => snapshot.data.isEmpty
                        ? const SizedBox()
                        : CustomAnimatedWidget(
                            child: OpenContainer<dynamic>(
                              closedElevation: 0.0,
                              closedBuilder: (i, c) => Dismissible(
                                confirmDismiss: (direction) async {
                                  return await context.showOkCancelAlertDialog<
                                          bool>(
                                      title: "Please confirm your actions!",
                                      desc:
                                          "Do you want to delete this chat with ${snapshot.data[index].fullName}?"
                                          " Please note that this action cannot be undone!",
                                      okButtonTitle: "Delete",
                                      onTapOk: () async {
                                        final result = await messageCubit
                                            .deleteMessage(index);
                                        ExtendedNavigator.root.pop(result);
                                        // Navigator.of(context).pop(null);
                                      });
                                },
                                direction: DismissDirection.endToStart,
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
                                      label: "Delete".toCaption(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      onPressed: () {},
                                    ),
                                  ]
                                      .toRow(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center)
                                      .toHorizontalPadding(12),
                                ),
                                key: UniqueKey(),
                                child: snapshot.data.isEmpty
                                    ? const SizedBox()
                                    : messageItem(entity: snapshot.data[index]),
                              ),
                              openBuilder: (i, c) => ChatScreen(
                                  otherPersonProfileUrl:
                                      snapshot.data[index].profileUrl,
                                  otherUserFullName:
                                      snapshot.data[index].fullName,
                                  otherPersonUserId:
                                      snapshot.data[index].userId),
                              onClosed: (s) async {
                                // context.showSnackBar(message: s);
                                // if we got cleared value then we will remove the last message only
                                if (s == null) return;
                                if (s is String) {
                                  if (s == "cleared")
                                    messageCubit.clearChat(index);
                                  else if (s == 'deleted')
                                    messageCubit.deleteChat(index);
                                } else {
                                  messageCubit.updateCurrentMessage(index, s);
                                  // context.showSnackBar(message: s.message);
                                }
                              },
                            ),
                          ),
                    childCount: snapshot.data.length,
                  ),
                );
        });
  }

  Widget messageItem({MessageEntity entity}) {
    return [
      10.toSizedBox,
      entity.profileUrl.toRoundNetworkImage(radius: 10),
      20.toSizedBox,
      [
        Row(
          children: [
            RichText(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    strutStyle: StrutStyle.disabled,
                    textWidthBasis: TextWidthBasis.longestLine,
                    text: TextSpan(
                        text: entity.fullName,
                        style: context.subTitle1.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w800)))
                .toFlexible(),
            5.toSizedBoxHorizontal,
            AppIcons.verifiedIcons.toVisibility(entity.isVerified),
            5.toSizedBoxHorizontal,
            if (context.getScreenWidth > 320)
              "@${entity.userName}".toSubTitle2(),
            [
              const Icon(
                Icons.access_time,
                color: Colors.grey,
                size: 15,
              ),
              5.toSizedBoxHorizontal,
              entity.time
                  .toSubTitle2(fontWeight: FontWeight.w400, fontSize: 10.toSp)
                  .toEllipsis
                  .toFlexible()
            ]
                .toRow(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center)
                .toContainer()
                .toExpanded()
          ],
        ),
        if (context.getScreenWidth < 321) "@${entity.userName}".toSubTitle2(),
        2.toSizedBox,
        entity.message.toCaption(maxLines: 2)
      ].toColumn().toExpanded()
    ].toRow().toPadding(16).toContainer().makeBottomBorder;
  }
}
