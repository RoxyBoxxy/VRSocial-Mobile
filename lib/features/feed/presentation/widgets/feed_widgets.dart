import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:colibri/core/common/add_thumbnail/check_link.dart';
import 'package:colibri/core/common/social_share/social_share.dart';
import 'package:colibri/core/common/widget/menu_item_widget.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/core/widgets/slider.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/pages/feed_screen.dart';
import 'package:colibri/features/feed/presentation/widgets/all_home_screens.dart';
import 'package:colibri/features/posts/domain/entiity/reply_entity.dart';
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart';
import 'package:colibri/features/posts/presentation/pages/create_post.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/presentation/pages/followers_following_screen.dart';
import 'package:colibri/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remove_emoji/remove_emoji.dart';

class PostItem extends StatefulWidget {
  final bool isComeHome;
  final bool showThread;
  final bool showArrowIcon;
  final bool otherUser;
  final bool isLiked;
  final PostEntity? postEntity;
  final VoidCallback? onLikeTap;
  final VoidCallback? onTapRepost;
  final StringToVoidFunc? onPostOptionItem;
  final bool detailedPost;
  final VoidCallback? onRefresh;
  final ValueChanged<String>? onTapMention;

  // helps use to increase the count of comment without fetching the data again
  final ValueChanged<bool>? replyCountIncreased;

  // using to check if user is already inside search screen
  // so that we don't need to navigate to search screen again
  // if already inside search screen we will just change the searched result
  // if not we will navigate to search screen
  final bool insideSearchScreen;

  // helps to navigate
  final ProfileNavigationEnum profileNavigationEnum;
  const PostItem(
      {Key? key,
      this.isComeHome = true,
      this.showThread = true,
      this.showArrowIcon = false,
      this.detailedPost = false,
      this.otherUser = false,
      this.isLiked = false,
      this.postEntity,
      this.onLikeTap,
      this.onRefresh,
      this.onTapRepost,
      this.onPostOptionItem,
      this.onTapMention,
      this.profileNavigationEnum = ProfileNavigationEnum.FROM_FEED,
      this.insideSearchScreen = false,
      this.replyCountIncreased})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState(otherUser: otherUser);
}

class _PostItemState extends State<PostItem> {
  final bool otherUser;
  MySocialShare? mySocialShare;
  _PostItemState({this.otherUser = false});

  int currentIndex = 0;

  bool isKeyBoardShow = false;

  ScrollController _controller = new ScrollController();

  String url1 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySocialShare = getIt<MySocialShare>();

    // _parseHtmlString(widget.postEntity.description);
    checkIsKeyBoardShow();
  }

  checkIsKeyBoardShow() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        if (visible) {
          scrollAnimated(1000);
        }
        isKeyBoardShow = visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _postItem(otherUser: this.otherUser);
  }

  Widget _postItem({otherUser = false}) {
    return Container(
      child: Column(children: [
        // 15.toSizedBox.toVisibility(widget?.postEntity?.showRepostedText ?? false),
        // widget?.postEntity?.showRepostedText ?? false ? SizedBox(height:  AC.getDeviceHeight(context) * 0.018) :  Container(),
        // 16.toSizedBox.toVisibility(widget.detailedPost),

        // [
        //   2.toSizedBox.toExpanded(flex: 2).toVisibility(widget.detailedPost),
        //   // 10.toSizedBox.toVisibility(!widget.detailedPost),
        //   [
        //     AppIcons.repostIcon(),
        //     12.toSizedBox,
        //     "${widget.postEntity.reposterFullname.toString().toUpperCase()} REPOSTED".toSubTitle2(fontSize: 10,fontWeight: FontWeight.w400, fontFamily1: "CeraPro").toEllipsis.toFlexible()
        //   ].toRow().toExpanded(flex: 8)
        // ].toRow().toVisibility(widget?.postEntity?.showRepostedText ?? false),

        widget.postEntity?.showRepostedText ?? false
            ? Padding(
                padding: EdgeInsets.only(
                    left: 73,
                    right: 10,
                    top: AC.getDeviceHeight(context) * 0.018),
                child: Row(
                  children: [
                    AppIcons.repostIcon(),
                    12.toSizedBox,
                    "${widget.postEntity!.reposterFullname.toString().toUpperCase()} REPOSTED"
                        .toSubTitle2(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            fontFamily1: "CeraPro")
                        .toEllipsis
                        .toFlexible()
                  ],
                ),
              )
            : Container(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            [
              Padding(
                  padding: EdgeInsets.only(
                      top: AC.getDeviceHeight(context) * 0.013,
                      right: 10,
                      left: 0), //top 15
                  child: widget.postEntity!.profileUrl!
                      .toRoundNetworkImage(radius: 11)
                      .toContainer(alignment: Alignment.topRight)
                      .toVerticalPadding(0)
                      .onTapWidget(() {
                    // context.showSnackBar(
                    // message: widget.postEntity.otherUserId ?? "No user id");
                    navigateToProfile();
                  }))
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.end)
                .toVisibility(widget.detailedPost),

            [
              // 12.toSizedBox.toVisibility(widget.detailedPost),
              widget.detailedPost
                  ? SizedBox(height: AC.getDeviceHeight(context) * 0.010)
                  : Container(),

              [
                [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    strutStyle: StrutStyle.disabled,
                    textWidthBasis: TextWidthBasis.longestLine,
                    text: TextSpan(
                        text: widget.postEntity!.name,
                        style: context.subTitle1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: AC.device17(context),
                            fontFamily: "CeraPro")),
                  ).onTapWidget(() {
                    navigateToProfile();
                  }).toFlexible(flex: 2),
                  5.toSizedBoxHorizontal,
                  AppIcons.verifiedIcons
                      .toVisibility(widget.postEntity!.postOwnerVerified),

                  5.toSizedBoxHorizontal,
                  Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(widget.postEntity!.time!,
                          style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: AC.getDeviceHeight(context) * 0.015,
                              fontWeight: FontWeight.w400,
                              fontFamily: "CeraPro")))
                  // widget.postEntity.time.toCaption(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500, )
                ]
                    .toRow(crossAxisAlignment: CrossAxisAlignment.center)
                    .toFlexible(),
                6.toSizedBoxHorizontal

                // [ // old time code
                //   Container(
                //   height: 5,
                //   width: 5,
                //   decoration:
                //   const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                // ),
                //   5.toSizedBoxHorizontal,
                //   widget.postEntity.time.toCaption(),].toRow(crossAxisAlignment: CrossAxisAlignment.center)
              ]
                  .toRow(crossAxisAlignment: CrossAxisAlignment.center)
                  .toContainer(),
              3.toSizedBoxVertical,

              InkWell(
                onTap: () {
                  navigateToProfile();
                },
                child: SizedBox(
                  height: 15,
                  child: Text(widget.postEntity!.userName!,
                      style: TextStyle(
                          color: const Color(0xFF737880),
                          fontSize: AC.getDeviceHeight(context) * 0.015,
                          fontWeight: FontWeight.w400,
                          fontFamily: "CeraPro")),
                ),
              ),

              // "${widget.postEntity.userName}".toCaption(
              //     fontWeight: FontWeight.w500, color: Colors.black54, fontSize: 13, ).onTapWidget(() {
              //       navigateToProfile();
              // }),

              ///working.
              5.toSizedBox.toVisibility(widget.postEntity!.responseTo != null),
              [
                "In response to".toCaption(
                    fontSize: 13,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    color: AppColors.greyText),

                // 0.toSizedBoxHorizontal,

                // if (widget.postEntity.responseTo != null)
                //   RichText(
                //     overflow: TextOverflow.ellipsis,
                //     text: TextSpan(
                //         text: widget.postEntity.responseTo,
                //         style: context.caption.copyWith(
                //             color: AppColors.colorPrimary, fontWeight: FontWeight.w600),
                //       // children: <TextSpan> [
                //       //
                //       //   const TextSpan(text: ' Post', style: TextStyle(color: AppColors.textColor, fontSize: 13, fontWeight: FontWeight.w500)),
                //       // ],
                //     ),
                //
                //
                //   ).onTapWidget(() {
                //     // context.showSnackBar(message: widget.postEntity.isOtherUser?widget.postEntity.responseToUserId:null);
                //     /// will pass null if the post is owned by current user
                //     /// else will pass user id of other user
                //     ExtendedNavigator.root.push(Routes.profileScreen,arguments: ProfileScreenArguments(
                //         otherUserId: widget.postEntity.isOtherUser?widget.postEntity.responseToUserId:null));
                //   }).toFlexible(),

                if (widget.postEntity!.responseTo != null)
                  InkWell(
                    onTap: () {
                      ExtendedNavigator.root.push(Routes.profileScreen,
                          arguments: ProfileScreenArguments(
                              otherUserId: widget.postEntity!.isOtherUser
                                  ? widget.postEntity!.responseToUserId
                                  : null));
                    },
                    child: widget.postEntity!.responseTo!.toCaption(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ),

                // 0.toSizedBoxHorizontal,
                "Post".toCaption(
                    fontSize: 13,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: AppColors.greyText) //AC.device12(context)
              ].toWrap().toVisibility(widget.postEntity!.responseTo != null &&
                  widget.postEntity!.responseTo!.isNotEmpty),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.center)
                .toExpanded(flex: 8),

            // [
            //   Container(
            //     height: 5,
            //     width: 5,
            //     decoration:
            //     const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            //   ),
            //   5.toSizedBoxHorizontal,0
            //   widget.postEntity.time.toCaption(),].toRow(crossAxisAlignment: CrossAxisAlignment.center),

            [
              InkWell(
                onTap: () {
                  print("hello");

                  /// bottom sheet showing
                  bottomSheet();
                  // reportBottomSheet();
                },
                child: Container(
                  height: 30,
                  width: 15,
                  margin: const EdgeInsets.only(top: 3, right: 10),
                  child: Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey.withOpacity(0.6), size: 25),
                ),
              )
            ].toRow(crossAxisAlignment: CrossAxisAlignment.center),

            ///old code
            // getPostOptionMenu(showThread, showArrowIcon, otherUser)
          ],
        ).toHorizontalPadding(20),

        [
          if (!widget.detailedPost)
            20.toSizedBoxHorizontal
          else
            75.toSizedBoxHorizontal,
          [
            5.toSizedBox.toVisibility(widget.postEntity!.responseTo != null),
            if (widget.postEntity!.description.isNotEmpty)
              widget.postEntity!.description.toSubTitle1(
                  fontWeight: FontWeight.w400,
                  align: TextAlign.left,
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily1: "CeraPro",
                  onTapHashtag: (hTag) {
                    if (!widget.insideSearchScreen)
                      ExtendedNavigator.root.push(Routes.searchScreen,
                          arguments: SearchScreenArguments(
                              searchedText: RemoveEmoji().removemoji(hTag)));
                    else
                      BlocProvider.of<PostCubit>(context).searchedText = hTag;
                  },
                  onTapMention: (mention) {
                    ExtendedNavigator.root.push(Routes.profileScreen,
                        arguments:
                            ProfileScreenArguments(otherUserId: mention));
                    // context.showSnackBar(message: "$mention needs api changes");
                  }),
            5
                .toSizedBox
                .toVisibility(widget.postEntity!.description.isNotEmpty),

            const SizedBox(height: 5),

            //CheckLink.checkYouTubeLink(widget.postEntity.description) != null

            Container(
              child: imageVideoSliderData(),
            ),

            5.toSizedBox.toVisibility(widget.postEntity!.media.isNotEmpty),
            [
              [
                // OpenContainer(
                //
                //   transitionDuration: Duration(milliseconds: 500),
                //     closedElevation: 0,
                //     openElevation: 0,
                //     closedBuilder: (s,close)=>buildPostButton(AppIcons.commentIcon,
                //     widget.postEntity.commentCount ?? "").toPadding(8), openBuilder: (c,open)=>InkWell(
                //   onTap: (){
                //     ExtendedNavigator.root.push(Routes.createPost,arguments: CreatePostArguments(
                //       title: "Reply",replyTo: widget.postEntity.userName,
                //       threadId: widget.postEntity.postId,replyEntity: ReplyEntity.fromPostEntity(postEntity: widget.postEntity),
                //     ));
                //   },
                //       child: CreatePost(title: "Reply",replyTo: widget.postEntity.userName,
                //   threadId: widget.postEntity.postId,replyEntity: ReplyEntity.fromPostEntity(postEntity: widget.postEntity),),
                //     )),

                InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (c) => DraggableScrollableSheet(
                              initialChildSize: 1, //set this as you want
                              maxChildSize: 1, //set this as you want
                              minChildSize: 1, //set this as you want
                              expand: true,
                              builder: (BuildContext context,
                                      ScrollController scrollController) =>
                                  Container(
                                margin: EdgeInsets.only(
                                    top: MediaQueryData.fromWindow(
                                            WidgetsBinding.instance.window)
                                        .padding
                                        .top),
                                child: CreatePost(
                                    title: "Reply",
                                    replyTo: widget.postEntity!.userName,
                                    threadId: widget.postEntity!.postId,
                                    replyEntity: ReplyEntity.fromPostEntity(
                                        postEntity: widget.postEntity!)),
                              ),
                            )).then((value) {
                      if (value != null && value)
                        widget.replyCountIncreased!(true);
                      // setState(() {
                      //   widget.postEntity=widget.postEntity.copyWith(commentCount: widget.postEntity.commentCount.inc.toString());
                      // });
                    });
                    // ExtendedNavigator.root.pop();
                    // await ExtendedNavigator.root.push(Routes.viewPostScreen,
                    //     arguments: ViewPostScreenArguments(
                    //         threadID: widget.postEntity.threadID));
                    // widget?.onRefresh?.call();
                  },

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Image(
                              height: 20,
                              width: 20,
                              image: AssetImage("images/png_image/message.png"),
                              color: Color(0xFF737880))),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 0, left: 5),
                          child: Text(widget.postEntity!.commentCount ?? "",
                              style: const TextStyle(
                                  color: Color(0xFF737880),
                                  fontFamily: "CeraPro",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14)))
                    ],
                  ),

                  // child: buildPostButton(const Image (
                  //           height: 20,
                  //           width: 20,
                  //           image: AssetImage("images/png_image/message.png"), color: const Color(0xFF737880),
                  // ),
                  //     widget.postEntity.commentCount ?? "", color: const Color(0xFF737880)),

                  // child: buildPostButton(AppIcons.commentIcon,
                  //         widget.postEntity.commentCount ?? "").toPadding(8),
                ),

                InkWell(
                  onTap: () {
                    widget.onLikeTap!.call();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Image(
                              height: 20,
                              width: 20,
                              image: AssetImage(widget.postEntity!.isLiked!
                                  ? "images/png_image/heart.png"
                                  : "images/png_image/like.png"),
                              color: widget.postEntity!.isLiked!
                                  ? Colors.red
                                  : Color(0xFF737880))),
                      // ? AppIcons.heartIcon(color: Colors.red)
                      // : AppIcons.likeIcon(color: const Color(0xFF737880))),

                      Padding(
                          padding: const EdgeInsets.only(bottom: 0, left: 5),
                          child: Text(widget.postEntity!.likeCount ?? "0",
                              style: TextStyle(
                                  color: widget.postEntity!.isLiked!
                                      ? Colors.red
                                      : Color(0xFF737880),
                                  fontFamily: "CeraPro",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14)))
                    ],
                  ),
                  // child: buildPostButton (
                  //     widget.postEntity.isLiked
                  //         ? AppIcons.heartIcon
                  //         : AppIcons.likeIcon,
                  //     widget.postEntity.likeCount ?? "",
                  //     isLiked: widget.postEntity.isLiked ?? false,
                  //     color: widget.postEntity.isLiked ? Colors.red : const Color(0xFF737880)).toPadding(8),
                ),

                InkWell(
                  onTap: () {
                    widget.onTapRepost!.call();
                    if (!widget.postEntity!.isReposted!) {
                      context.showSnackBar(message: "Re-Post successfully");
                    }
                  },

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Image(
                              height: widget.postEntity!.isReposted! ? 17 : 20,
                              width: widget.postEntity!.isReposted! ? 17 : 20,
                              image: AssetImage(widget.postEntity!.isReposted!
                                  ? "images/png_image/blur_share.png"
                                  : "images/png_image/re_post.png"),
                              color: widget.postEntity!.isReposted!
                                  ? AppColors.alertBg
                                  : Color(0xFF737880))),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 0, left: 5),
                          child: Text(widget.postEntity!.repostCount ?? "",
                              style: TextStyle(
                                  color: widget.postEntity!.isReposted!
                                      ? AppColors.alertBg
                                      : Color(0xFF737880),
                                  fontFamily: "CeraPro",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14)))
                    ],
                  ),

                  // child: buildPostButton(
                  //            Image (
                  //             height: 20,
                  //             width: 20,
                  //             image: const AssetImage("images/png_image/re_post.png"),
                  //               color: widget.postEntity.isReposted
                  //                       ? AppColors.colorPrimary
                  //                       : const Color(0xFF737880)),
                  //         // AppIcons.repostIcon(
                  //         //     color: widget.postEntity.isReposted
                  //         //         ? AppColors.colorPrimary
                  //         //         : AppColors.textColor),
                  //         widget.postEntity.repostCount ?? "",
                  //         color: AppColors.colorPrimary,
                  //         isLiked: widget.postEntity.isReposted)
                  //     .toPadding(8),

                  // child: buildPostButton(
                  //         AppIcons.repostIcon(
                  //             color: widget.postEntity.isReposted
                  //                 ? AppColors.colorPrimary
                  //                 : AppColors.textColor),
                  //         widget.postEntity.repostCount ?? "",
                  //         color: AppColors.colorPrimary,
                  //         isLiked: widget.postEntity.isReposted)
                  //     .toPadding(8),
                ),

                const Image(
                        height: 20,
                        width: 20,
                        image: const AssetImage("images/png_image/share.png"),
                        color: const Color(0xFF737880))
                    .toPadding(0)
                    .onTapWidget(() {
                  mySocialShare!.shareToOtherPlatforms(
                      text: widget.postEntity!.urlForSharing!);
                })

                // AppIcons.shareIcon.toPadding(8).onTapWidget(() {
                //   mySocialShare.shareToOtherPlatforms(text: widget.postEntity.urlForSharing);
                // })

                // getShareOptionMenu(share: mySocialShare,
                //     text: widget.postEntity.urlForSharing,
                //     // text: "https://sm-colibri.ru/thread/8355",
                //     ).toContainer()
              ]
                  .toRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center)
                  .toExpanded(),
            ].toRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly),

            // 5.toSizedBox,
            Container(
              height: 2,
            )
            /*  widget.isComeHome ? Container (
              width: MediaQuery.of(context).size.width, height: 2, color: AppColors.lightBlur1,
              margin: EdgeInsets.only(bottom: 0, top: AC.getDeviceHeight(context) * 0.02),
            ) : Container()*/
          ]
              .toColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start)
              .toExpanded(flex: 10),
          10.toSizedBox.toExpanded(flex: 1)
        ].toRow(),

        // Divider(thickness: 1,color: AppColors.sfBgColor,).toVisibility(widget.postEntity.parentPostTime.isNotEmpty),
        // widget.postEntity.parentPostTime.toCaption(fontWeight: FontWeight.bold).toContainer().toHorizontalPadding(16).toVisibility(widget.postEntity.parentPostTime.isNotEmpty),

        // const Divider (
        //   thickness: 2,
        //   color: AppColors.sfBgColor,
        // ).toVisibility(widget.postEntity.isConnected),

        const Divider(
          thickness: 2,
          color: AppColors.sfBgColor,
        ).toVisibility(widget.postEntity!.isConnected),

        7.toSizedBox,
      ]),
    );
  }

  Widget getPostOptionMenu(
      bool showThread, bool showArrowIcon, bool otherUser) {
    return [
      // if(!otherUser)
      //   "Edit",
      // if(otherUser)
      //   "Pin to profile",
      // if (showThread) "Show Thread",
      // "Share",
      MenuItemWidget(
          text: !widget.postEntity!.isSaved! ? "Bookmark" : "UnBookmark",
          icon: AppIcons.bookmarkOption(size: 16).toHorizontalPadding(2)),
      MenuItemWidget(
        icon: AppIcons.likeOption(size: 14),
        text: "Show likes",
      ),
      // "Show repost",

      if (!widget.postEntity!.isOtherUser)
        MenuItemWidget(
          text: "Delete",
          icon: AppIcons.deleteOption(size: 14).toHorizontalPadding(1),
        ),
    ]
        .toPopWithMenuItems((value) {
          print("hello test data $value");
          widget.onPostOptionItem!(value);
        },
            icon: showArrowIcon
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.withOpacity(.8),
                    ),
                  )
                : AppIcons.optionIcon)
        .toContainer(
          alignment: Alignment.topCenter,
        )
        .toExpanded(flex: 1);
  }

  void navigateToProfile() {
    ExtendedNavigator.root.push(Routes.profileScreen,
        arguments: ProfileScreenArguments(
            otherUserId: widget.postEntity!.userName!.split("@")[1]));
    // ExtendedNavigator.root.push(Routes.profileScreen,arguments: ProfileScreenArguments(otherUserId: widget.postEntity.otherUserId));
    // if (widget.postEntity.isOtherUser) {
    //   BlocProvider.of<FeedCubit>(context).changeCurrentPage(
    //       ScreenType.profile(ProfileScreenArguments(
    //         otherUserId: widget.postEntity.otherUserId,
    //         coverUrl: widget.postEntity.coverUrl,
    //         profileUrl: widget.postEntity.profileUrl,
    //         profileNavigationEnum: widget.profileNavigationEnum
    //       )));
    // } else {
    //   BlocProvider.of<FeedCubit>(context).changeCurrentPage(
    //       ScreenType.profile(
    //           ProfileScreenArguments(otherUserId: null,
    //             coverUrl: widget.postEntity.coverUrl,
    //             profileUrl: widget.postEntity.profileUrl,
    //             profileNavigationEnum: widget.profileNavigationEnum
    //           )));
    // }
  }

  bottomSheet() {
    print("hello 123");
    print(widget.postEntity!.isOtherUser);
    print(widget.postEntity!.otherUserId);
    print(loginResponseFeed!.data!.user!.userName);

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: widget.postEntity!.isOtherUser &&
                      widget.postEntity!.userName !=
                          "@${loginResponseFeed!.data!.user!.userName}"
                  ? 162
                  : 162, //207
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 15, bottom: 20),
              decoration: const BoxDecoration(
                  color: Color(0xff0e8df1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 6,
                    width: 37,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: const Color(0xff0560b2),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                        // borderRadius: const BorderRadius.all(5)
                        ),
                  ),

                  // SizedBox(height: 50),

                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                        widget.postEntity!.isOtherUser &&
                                widget.postEntity!.userName !=
                                    "@${loginResponseFeed!.data!.user!.userName}"
                            ? InkWell(
                                onTap: () {
                                  // widget.onPostOptionItem(!widget.postEntity.isSaved ? "Bookmark" : "UnBookmark");
                                  Navigator.pop(context);

                                  widget.onPostOptionItem!("Show likes");
                                },
                                child: Container(
                                  height: 25,
                                  margin: const EdgeInsets.only(top: 30), //10
                                  child: Row(
                                    children: [
                                      // Images.bookmarkOption.toSvg(height: 25, width: 25, color: Colors.white),
                                      Image.asset(
                                          "images/png_image/white_like.png",
                                          color: Colors.white),
                                      const SizedBox(width: 20),
                                      Text("Show likes",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "CeraPro"))
                                    ],
                                  ),
                                ),
                              )
                            : Container(),

                        InkWell(
                          onTap: () {
                            widget.onPostOptionItem!(
                                !widget.postEntity!.isSaved!
                                    ? "Bookmark"
                                    : "UnBookmark");
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25,
                            margin: const EdgeInsets.only(top: 15), //10
                            child: Row(
                              children: [
                                // Images.bookmarkOption.toSvg(height: 25, width: 25, color: Colors.white),
                                Image.asset("images/png_image/book_mark.png"),
                                const SizedBox(width: 20),
                                Text(
                                    !widget.postEntity!.isSaved!
                                        ? "Bookmark"
                                        : "UnBookmark",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "CeraPro"))
                              ],
                            ),
                          ),
                        ),

                        // const SizedBox(width: 25),

                        widget.postEntity!.isOtherUser &&
                                widget.postEntity!.userName !=
                                    "@${loginResponseFeed!.data!.user!.userName}"
                            ?
                            /*InkWell (
                          onTap: () {
                            Navigator.pop(context);
                            reportBottomSheet();
                            // widget.onPostOptionItem("Show likes");
                          },
                          child: Container (
                            height: 25,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row (
                              children: [

                                Image.asset("images/png_image/flag.png"),
                                // Images.likeOption.toSvg(height: 20, width: 18, color: Colors.white),
                                const SizedBox(width: 20),
                                const Text("Report", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400))

                              ],
                            ),
                          ),
                        )*/
                            Container()
                            : InkWell(
                                onTap: () {
                                  print("Hel");
                                  Navigator.pop(context);
                                  widget.onPostOptionItem!("Delete");
                                },
                                child: Container(
                                  height: 25,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      // Images.delete.toSvg(height: 20, width: 20, color: Colors.white),
                                      Image.asset(
                                          "images/png_image/delete_trash.png"),
                                      const SizedBox(width: 20),
                                      const Text("Delete",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "CeraPro"))
                                    ],
                                  ),
                                ),
                              )
                      ]))
                ],
              ),
            ));
  }

  reportBottomSheet() {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 525,
            // height: MediaQuery.of(context).size.height / 1.40,
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
            decoration: const BoxDecoration(
                color: const Color(0xFFFFFFFF),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(-1, 1))
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF1D88F0).withOpacity(0.09),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 6,
                          width: 37,
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                          decoration: BoxDecoration(
                              color: Color(0xFF045CB1).withOpacity(0.1),
                              borderRadius: BorderRadius.all(Radius.circular(6))
                              // borderRadius: const BorderRadius.all(5)
                              ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text("Report this post",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "CeraPro",
                                fontWeight: FontWeight.w400,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ),
//78

                Expanded(
                    child: SingleChildScrollView(
                  controller: _controller,
                  padding: EdgeInsets.only(
                      left: 15,
                      right: 10,
                      top: 5,
                      bottom: isKeyBoardShow ? 310 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          // widget.onPostOptionItem(!widget.postEntity.isSaved ? "Bookmark" : "UnBookmark");
                          Navigator.pop(context);
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 10),
                              child: const Text("What's the problem?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16)),
                            )),
                      ),
                      const SizedBox(height: 15),
                      radioSelection("This is spam", 0, setState),
                      const SizedBox(height: 20),
                      radioSelection("Misleading or fraudulent", 1, setState),
                      const SizedBox(height: 20),
                      radioSelection(
                          "Publication or private information", 2, setState),
                      const SizedBox(height: 20),
                      radioSelection(
                          "Threats of violence or physical harm", 3, setState),
                      const SizedBox(height: 20),
                      radioSelection(
                          "I am not interested in this post", 4, setState),
                      const SizedBox(height: 20),
                      radioSelection("Other", 5, setState),
                      Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width - 100,
                        margin: const EdgeInsets.only(top: 15, bottom: 20),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE0EDF6),
                            borderRadius: BorderRadius.circular(1)),
                      ),
                      Text("Message to reviewer",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.w400,
                              fontSize: 16)),
                      Container(
                        height: 80,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Color(0xFFD8D8D8).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8)),
                        child: const TextField(
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "CeraPro"),
                          decoration: InputDecoration(
                            hintText:
                                "Please write brifly about the problem with this post",
                            hintStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: "CeraPro"),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 32,
                          width: 88,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: Color(0xFF1D89F1), width: 1)),
                          child: Text("Send",
                              style: TextStyle(color: Color(0xFF1D89F1))),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );

    return showModalBottomSheet(
        context: context,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 700,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 0, bottom: 10),
                  decoration: const BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Color(0xFF1D88F0).withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 6,
                                width: 37,
                                margin: EdgeInsets.only(bottom: 5, top: 10),
                                decoration: BoxDecoration(
                                    color: Color(0xFF045CB1).withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))
                                    // borderRadius: const BorderRadius.all(5)
                                    ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text("Report this post",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.only(left: 15, right: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                // widget.onPostOptionItem(!widget.postEntity.isSaved ? "Bookmark" : "UnBookmark");
                                Navigator.pop(context);
                              },
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 25,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: const Text("What's the problem?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "CeraPro",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16)),
                                  )),
                            ),
                            const SizedBox(height: 20),
                            radioSelection("This is spam", 0, setState),
                            const SizedBox(height: 20),
                            radioSelection(
                                "Misleading or fraudulent", 1, setState),
                            const SizedBox(height: 20),
                            radioSelection("Publication or private information",
                                2, setState),
                            const SizedBox(height: 20),
                            radioSelection(
                                "Threats of violence or physical harm",
                                3,
                                setState),
                            const SizedBox(height: 20),
                            radioSelection("I am not interested in this post",
                                4, setState),
                            const SizedBox(height: 20),
                            radioSelection("Other", 5, setState),
                            Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width - 100,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE0EDF6),
                                  borderRadius: BorderRadius.circular(1)),
                            ),
                            Text("Message to reviewer",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "CeraPro",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(top: 15, bottom: 10),
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFD8D8D8),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const TextField(
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "CeraPro"),
                                decoration: InputDecoration(
                                  hintText:
                                      "Please write brifly about the problem with this post",
                                  hintStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "CeraPro"),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 32,
                                width: 88,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        color: Color(0xFF1D89F1), width: 1)),
                                child: Text("Send",
                                    style: TextStyle(color: Color(0xFF1D89F1))),
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              },
            ));
  }

  radioSelection(String title, int index, StateSetter updateState) {
    return InkWell(
      onTap: () {
        currentIndex = index;
        updateState(() {});
      },
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                // color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                    color: currentIndex == index
                        ? Color(0xFF1D89F1)
                        : Colors.black,
                    width: 1)),
            child: currentIndex == index
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      // border: Border.all(color: currentIndex == index ? Color(0xFF1D89F1) : Colors.black, width: 1)
                    ),
                  )
                : Container(),
          ),
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "CeraPro")))
        ],
      ),
    );
  }

  void scrollAnimated(double position) {
    _controller.animateTo(position,
        curve: Curves.ease, duration: Duration(seconds: 1));
  }

  checkLinkBool() {
    // CheckLink.checkYouTubeLink(widget.postEntity.description) != null || CheckLink.checkYouTubeLink(widget?.postEntity?.ogData['url'] ?? "") != null ? true : false

    if (CheckLink.checkYouTubeLink(widget.postEntity!.description) != null) {
      return true;
    } else if (widget.postEntity?.ogData != null &&
        widget.postEntity?.ogData != "") {
      if (CheckLink.checkYouTubeLink(widget.postEntity?.ogData['url'] ?? "") !=
          null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  imageVideoSliderData() {
    print(widget.postEntity?.ogData);

    if (widget.postEntity!.media.length != 0 ||
        (widget.postEntity?.ogData != null &&
            widget.postEntity?.ogData != "" &&
            widget.postEntity?.ogData['url'] != null &&
            widget.postEntity!.ogData['url'] != "")) {
      return CustomSlider(
        mediaItems: widget.postEntity?.media,
        postEntity: widget.postEntity,
        ogData: widget.postEntity!.ogData,
        isOnlySocialLink: checkLinkBool(),
        onClickAction: (int index) {
          if (index == 0) {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (c) => DraggableScrollableSheet(
                      initialChildSize: 1, //set this as you want
                      maxChildSize: 1, //set this as you want
                      minChildSize: 1, //set this as you want
                      expand: true,
                      builder: (BuildContext context,
                              ScrollController scrollController) =>
                          Container(
                        margin: EdgeInsets.only(
                            top: MediaQueryData.fromWindow(
                                    WidgetsBinding.instance.window)
                                .padding
                                .top),
                        child: CreatePost(
                          title: "Reply",
                          replyTo: widget.postEntity!.userName,
                          threadId: widget.postEntity!.postId,
                          replyEntity: ReplyEntity.fromPostEntity(
                              postEntity: widget.postEntity!),
                        ),
                      ),
                    )).then((value) {
              if (value != null && value) widget.replyCountIncreased!(true);
              // setState(() {
              //   widget.postEntity=widget.postEntity.copyWith(commentCount: widget.postEntity.commentCount.inc.toString());
              // });
            });
          } else if (index == 1) {
            widget.onLikeTap!.call();
          } else if (index == 2) {
            widget.onTapRepost!.call();
            if (!widget.postEntity!.isReposted!) {
              context.showSnackBar(message: "Re-Post successfully");
            }
          } else if (index == 3) {
            mySocialShare!
                .shareToOtherPlatforms(text: widget.postEntity!.urlForSharing!);
          }
        },
      );
    } else
      Container();
  }
}

enum PostOptionsEnum { SHOW_LIKES, BOOKMARK, DELETE }

class GetDrawerMenu extends StatefulWidget {
  final ProfileEntity? profileEntity;

  const GetDrawerMenu({Key? key, this.profileEntity}) : super(key: key);

  @override
  _GetDrawerMenuState createState() => _GetDrawerMenuState();
}

class _GetDrawerMenuState extends State<GetDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return getDrawerMenu();
  }

  Widget getDrawerMenu() {
    return Container(
      width: 100,
      height: 300,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: ListView(
              padding:
                  EdgeInsets.only(top: AC.getDeviceHeight(context) * 0.3), //225
              children: [
                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFE0EDF6),
                  margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 0,
                      top: AC.getDeviceHeight(context) * 0.001),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 17,
                      top: AC.getDeviceHeight(context) * 0.03,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                  child: InkWell(
                    onTap: () {
                      ExtendedNavigator.root.pop();
                      BlocProvider.of<FeedCubit>(context)
                          .changeCurrentPage(const ScreenType.home());
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          // height: 19,
                          // width: 17,
                          height: AC.getDeviceHeight(context) * 0.030,
                          width: AC.getDeviceHeight(context) * 0.025,
                          child: AppIcons.drawerHome1,
                        ),
                        SizedBox(width: 15),
                        AutoSizeText("Home",
                            style: TextStyle(
                                fontFamily: "CeraPro",
                                fontSize: AC.getDeviceHeight(context) * 0.022,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),

                // [
                //   5.toSizedBoxHorizontal,
                //   AppIcons.drawerHome,
                //   20.toSizedBoxHorizontal,
                //   "Home".toBody2(fontWeight: FontWeight.w600, fontFamily1: "CeraPro", fontSize: 17)
                // ].toRow(crossAxisAlignment: CrossAxisAlignment.end).toFlatButton(() {
                //   ExtendedNavigator.root.pop();
                //   BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
                // }),
                // 0.toSizedBox,

                Padding(
                  padding: EdgeInsets.only(
                      left: 19,
                      right: 20,
                      top: 0,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                  child: InkWell(
                    onTap: () {
                      ExtendedNavigator.root.pop();
                      BlocProvider.of<FeedCubit>(context)
                          .changeCurrentPage(const ScreenType.message());
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: AC.getDeviceHeight(context) * 0.030,
                          width: AC.getDeviceHeight(context) * 0.030,
                          child: AppIcons.drawerMessage1,
                        ),
                        SizedBox(width: 13),
                        AutoSizeText("Messages",
                            style: TextStyle(
                                fontFamily: "CeraPro",
                                fontSize: AC.getDeviceHeight(context) * 0.022,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),

                /*[
            5.toSizedBoxHorizontal,
            AppIcons.drawerMessage,
            20.toSizedBoxHorizontal,
            "Messages".toBody2(fontWeight: FontWeight.w600, fontFamily1: "CeraPro", fontSize: 17)
          ].toRow(crossAxisAlignment: CrossAxisAlignment.center).toFlatButton(() {
            ExtendedNavigator.root.pop();
            BlocProvider.of<FeedCubit>(context)
                .changeCurrentPage(const ScreenType.message());
          }),*/
                // 30.toSizedBox,

                Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 0,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                  child: InkWell(
                    onTap: () {
                      ExtendedNavigator.root.pop();
                      BlocProvider.of<FeedCubit>(context)
                          .changeCurrentPage(const ScreenType.bookmarks());
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: AC.getDeviceHeight(context) * 0.030,
                          width: AC.getDeviceHeight(context) * 0.030,
                          child: AppIcons.drawerBookmark1,
                        ),
                        SizedBox(width: 12),
                        AutoSizeText("Bookmarks",
                            style: TextStyle(
                                fontFamily: "CeraPro",
                                fontSize: AC.getDeviceHeight(context) * 0.022,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),

                /*   [
            8.toSizedBoxHorizontal,
            AppIcons.drawerBookmark1,
            22.toSizedBoxHorizontal,
            "Bookmarks".toBody2(fontWeight: FontWeight.w600, fontFamily1: "CeraPro", fontSize: 17)
          ].toRow(crossAxisAlignment: CrossAxisAlignment.center).toFlatButton(() {
            ExtendedNavigator.root.pop();
            BlocProvider.of<FeedCubit>(context)
                .changeCurrentPage(const ScreenType.bookmarks());
          }),*/
                // 30.toSizedBox,

                Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 0,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                  child: InkWell(
                    onTap: () {
                      ExtendedNavigator.root.pop();
                      ExtendedNavigator.root.push(Routes.profileScreen);
                      // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.profile(ProfileScreenArguments(otherUserId: null)));
                      // ExtendedNavigator.root.push(Routes.profileScreen);
                      // showModalBottomSheet(
                      //   isScrollControlled: true,
                      //   context: context,
                      //   builder: (context) => Container(
                      //       child: ProfileScreen()),
                      // );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: AC.getDeviceHeight(context) * 0.030,
                          width: AC.getDeviceHeight(context) * 0.030,
                          child: AppIcons.drawerProfile1,
                        ),
                        SizedBox(width: 13),
                        AutoSizeText("Profile",
                            style: TextStyle(
                                fontFamily: "CeraPro",
                                fontSize: AC.getDeviceHeight(context) * 0.022,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),
                /* [
            5.toSizedBoxHorizontal,
            AppIcons.drawerProfile1,
            20.toSizedBoxHorizontal,
            "Profile".toBody2(fontWeight: FontWeight.w600)
          ].toRow(crossAxisAlignment: CrossAxisAlignment.end).toFlatButton(() {
            ExtendedNavigator.root.pop();
            ExtendedNavigator.root.push(Routes.profileScreen);
            // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.profile(ProfileScreenArguments(otherUserId: null)));
            // ExtendedNavigator.root.push(Routes.profileScreen);
            // showModalBottomSheet(
            //   isScrollControlled: true,
            //   context: context,
            //   builder: (context) => Container(
            //       child: ProfileScreen()),
            // );
          }),*/

                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFE0EDF6),
                  margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: 17,
                      right: 20,
                      top: 0,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                  child: InkWell(
                    onTap: () {
                      ExtendedNavigator.root.pop();
                      ExtendedNavigator.root.push(Routes.webViewScreen,
                          arguments: WebViewScreenArguments(
                              url: Strings.adsShow, name: Strings.ads));

                      // ExtendedNavigator.root.push(Routes.profileScreen);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: AC.getDeviceHeight(context) * 0.035,
                          width: AC.getDeviceHeight(context) * 0.035,
                          child: AppIcons.drawerAdvertising,
                        ),
                        const SizedBox(width: 11),
                        AutoSizeText("Advertising",
                            style: TextStyle(
                                fontFamily: "CeraPro",
                                fontSize: AC.getDeviceHeight(context) * 0.022,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: 17,
                      right: 20,
                      top: 0,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                  child: InkWell(
                    onTap: () {
                      ExtendedNavigator.root.pop();
                      ExtendedNavigator.root.push(Routes.webViewScreen,
                          arguments: WebViewScreenArguments(
                              url: Strings.affiliates,
                              name: Strings.affiliatesStr));
                      // ExtendedNavigator.root.push(Routes.profileScreen);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: AC.getDeviceHeight(context) * 0.035,
                          width: AC.getDeviceHeight(context) * 0.035,
                          child: AppIcons.drawerAffiliates,
                        ),
                        const SizedBox(width: 11),
                        AutoSizeText("Affiliates",
                            style: TextStyle(
                                fontFamily: "CeraPro",
                                fontSize: AC.getDeviceHeight(context) * 0.022,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFE0EDF6),
                  margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: AC.getDeviceHeight(context) * 0.03),
                ),

                // Spacer(),

                // 30.toSizedBox,
                /* [
            5.toSizedBoxHorizontal,
            AppIcons.drawerSetting,
            20.toSizedBoxHorizontal,
            "Settings".toBody2(fontWeight: FontWeight.w600)
          ].toRow(crossAxisAlignment: CrossAxisAlignment.end).toFlatButton(() {
            ExtendedNavigator.root.pop();
            BlocProvider.of<FeedCubit>(context)
                .changeCurrentPage(const ScreenType.settings(false));
          }),*/

                /*    const Divider(
            height: .3,
          )
              .toContainer(alignment: Alignment.bottomCenter)
              .toHorizontalPadding(16)
              .toExpanded(flex: 5),*/

                /*  [
            10.toSizedBoxHorizontal,
            AppIcons.signOut,
            "Logout".toButton().toFlatButton(() {
              context.showAlertDialog(widgets: [
                "Yes".toButton().toFlatButton(() async {

                  // var localDataSource = getIt<LocalDataSource>();
                  // await localDataSource.clearData();
                  // Fix the issue
                  ExtendedNavigator.root.pop();
                  await BlocProvider.of<FeedCubit>(context).logout();
                  // ExtendedNavigator.root.popUntil((c)=>Routes.loginScreen);
                  // ExtendedNavigator.root.pushAndRemoveUntil(Routes.loginScreen,(c)=>false);

                }),
                "No".toButton().toFlatButton(() {
                  ExtendedNavigator.root.pop();
                }),
              ], title: "Are you sure want to Logout?");
            })
          ]
              .toRow(crossAxisAlignment: CrossAxisAlignment.center)
              .toContainer(alignment: Alignment.centerLeft)
              .toExpanded(
              flex: context.getScreenWidth < 321 ||
                  context.getScreenHeight < 700
                  ? 3
                  : 1)*/
              ],
            ),
          ),

          [
            [
              widget.profileEntity!.profileUrl!
                  .toRoundNetworkImage(radius: 17)
                  .onTapWidget(() {
                ExtendedNavigator.root.pop();
                ExtendedNavigator.root.push(Routes.profileScreen,
                    arguments: ProfileScreenArguments(otherUserId: null));
                // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.profile(ProfileScreenArguments(otherUserId:  null)));
              })
            ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
            // 5.toSizedBox,

            SizedBox(height: AC.getDeviceHeight(context) * 0.005),

            [
              widget.profileEntity!.fullName
                  .toSubTitle1(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: AC.getDeviceHeight(context) * 0.03)
                  .toFlexible(), //29
              5.toSizedBoxHorizontal,
              AppIcons.verifiedIcons
                  .toContainer()
                  .toVisibility(widget.profileEntity!.isVerified!)
            ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
            2.toSizedBox,
            Text(widget.profileEntity!.userName,
                style: TextStyle(
                    fontSize: AC.getDeviceHeight(context) * 0.02,
                    color: Color(0xFF737880),
                    fontWeight: FontWeight.w400,
                    fontFamily: "CeraPro")),
            20.toSizedBox, // 17
            // widget.profileEntity.userName.toCaption(fontSize: 20),
            // 20.toSizedBox,
            [
              [
                [
                  widget.profileEntity!.postCounts.toSubTitle1(
                      color: AppColors.colorPrimary,
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: AC.getDeviceHeight(context) * 0.02), //17
                  // 2.toSizedBox,
                  SizedBox(height: AC.getDeviceHeight(context) * 0.002),
                  "Posts"
                      .toSubTitle2(
                          fontWeight: FontWeight.w400,
                          fontFamily1: "CeraPro",
                          fontSize: AC.getDeviceHeight(context) * 0.02,
                          color: const Color(0xFF8A8E95))
                      .onTapWidget(() {
                    ExtendedNavigator.root.push(Routes.profileScreen);
                  }),
                ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
                // 30.toSizedBox,
                SizedBox(width: AC.getDeviceWidth(context) * 0.06),
                [
                  widget.profileEntity!.followingCount.toSubTitle1(
                      color: AppColors.colorPrimary,
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: AC.getDeviceHeight(context) * 0.02),
                  // 2.toSizedBox,
                  SizedBox(height: AC.getDeviceHeight(context) * 0.002),
                  "Following".toSubTitle2(
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: AC.getDeviceHeight(context) * 0.02,
                      color: const Color(0xFF8A8E95)),
                ]
                    .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                    .onTapWidget(() {
                  ExtendedNavigator.root.pop();
                  ExtendedNavigator.root.push(Routes.followingFollowersScreen,
                      arguments: FollowingFollowersScreenArguments(
                          followScreenEnum:
                              FollowUnFollowScreenEnum.FOLLOWING));
                }),
                // 30.toSizedBox,
                SizedBox(width: AC.getDeviceWidth(context) * 0.06),
                [
                  widget.profileEntity!.followerCount.toSubTitle1(
                      color: AppColors.colorPrimary,
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: AC.getDeviceHeight(context) * 0.02),
                  // 2.toSizedBox,
                  SizedBox(height: AC.getDeviceHeight(context) * 0.002),
                  "Followers".toSubTitle2(
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: AC.getDeviceHeight(context) * 0.02,
                      color: const Color(0xFF8A8E95))
                ]
                    .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                    .onTapWidget(() {
                  ExtendedNavigator.root.pop();
                  ExtendedNavigator.root.push(Routes.followingFollowersScreen,
                      arguments: FollowingFollowersScreenArguments(
                          followScreenEnum:
                              FollowUnFollowScreenEnum.FOLLOWERS));
                }),
              ].toRow(mainAxisAlignment: MainAxisAlignment.start).toContainer(),
              // .toExpanded(),
            ].toRow(),

            // const Divider (
            //   thickness: 2,
            //   color: AppColors.sfBgColor,
            // ),
          ].toColumn().toSymmetricPadding(16, 12).toContainer(
              height: AC.getDeviceHeight(context) * 0.3,
              color: Colors.white), //h 225

          /*    Positioned(
            bottom: 0,
            child: Container(
              height: 65,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 22, right: 20, top: 10, bottom: 0),
            child: InkWell (
              onTap: () {
                ExtendedNavigator.root.pop();
                // ExtendedNavigator.root.push(Routes.profileScreen);

              },
              child: Row(
                children: [

                  SizedBox(
                    height: AC.getDeviceHeight(context) * 0.035,
                    width: AC.getDeviceHeight(context) * 0.035,
                    child: AppIcons.drawerWallet,
                  ),

                  SizedBox(width: 13),

                  AutoSizeText("Wallet ", style: TextStyle(fontFamily: "CeraPro", fontSize: AC.getDeviceHeight(context) * 0.022, color: Colors.black, fontWeight: FontWeight.w400)),
                  AutoSizeText("(\$5.00)", style: TextStyle(fontFamily: "CeraPro", fontSize: AC.getDeviceHeight(context) * 0.022, color: Color(0xFF62b83b), fontWeight: FontWeight.w400))

                ],
              ),
            ),
          ),)*/
        ],
      ),
    ).toSafeArea;
  }

  bottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

Widget buildPostButton(Widget icon, String count,
    {bool isLiked = false, Color? color}) {
  return [
    icon,
    5.toSizedBox,
    count.toBody2(
        fontWeight: FontWeight.w600,
        color: isLiked ? color : AppColors.textColor)
  ].toRow(crossAxisAlignment: CrossAxisAlignment.center);
}

Widget getShareOptionMenu(
    {MySocialShare? share, String? text, List<String>? files}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: [
      "Facebook",
      "Twitter",
      "LinkedIn",
      "Pinterest",
      "Reddit",
      "Copy Link"
    ].toPopUpMenuButton((value) {
      share?.shareToOtherPlatforms(text: text!, files: files);
    }, icon: AppIcons.shareIcon).toContainer(height: 15, width: 15),
  );
}
