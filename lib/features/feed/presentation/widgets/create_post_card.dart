import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colibri/core/common/add_thumbnail/check_link.dart';
import 'package:colibri/core/common/add_thumbnail/web_link_show.dart';
import 'package:colibri/core/common/add_thumbnail/youtube_thumbnil.dart';
import 'package:colibri/core/common/media/media_data.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/common/widget/common_divider.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/core/widgets/MediaOpener.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/core/widgets/media_picker.dart';
import 'package:colibri/core/widgets/slider.dart';
import 'package:colibri/core/widgets/thumbnail_widget.dart';
import 'package:colibri/features/posts/domain/entiity/reply_entity.dart';
import 'package:colibri/features/posts/presentation/bloc/createpost_cubit.dart';
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/search/domain/entity/hashtag_entity.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/presentation/bloc/search_cubit.dart';
import 'package:colibri/main.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:emoji_picker/emoji_picker.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:timelines/timelines.dart';
import 'package:video_compress/video_compress.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as htmlDom;

class CreatePostCard extends StatefulWidget {
  final String? threadId;
  final ReplyEntity? replyEntity;
  final VoidCallback? refreshHomeScreen;
  final Function? backData;
  const CreatePostCard(
      {Key? key,
      this.threadId,
      this.replyEntity,
      this.refreshHomeScreen,
      this.backData})
      : super(key: key);

  @override
  _CreatePostCardState createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  String everyOneReplayTitle = "Everyone can reply";

  CreatePostCubit? createPostCubit;
  CreatePostCubit? createPostCubit1;
  late Subscription sub;

  var loginResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// we will assign cubit if parent holds
    /// other wise we will give from [getit]

    linkTitle = "";
    linkDescription = "";
    linkImage = "";
    linkSiteName = "";
    linkUrl = "";

    try {
      createPostCubit = BlocProvider.of<CreatePostCubit>(context);
    } catch (e) {
      createPostCubit = getIt<CreatePostCubit>();
    }
    createPostCubit!.getUserData();

    loginData();

    if (VideoCompress.compressProgress$.notSubscribed)
      sub = VideoCompress.compressProgress$.subscribe((progress) {
        if (progress < 99.99)
          EasyLoading.showProgress(
            (progress / 100),
            status: 'Compressing ${progress.toInt()}%',
          );
        else
          EasyLoading.dismiss();
      });

    // createPostCubit.postTextValidator.textController.text = "";
    // createPostCubit.close();

    if (widget.replyEntity != null)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SystemChannels.textInput.invokeMethod('TextInput.show');
      });

    AC.searchCubitHash = getIt<SearchCubit>();
    AC.searchCubitA = getIt<SearchCubit>();
    AC.postCubit = getIt<PostCubit>();
    AC.textEditingController = TextEditingController();
  }

  loginData() async {
    loginResponse = await localDataSource!.getUserAuth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CommonUIState>(
      bloc: createPostCubit,
      listener: (_, state) {
        state.maybeWhen(
            orElse: () {},
            error: (e) => context.showSnackBar(message: e, isError: true),
            success: (s) {
              if (s is String && s.isNotEmpty) {
                // widget?.refreshHomeScreen?.call();
                // widget.refreshHomeScreen(0);

                createPostCubit!.postTextValidator.textController.clear();
                linkTitle = "";
                linkDescription = "";
                linkImage = "";
                linkSiteName = "";
                linkUrl = "";

                widget.backData!(0);
                ExtendedNavigator.root.pop();

                if (widget.replyEntity != null)
                  // ExtendedNavigator.root.pop(true);
                  // BlocProvider.of<FeedCubit>(context).onRefresh();
                  context.showSnackBar(message: s, isError: false);
              }
            });
      },
      child: BlocBuilder<CreatePostCubit, CommonUIState>(
        bloc: createPostCubit,
        builder: (_, state) {
          return state.when(
              initial: () => Stack(
                    children: [
                      widget.replyEntity != null
                          ? buildReplyView()
                          : buildHome(),
                      LoadingBar().toVerticalPadding(8),
                    ],
                  ),
              success: (s) =>
                  widget.replyEntity != null ? buildReplyView() : buildHome(),
              loading: () => Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      widget.replyEntity != null
                          ? buildReplyView()
                          : buildHome(),
                      LoadingBar().toVerticalPadding(8),
                    ],
                  ).toVerticalPadding(8),
              error: (e) =>
                  widget.replyEntity != null ? buildReplyView() : buildHome());
        },
      ),
    );
  }

  Widget buildReplyView() {
    return StreamBuilder<ProfileEntity>(
        stream: createPostCubit!.drawerEntity,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const LoadingBar().toContainer(
                height: context.getScreenHeight as double,
                alignment: Alignment.center);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FixedTimeline.tileBuilder(
                        builder: TimelineTileBuilder(
                            nodePositionBuilder: (c, index) => 0.0,
                            indicatorPositionBuilder: (c, index) => 0.0,
                            indicatorBuilder: (c, index) => Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: (index == 1
                                      ? snapshot.data!.profileUrl!
                                          .toRoundNetworkImage()
                                      : widget.replyEntity!.profileUrl!
                                          .toRoundNetworkImage()),
                                ),
                            endConnectorBuilder: (c, index) => Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: (index == 0
                                      ? const SolidLineConnector(
                                          color: Colors.grey,
                                        )
                                      : const SolidLineConnector(
                                          color: Colors.transparent,
                                        )),
                                ),
                            contentsBuilder: (c, index) => index == 0
                                ? buildReplyTopView(widget.replyEntity!)
                                : [
                                    10.toSizedBox,
                                    // data.profileUrl
                                    //     .toRoundNetworkImage().toContainer(alignment: Alignment.topCenter,),
                                    "${widget.replyEntity == null ? 'What is happening? #Hashtag...@Mention' : 'Post your reply...'}"
                                        // "${widget.replyEntity==null? "What's on your mind?" :'Post your reply... '}"
                                        .toNoBorderTextField(
                                            colors: const Color(0xFF1D88F0))
                                        .toPostBuilder(
                                            validators: createPostCubit!
                                                .postTextValidator)
                                        .toHorizontalPadding(12)
                                        .toContainer(
                                            alignment: Alignment.topCenter)
                                        .toFlexible(),
                                  ].toColumn().toContainer(color: Colors.white),
                            itemCount: 2))
                    .toVerticalPadding(8),
                getPostInteractionBar(enableSideWidth: false)
                    .toHorizontalPadding(16)
              ],
            );
          }
        });
  }

  Widget buildHome() {
    return StreamBuilder<ProfileEntity>(
        stream: createPostCubit!.drawerEntity,
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Container(
              height: context.getScreenHeight as double?,
              child: LoadingBar(),
              alignment: Alignment.center,
            );
          return buildCreatePostCard(context, snapshot.data!);
        });
  }

  List textFiledData = [];

  Widget buildCreatePostCard(BuildContext context, ProfileEntity data) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        [
          5.toSizedBox,
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: AppIcons.appLogo.toContainer(height: 35, width: 35),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        createPostCubit!.postTextValidator.textController
                            .clear();
                        linkTitle = "";
                        linkDescription = "";
                        linkImage = "";
                        linkSiteName = "";
                        linkUrl = "";
                        ExtendedNavigator.root.pop();
                      },
                      child: const Icon(Icons.close,
                          color: AppColors.alertBg, size: 30),
                    )),
              )
            ],
          ),
          SizedBox(
              height: 174,
              child: ListView(
                children: [
                  [
                    Padding(
                        padding: EdgeInsets.only(left: 17, right: 0),
                        child: data.profileUrl!
                            .toRoundNetworkImage()
                            .toContainer(
                              alignment: Alignment.topCenter,
                            )
                            .onTapWidget(() {
                          ExtendedNavigator.root.push(Routes.profileScreen,
                              arguments:
                                  ProfileScreenArguments(otherUserId: null));
                        })),

                    //.toHorizontalPadding(15)
                    // "What is happening? #Hashtag...@Mention"

                    "What's on your mind?"
                        .toNoBorderTextField(colors: const Color(0xFF1D88F0))
                        .toPostBuilder(
                            validators: createPostCubit!.postTextValidator)
                        .toHorizontalPadding(5)
                        .toContainer(alignment: Alignment.topCenter)
                        .toFlexible()
                  ].toRow().toContainer(),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15),
                    child: StreamBuilder<List<MediaData>>(
                        stream: createPostCubit!.images,
                        initialData: [],
                        builder: (context, snapshot) {
                          return AnimatedSwitcher(
                            key: UniqueKey(),
                            duration: const Duration(milliseconds: 500),
                            child: Wrap(
                                runSpacing: 20.0,
                                spacing: 5.0,
                                children: List.generate(
                                  snapshot.data!.length,
                                  (index) {
                                    return AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: getMediaWidget(
                                            snapshot.data![index], index));
                                  },
                                )).toContainer(),
                          );
                        }),
                  ),

                  // Text(createPostCubit.postTextValidator.textController.text),

                  StreamBuilder(
                      stream: createPostCubit!.postTextValidator.stream,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return showPostWiseData(createPostCubit!
                            .postTextValidator.textController.text);
                      }),
                ],
              )),
          getPostInteractionBar()
        ].toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween),

        ///hash tag input : -

        hashTagData(),

        aTheRateData(),

        /*  Padding (
            padding: EdgeInsets.only(left: 80),
            child: PopupMenuButton (
              child: Text(everyOneReplayTitle, style: const TextStyle(color: Color(0xFF579AD1), fontSize: 13, fontFamily: "CeraPro", fontWeight: FontWeight.w400)),
              itemBuilder: (context) {
                return List.generate(10, (index) {
                  return const PopupMenuItem (
                    child: Text("hello"),
                  );
                });
              },
            )
        ),*/
      ],
    );
  }

  Widget getHastTagItem1(HashTagEntity entity, StringToVoidFunc onTap) {
    return Row(
      children: [
        10.toSizedBox,
        Icon(
          FontAwesomeIcons.hashtag,
          color: AppColors.colorPrimary,
          size: 15,
        )
            .toPadding(12)
            .toContainer(
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.colorPrimary, width: .3)))
            // .toExpanded(flex: 1)
            .toCenter(),
        Container(
          height: 30,
          // width: 150,
          padding: EdgeInsets.only(left: 7, top: 7, right: 7),
          alignment: Alignment.centerLeft,
          color: Colors.white,
          child: entity.name!
              .toSubTitle2(fontWeight: FontWeight.w600)
              .onTapWidget(() {
            onTap.call(entity.name);
          }),
        )
      ],
    );
  }

  Widget getPeopleItem1(PeopleEntity entity, StringToVoidFunc onTap) {
    return Row(
      children: [
        10.toSizedBox,
        SizedBox(
          height: 30,
          width: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              placeholder: (c, i) => const CircularProgressIndicator(),
              imageUrl: entity.profileUrl!,
            ),
          ),
        ),
        10.toSizedBox,
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 30,
              // width: 150,
              // color: Colors.grey.shade100,
              child: entity.fullName!
                  .toSubTitle2(
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: 16,
                      maxLines: 1)
                  .onTapWidget(() {
                onTap.call(entity.userName);
              }),
            ),
            Container(
              // height: 30,
              // width: 150,
              // color: Colors.grey.shade100,
              child: entity.userName!
                  .toSubTitle2(
                      fontWeight: FontWeight.w400,
                      fontFamily1: "CeraPro",
                      fontSize: 13,
                      maxLines: 1)
                  .onTapWidget(() {
                onTap.call(entity.userName);
              }),
            ),
          ],
        ))
      ],
    );
  }

  Widget getMediaWidget(MediaData mediaData, int index) {
    switch (mediaData.type) {
      case MediaTypeEnum.IMAGE:
        return ThumbnailWidget(
          data: mediaData,
          onCloseTap: () async {
            await createPostCubit!.removedFile(index);
          },
        ).onTapWidget(
          () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (c) => MediaOpener(
                      data: mediaData,
                    )));
          },
        ).toContainer(width: context.getScreenWidth * .45);
        break;
      case MediaTypeEnum.VIDEO:
        return Stack(
          children: [
            ThumbnailWidget(
              data: mediaData,
              onCloseTap: () async {
                await createPostCubit!.removedFile(index);
              },
            ),
            const Positioned.fill(
                child: const Icon(
              FontAwesomeIcons.play,
              color: Colors.white,
              size: 45,
            )),
          ],
        ).toHorizontalPadding(12).onTapWidget(() {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (c) => MediaOpener(
                    data: mediaData,
                  )));
        });
        break;
      case MediaTypeEnum.GIF:
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GiphyWidget(
            path: mediaData.path,
            fun: () async {
              await createPostCubit!.removedFile(index);
            },
          ),
        );
        break;
      case MediaTypeEnum.EMOJI:
        return ThumbnailWidget(data: mediaData);
        break;
      default:
        return Container();
    }
  }

  void showModelSheet(BuildContext context) {
    context.showModelBottomSheet(EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.CUPERTINO,
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji.emoji);
        // print(emoji.emoji);
        createPostCubit!.postTextValidator
          ..textController.text =
              createPostCubit!.postTextValidator.text + emoji.emoji
          ..changeData(createPostCubit!.postTextValidator.text);
      },
    ).toContainer(
        height: context.getScreenWidth > 600 ? 400 : 250,
        color: Colors.transparent));
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    sub.unsubscribe();
    super.dispose();
  }

  Widget buildReplyTopView(ReplyEntity replyEntity) {
    return [
      [
        replyEntity.name!.toSubTitle1(fontWeight: FontWeight.bold).toFlexible(),
        replyEntity.time!.toCaption(fontWeight: FontWeight.w600).toFlexible()
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      replyEntity.username1!.toCaption(fontWeight: FontWeight.w600),
      5.toSizedBox.toVisibility(replyEntity.description.isNotEmpty),
      replyEntity.description.toSubTitle1(),
      10.toSizedBox.toVisibility(replyEntity.description.isNotEmpty),
      [
        "Replying to ".toCaption(fontWeight: FontWeight.w600),
        widget.replyEntity!.username1!.toSubTitle1(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            fontSize: 12,
            onTapMention: (mention) {
              ExtendedNavigator.root.push(Routes.profileScreen,
                  arguments: ProfileScreenArguments(otherUserId: mention));
            }),
        " and ".toCaption(fontWeight: FontWeight.w600).toVisibility(
            widget.replyEntity!.username2.isNotEmpty &&
                widget.replyEntity!.username2 != widget.replyEntity!.username1),
        widget.replyEntity!.username2
            .toSubTitle1(
                fontWeight: FontWeight.w600,
                color: AppColors.colorPrimary,
                fontSize: 12,
                onTapMention: (mention) {
                  ExtendedNavigator.root.push(Routes.profileScreen,
                      arguments: ProfileScreenArguments(otherUserId: mention));
                })
            .toVisibility(widget.replyEntity!.username2.isNotEmpty &&
                widget.replyEntity!.username2 != widget.replyEntity!.username1)
      ].toRow(),
      10.toSizedBox.toVisibility(widget.replyEntity!.items.isNotEmpty),
      CustomSlider(
              mediaItems: widget.replyEntity!.items, isOnlySocialLink: false)
          .toVisibility(widget.replyEntity!.items.isNotEmpty)
    ].toColumn().toHorizontalPadding(20).toVerticalPadding(8);
  }

  String? linkTitle = "";
  String? linkDescription = "";
  String? linkImage = "";
  String? linkSiteName = "";
  String linkUrl = "";

  String tempLinkUrl = "";
  String textFiledValue = "";

  // String tempLinkUrl1 = "";

  void _getUrlData(String url) async {
    Map? _urlPreviewData;

    print("url $url");

    if (!isURL(url)) {
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    final store = await CacheStore.getInstance();
    var response = await store.getFile(url).catchError((error) {
      return null;
    });
    if (response == null) {
      if (!this.mounted) {
        return;
      }
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    var document = parse(await response.readAsString());

    Map data = {};
    _extractOGData(document, data, 'og:title');
    _extractOGData(document, data, 'og:description');
    _extractOGData(document, data, 'og:site_name');
    _extractOGData(document, data, 'og:image');

    if (!this.mounted) {
      return;
    }

    // if(linkImage.isEmpty || (linkUrl.isEmpty && tempLinkUrl.isEmpty)) {
    if (linkImage!.isEmpty && linkUrl.isEmpty && tempLinkUrl.isEmpty) {
      if (data.isNotEmpty) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _urlPreviewData = data;
            linkTitle = _urlPreviewData!['og:title'];
            linkDescription = _urlPreviewData!['og:description'];
            linkSiteName = _urlPreviewData!['og:site_name'];
            linkImage = _urlPreviewData!['og:image'];
            linkUrl = url;

            print("vishal :  ==><>  $_urlPreviewData");
            print("vishal :  ==><>  $linkSiteName");
            print("vishal :  ==><>  $linkImage");

            // _isVisible = true;
          });
        });
      }
    }
  }

  void _extractOGData(htmlDom.Document document, Map data, String parameter) {
    var titleMetaTag = document
        .getElementsByTagName("meta")
        ?.firstWhereOrNull((meta) => meta.attributes['property'] == parameter);

    // print("Hello Test  ${titleMetaTag.attributes['content']}");

    if (titleMetaTag != null) {
      data[parameter] = titleMetaTag.attributes['content'];
    }
  }

  showPostWiseData(String title) {
    List d1 = title.split(" ");
    // String linkGet = "";

    // if(tempLinkUrl.contains(title)) {
    //   tempLinkUrl = "";
    // }

    if (title.isEmpty) {
      tempLinkUrl = "";
    }

    d1.forEach((element) {
      if (element.contains("https://www.youtube.com") ||
          element.contains("https://youtu.be") ||
          element.contains("https://m.youtube.com/") ||
          element.contains("www.youtube.com")) {
        // linkUrl = element;
        _getUrlData(element);
      } else if (element.contains("https://") || element.contains("www.")) {
        // linkUrl = element;
        _getUrlData(element);
      } else {
        print("no data");
        // linkGet = "";
      }
    });

    // if(_urlPreviewData != null) {
    //
    // }

    print("data =<><><> $linkImage");

    // if(linkImage.isEmpty || linkTitle.isNotEmpty) {
    //
    //   return Container (
    //     width: 200,
    //     height: 200,
    //     color: Colors.red,
    //   );
    //
    // } else {
    //   return Container();
    // }

    print(linkUrl);
    print("linkUrl");

    if (tempLinkUrl.isEmpty) {
      if (linkUrl.contains("https://www.youtube.com") ||
          linkUrl.contains("https://youtu.be") ||
          linkUrl.contains("https://m.youtube.com/") ||
          linkUrl.contains("www.youtube.com")) {
        return SimpleUrlPreview(
          url: CheckLink.checkYouTubeLink(linkUrl) ?? "",
          previewHeight: 300,
          previewContainerPadding: EdgeInsets.all(0),
          homePagePostCreate: true,
          clearText: () {
            // createPostCubit.postTextValidator.textController.text = "";

            tempLinkUrl = title;

            linkTitle = "";
            linkDescription = "";
            linkImage = "";
            linkSiteName = "";
            linkUrl = "";

            setState(() {});
          },
        );
      } else if (linkUrl.contains("https://") || linkUrl.contains("www.")) {
        return SimpleUrlPreviewWeb(
          url: linkUrl,
          // url: CheckLink.checkYouTubeLink(linkUrl) ?? "",
          // textColor: Colors.white,
          bgColor: Colors.red,
          previewHeight: 200,
          homePagePostCreate: true,
          clearText: () {
            // createPostCubit.postTextValidator.textController.text = "";

            tempLinkUrl = title;

            linkTitle = "";
            linkDescription = "";
            linkImage = "";
            linkSiteName = "";
            linkUrl = "";

            setState(() {});
          },
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }

    // else if(linkUrl.contains("https://www.youtube")) {
    // return Container (
    // height: 100,
    // width: 300,
    // child: const Text("No Youtube data found", style: TextStyle(color: Colors.blueAccent)),
    // );
    // }
  }

  Widget getPostInteractionBar({bool enableSideWidth = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const SizedBox(height: 25),

        ///every can reply vioew

        Padding(
          padding: EdgeInsets.only(left: 30, right: 20, bottom: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                    height: 12,
                    width: 12,
                    image: AssetImage("images/png_image/icon_replay.png"),
                  ),

                  const SizedBox(width: 5),

                  PopupMenuButton(
                    child: Center(
                        child: Text(everyOneReplayTitle,
                            style: const TextStyle(
                                color: Color(0xFF579AD1),
                                fontSize: 13,
                                fontFamily: "CeraPro",
                                fontWeight: FontWeight.w400))),
                    itemBuilder: (context) {
                      return List.generate(3, (index) {
                        return PopupMenuItem(
                          child: popUpMenuTextShow(index),
                        );
                      });
                    },
                  ),

                  // const Text("Everyone can reply", style: TextStyle(color: Color(0xFF579AD1), fontSize: 13, fontFamily: "CeraPro", fontWeight: FontWeight.w400)),
                ],
              ),
              StreamBuilder<int>(
                  stream: createPostCubit!.postTextValidator.stream
                      .map((event) => event!.length),
                  initialData: 0,
                  builder: (context, snapshot) {
                    return Visibility(
                        visible: true,
                        // visible: snapshot.data!=0,
                        child: "${snapshot.data}/600"
                            .toCaption(color: Color(0xFF737880)));
                  }),
            ],
          ),
        ),

        ///divider show

        Container(
          height: 2,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFE0EDF6),
        ),

        [
          [
            if (context.getScreenWidth < 321 && enableSideWidth)
              20.toSizedBoxHorizontal,
            if (context.getScreenWidth > 321 && enableSideWidth)
              30.toSizedBoxHorizontal,
            StreamBuilder<bool>(
                stream: createPostCubit!.imageButton,
                initialData: true,
                builder: (context, snapshot) {
                  return AppIcons.imageIcon(enabled: snapshot.data!)
                      .onTapWidget(() async {
                    if (snapshot.data!)
                      await openMediaPicker(context, (image) {
                        createPostCubit!.addImage(image);
                        // context.showSnackBar(message: image);
                      }, mediaType: MediaTypeEnum.IMAGE);
                  });
                }),

            20.toSizedBoxHorizontal,
            StreamBuilder<bool>(
                stream: createPostCubit!.videoButton,
                initialData: true,
                builder: (context, snapshot) {
                  return AppIcons.videoIcon(enabled: snapshot.data!)
                      .onTapWidget(() async {
                    if (snapshot.data!)
                      await openMediaPicker(context, (video) {
                        createPostCubit!.addVideo(video!);
                      }, mediaType: MediaTypeEnum.VIDEO);
                  });
                }),

            20.toSizedBoxHorizontal,
            AppIcons.smileIcon.onTapWidget(() {
              showModelSheet(context);
            }),

            /*      20.toSizedBoxHorizontal,
            StreamBuilder<bool> (
                stream: createPostCubit.gifButton,
                initialData: true,
                builder: (context, snapshot) {
                  return AppIcons.gifIcon(enabled: snapshot.data).onTapWidget(() async{
                    if(snapshot.data)
                    {
                      final gif = await GiphyPicker.pickGif(
                          context: context,
                          apiKey: Strings.giphyApiKey);
                      if(gif?.images?.original?.url!=null)
                        createPostCubit.addGif(gif?.images?.original?.url);
                    }
                    // context.showModelBottomSheet(GiphyImage.original(gif: gif));
                  });
                }
            ),*/

            20.toSizedBoxHorizontal,

            // StreamBuilder<bool> (
            //     stream: createPostCubit.gifButton,
            //     initialData: true,
            //     builder: (context, snapshot) {
            //       return AppIcons.pollIcon.onTapWidget(() async {
            //
            //         /*  if(snapshot.data)
            //         {
            //           final gif = await GiphyPicker.pickGif(
            //               context: context,
            //               apiKey: Strings.giphyApiKey);
            //           if(gif?.images?.original?.url!=null)
            //             createPostCubit.addGif(gif?.images?.original?.url);
            //         }*/
            //
            //         // context.showModelBottomSheet(GiphyImage.original(gif: gif));
            //       });
            //     }
            // ),
            // 20.toSizedBoxHorizontal,

            StreamBuilder<bool>(
                stream: createPostCubit!.gifButton,
                initialData: true,
                builder: (context, snapshot) {
                  return AppIcons.createSearchIcon.onTapWidget(() async {
                    if (snapshot.data!) {
                      final gif = await GiphyPicker.pickGif(
                          context: context, apiKey: Strings.giphyApiKey);
                      if (gif.images?.original?.url != null)
                        createPostCubit!.addGif(gif.images.original.url);
                    }

                    // context.showModelBottomSheet(GiphyImage.original(gif: gif));
                  });
                }),

            [
              // StreamBuilder<int>(
              //     stream: createPostCubit.postTextValidator.stream.map((event) => event.length),
              //     initialData: 0,
              //     builder: (context, snapshot) {
              //       return Visibility(
              //           visible: snapshot.data!=0,
              //           child: "${snapshot.data}/600".toCaption());
              //     }
              // ),

              // 10.toSizedBoxHorizontal,

              StreamBuilder<bool>(
                  stream: createPostCubit!.enablePublishButton,
                  initialData: false,
                  builder: (context, snapshot) {
                    return "${widget.replyEntity == null ? 'Publish' : 'Reply'}"
                        .toCaption(color: Colors.white)
                        .toMaterialButton(() async {
                      // OgDataClass1 ogData = OgDataClass1();
                      // ogData.title = linkTitle;
                      // ogData.description = linkDescription;
                      // // ogData.url = linkUrl;
                      // ogData.image = linkImage;
                      // ogData.type = "website";

                      if (linkUrl.isNotEmpty) {
                        if (loginResponse != null) {
                          Map<String, dynamic> mapData = {
                            "session_id": loginResponse.authToken ?? "",
                            "post_text":
                                textFiledValue.isEmpty ? " " : textFiledValue,
                            "og_data[title]": linkTitle ?? "",
                            "og_data[description]": linkDescription ?? "",
                            "og_data[image]": linkImage ?? "",
                            "og_data[type]": "website",
                            "og_data[url]": linkUrl,
                          };

                          print("Map og_data youtube and link data $mapData");
                          createPostCubit!
                              .ogDataPassingApi(mapData)
                              .then((value) {
                            print(value);
                            Map? jsonData = jsonDecode(value!.body);
                            if (jsonData != null && jsonData['code'] == 200) {
                              createPostCubit!.clearAllPostData();
                              linkTitle = "";
                              linkDescription = "";
                              linkImage = "";
                              linkUrl = "";
                              // widget?.refreshHomeScreen?.call();
                              widget.backData!(0);
                              ExtendedNavigator.root.pop();
                            } else {
                              context.showSnackBar(
                                  message: jsonData!['message'] ??
                                      "Some thing wrong",
                                  isError: true);
                            }
                          });
                        }
                      } else {
                        await createPostCubit!
                            .createPost(threadId: widget.threadId);
                      }

                      // ogData: linkUrl != null && linkUrl.isNotEmpty ? jsonEncode(mapData) : ""
                    },
                            enabled: snapshot.data! ||
                                linkUrl.isNotEmpty).toHorizontalPadding(4);
                  }),
              10.toSizedBoxHorizontal
            ]
                .toRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end)
                .toExpanded()
          ]
              .toRow(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center)
              // .toContainer().makeBottomBorder
              .toFlexible(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
      ],
    );
  }

  popUpMenuTextShow(int index) {
    if (index == 0) {
      return InkWell(
        onTap: () {
          setState(() {
            everyOneReplayTitle = "Everyone can reply";
          });
          Navigator.pop(context);
        },
        child: const Text('Everyone can reply',
            style: TextStyle(
                color: Color(0xFF579AD1),
                fontSize: 15,
                fontFamily: "CeraPro",
                fontWeight: FontWeight.w400)),
      );
    } else if (index == 1) {
      return InkWell(
        onTap: () {
          setState(() {
            everyOneReplayTitle = "Only mentioned people";
          });
          Navigator.pop(context);
        },
        child: const Text('Only mentioned people',
            style: TextStyle(
                color: Color(0xFF579AD1),
                fontSize: 15,
                fontFamily: "CeraPro",
                fontWeight: FontWeight.w400)),
      );
    } else if (index == 2) {
      return InkWell(
        onTap: () {
          setState(() {
            everyOneReplayTitle = "Only my followers";
          });
          Navigator.pop(context);
        },
        child: const Text('Only my followers',
            style: TextStyle(
                color: Color(0xFF579AD1),
                fontSize: 15,
                fontFamily: "CeraPro",
                fontWeight: FontWeight.w400)),
      );
    }
  }

  void doSearch(String tag, String lastLatter) {
    if (tag == "#") {
      AC.searchCubitHash!.hashTagPagination!.changeSearch(lastLatter);
    } else if (tag == "@") {
      // } else if(tag == "\$") {
      AC.searchCubitA!.peoplePagination!.changeSearch(lastLatter);
    }
  }

  hashTagData() {
    return StreamBuilder(
        stream: createPostCubit!.postTextValidator.stream,
        initialData: 0,
        builder: (context, snapshot) {
          //api in data pass
          textFiledValue =
              createPostCubit!.postTextValidator.textController.text;

          if (createPostCubit!.postTextValidator.textController.text
              .trim()
              .isEmpty) {
            textFiledData = [];
          }
          String inputData =
              createPostCubit!.postTextValidator.textController.text;
          // List spiltData = inputData.split(" ");
          // && spiltData.contains("#")
          String lastLatter = "";
          String spaceAfter = "";
          //   //|| inputData[lastIndexInt] != " "
          //   if(inputData.length != 0 || spaceAfter.startsWith("@")) {
          if (inputData != null) {
            print("in the #");

            ///start with        #     <<--------------
            // int dataa = data.lastIndexOf("#");
            bool isTagShow = false;
            int lastIndexInt = -1;
            if (inputData.length != 0) {
              lastIndexInt = inputData.length - 1;
              spaceAfter = inputData.split(" ").last;
              print(spaceAfter);
              lastLatter = inputData.split("#").last;
              AC.searchCubitHash!.hashTagPagination!.queryText = lastLatter;
              //inputData[lastIndexInt] != " "
              if (inputData.length != 0) {
                // || spaceAfter.startsWith("#")
                if (inputData[lastIndexInt] == "#") {
                  doSearch("#", lastLatter);
                  print("2");
                  // isTagShow = true;
                }
                // RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

                if (alphanumeric.hasMatch(inputData[lastIndexInt])) {
                  print("1");
                  isTagShow = true;
                }
              }
            }

            words = inputData.split(' ');
            str = words.length > 0 && words[words.length - 1].startsWith('#')
                ? words[words.length - 1]
                : '';

            if (inputData.endsWith('#')) {
              detected = true;
              startIndexOfTag = inputData.length - 1;
            }

            // if (detected == true) {
            //   print(inputData.substring(startIndexOfTag));
            // }

            if ((detected == true && inputData.endsWith(' ')) ||
                startIndexOfTag == 1) {
              detected = false;
              endIndexOfTag = inputData.length;
            }

            if (inputData.length < endIndexOfTag) {
              detected = true;
              isTagShow = true;
              endIndexOfTag = inputData.length;
              startIndexOfTag = inputData.indexOf('#');
            }

            print("Print data");
            print(endIndexOfTag);
            print(startIndexOfTag);

            // data[data1] == "#"
            //

            return str.length > 1 && isTagShow
                ? Container(
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.only(top: 85),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 0.1)
                    ]
                        // border: Border.all(width: 1, color: Colors.grey.shade300)
                        ),
                    alignment: Alignment.center,
                    child: PagedListView.separated(
                      key: const PageStorageKey("Hashtags"),
                      pagingController: AC
                          .searchCubitHash!.hashTagPagination!.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<HashTagEntity>(
                          // noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen (
                          //   buttonText: "GO TO HOMEPAGE",
                          //   icon: const Icon(Icons.search,color: AppColors.colorPrimary,size: 40,),
                          //   title: "Nothing Found",
                          //   message:'Sorry, but we could not find anything in our database for your search query  "${textEditingController.text}."  Please try again by typing other keywords.',
                          //   onTapButton: () {
                          //     BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
                          //   },
                          // ),
                          itemBuilder: (c, item, index) {
                        print(item);
                        return Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 7 : 0),
                          child: getHastTagItem1(item, (s) {
                            // textEditingController.text = s.replaceAll("#", "");
                            // postCubit.searchedText = s.replaceAll("#", "");

                            FocusScope.of(context).requestFocus(
                                createPostCubit!.postTextValidator.focusNode);

                            createPostCubit!
                                    .postTextValidator.textController.text =
                                inputData.replaceRange(
                                    startIndexOfTag, inputData.length, "$s ");

                            createPostCubit!.postTextValidator.textController
                                    .selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: createPostCubit!.postTextValidator
                                        .textController.text.length));

                            isTagShow = false;
                            setState(() {});

                            /*  isTagShow = false;

                        // textFiledData.add ("#$s" + " ");

                        textFiledData.add ("#${s.replaceAll("#", "")}" + " ");

                        String lastTagData = createPostCubit.postTextValidator.textController.text.split("#").last;

                        String data = createPostCubit.postTextValidator.textController.text + lastTagData.replaceAll(lastTagData, s) + " ";

                        createPostCubit.postTextValidator.textController.text = data; */

                            // createPostCubit.postTextValidator.textController.text = textFiledData.join(" ");
                            setState(() {});
                            // tabController.animateTo(2,duration: const Duration(milliseconds: 300));
                          }),
                        );
                      }),
                      separatorBuilder: (BuildContext context, int index) =>
                          commonDivider,
                    ),
                  )
                : Container();
          } else {
            return Container();
          }
        });
  }

  List<String> users = ['Naveen', 'Ram', 'Satish', 'Some Other'], words = [];
  String str = '';
  List<String> coments = [];

  bool detected = false;
  int startIndexOfTag = 0;
  int endIndexOfTag = 0;

  // bool detectedA = false;
  // int startIndexOfA = 0;
  // int endIndexOfA = 0;
  // String inputData = "";

  aTheRateData() {
    // ///start with        @     <<--------------

    return StreamBuilder(
        stream: createPostCubit!.postTextValidator.stream,
        initialData: 0,
        builder: (context, snapshot) {
          if (createPostCubit!.postTextValidator.textController.text
              .trim()
              .isEmpty) {
            textFiledData = [];
            startIndexOfTag = 0;
          }

          String inputData =
              createPostCubit!.postTextValidator.textController.text;

          /*        words = inputData.split(' ');
          str = words.length > 0 &&
              words[words.length - 1].startsWith('!')
              ? words[words.length - 1]
              : '';

          print("Test data =======");
          print(str);*/

          // List spiltData = inputData.split(" ");
          // && spiltData.contains("#")

          String lastLatter = "";
          String spaceAfter = "";
          //   //|| inputData[lastIndexInt] != " "
          //   if(inputData.length != 0 || spaceAfter.startsWith("@")) {
          if (inputData != null) {
            print("in the #");

            ///start with        @     <<--------------
            // int dataa = data.lastIndexOf("#");
            bool isTagShow = false;
            int lastIndexInt = -1;
            if (inputData.length != 0) {
              lastIndexInt = inputData.length - 1;
              spaceAfter = inputData.split(" ").last;
              print(spaceAfter);
              print("spaceAfter");
              lastLatter = inputData.split("@").last;
              AC.searchCubitA!.peoplePagination!.queryText = lastLatter;
              //inputData[lastIndexInt] != " "
              if (inputData.length != 0) {
                // || spaceAfter.startsWith("#")
                if (inputData[lastIndexInt] == "@") {
                  doSearch("@", lastLatter);
                  print("2");
                  // isTagShow = true;
                }
                // RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

                if (alphanumeric.hasMatch(inputData[lastIndexInt])) {
                  print("1");
                  isTagShow = true;
                }
              }
            }

            words = inputData.split(' ');
            str = words.length > 0 && words[words.length - 1].startsWith('@')
                ? words[words.length - 1]
                : '';

            /// value show

            if (inputData.endsWith('@')) {
              detected = true;
              startIndexOfTag = inputData.length - 1;
            }

            // if (detected == true) {
            //   print(inputData.substring(startIndexOfTag));
            // }

            if ((detected == true && inputData.endsWith(' ')) ||
                startIndexOfTag == 1) {
              detected = false;
              endIndexOfTag = inputData.length;
            }

            if (inputData.length < endIndexOfTag) {
              detected = true;
              isTagShow = true;
              endIndexOfTag = inputData.length;
              startIndexOfTag = inputData.indexOf('@');
            }

            // print("Print data");
            // print(endIndexOfTag);
            // print(startIndexOfTag);

            // data[data1] == "#"
            //

            // return  inputData.length > 1 && spaceAfter.contains("@") && isTagShow  ? Container (
            return str.length > 1 && isTagShow
                ? Container(
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.only(top: 85),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 0.1)
                    ]
                        // border: Border.all(width: 1, color: Colors.grey.shade300)
                        ),
                    alignment: Alignment.center,
                    child: PagedListView.separated(
                        key: const PageStorageKey("People"),
                        pagingController:
                            AC.searchCubitA!.peoplePagination!.pagingController,
                        padding: const EdgeInsets.only(top: 10),
                        builderDelegate:
                            PagedChildBuilderDelegate<PeopleEntity>(
                                itemBuilder: (c, item, index) {
                          return getPeopleItem1(
                            item,
                            (s) {
                              // context.showSnackBar(message:"test");
                              // AC.searchCubitHash.followUnFollow(index);

                              // textEditingController.text = s.replaceAll("#", "");
                              // postCubit.searchedText = s.replaceAll("#", "");

                              /*  String tmp = str.substring(1,str.length);
                       setState(() {
                         str ='';
                         createPostCubit.postTextValidator.textController.text
                         += s.substring(s.indexOf(tmp)+tmp.length,s.length).replaceAll(' ','_');
                       });*/

                              FocusScope.of(context).requestFocus(
                                  createPostCubit!.postTextValidator.focusNode);

                              createPostCubit!
                                      .postTextValidator.textController.text =
                                  inputData.replaceRange(
                                      startIndexOfTag, inputData.length, "$s ");

                              createPostCubit!.postTextValidator.textController
                                      .selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: createPostCubit!.postTextValidator
                                          .textController.text.length));

                              isTagShow = false;
                              setState(() {});

                              /*  // textFiledData.add ("#$s" + " ");

                       textFiledData.add ("@${s.replaceAll("@", "")}" + " ");

                       String lastTagData = createPostCubit.postTextValidator.textController.text.split("@").last;

                       String data = createPostCubit.postTextValidator.textController.text + lastTagData.replaceAll(lastTagData, s) + " ";

                       createPostCubit.postTextValidator.textController.text = data;

                       // createPostCubit.postTextValidator.textController.text = textFiledData.join(" ");
                       setState(() {});
                       // tabController.animateTo(2,duration: const Duration(milliseconds: 300));*/
                            },
                          );
                        }),
                        separatorBuilder: (BuildContext context, int index) =>
                            commonDivider),

                    /* child:  PagedListView.separated (
                key: const PageStorageKey("People"),
                pagingController: AC.searchCubitA.hashTagPagination.pagingController,
                builderDelegate: PagedChildBuilderDelegate<PeopleEntity> (

                    itemBuilder: (c,item,index) {
                      // print("Hello 123456");
                      // print(item);
                      return getPeopleItem1(item,(s) {
                        // textEditingController.text = s.replaceAll("#", "");
                        // postCubit.searchedText = s.replaceAll("#", "");

                        isTagShow = false;

                        // textFiledData.add ("#$s" + " ");

                        textFiledData.add ("@${s.replaceAll("#", "")}" + " ");

                        String lastTagData = createPostCubit.postTextValidator.textController.text.split("@").last;

                        String data = createPostCubit.postTextValidator.textController.text + lastTagData.replaceAll(lastTagData, s) + " ";

                        createPostCubit.postTextValidator.textController.text = data;


                        // createPostCubit.postTextValidator.textController.text = textFiledData.join(" ");
                        setState(() {});
                        // tabController.animateTo(2,duration: const Duration(milliseconds: 300));
                      });
                    }
                ), separatorBuilder: (BuildContext context, int index) => commonDivider,
              ),*/
                  )
                : Container();
          } else {
            return Container();
          }
        });

    // return StreamBuilder (
    //     stream: createPostCubit.postTextValidator.stream,
    //     initialData: 0,
    //     builder: (context, snapshot) {
    //       if(createPostCubit.postTextValidator.textController.text.trim().isEmpty) {
    //         textFiledData = List();
    //       }
    //       String inputData = createPostCubit.postTextValidator.textController.text;
    //       // List spiltData = inputData.split(" ");
    //       // && spiltData.contains("#")
    //       String lastLatter = "";
    //       if(inputData != null) {
    //         print("in the #");
    //         ///start with        @     <<--------------
    //         // int dataa = data.lastIndexOf("#");
    //         bool isTagShow = false;
    //         int lastIndexInt = -1;
    //         if(inputData.length != 0 ) {
    //           lastIndexInt = inputData.length - 1;
    //           String spaceAfter = inputData.split(" ").last;
    //           lastLatter = inputData.split("@").last;
    //
    //           AC.searchCubitA.hashTagPagination.queryText = lastLatter;
    //           //inputData[lastIndexInt] != " "
    //           if(inputData.length != 0 ) { // || spaceAfter.startsWith("#")
    //             if(inputData[lastIndexInt] == "@") {
    //               doSearch("@", lastLatter);
    //               print("2");
    //               // isTagShow = true;
    //             }
    //             // RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
    //             RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    //
    //             if(alphanumeric.hasMatch(inputData[lastIndexInt])) {
    //               print("1");
    //               isTagShow = true;
    //             }
    //           }
    //         }
    //
    //         // data[data1] == "#"
    //         //
    //
    //         return  inputData.length > 1 && isTagShow  ? Container (
    //           height: 200,
    //           width: 200,
    //           margin: EdgeInsets.only(top: 85),
    //           decoration: BoxDecoration (
    //               color: Colors.white,
    //               border: Border.all(width: 1, color: Colors.grey.shade300)
    //           ),
    //           alignment: Alignment.center,
    //           child:  PagedListView.separated (
    //             key: const PageStorageKey("People"),
    //             pagingController: AC.searchCubitA.hashTagPagination.pagingController,
    //             builderDelegate: PagedChildBuilderDelegate<PeopleEntity> (
    //               // noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen (
    //               //   buttonText: "GO TO HOMEPAGE",
    //               //   icon: const Icon(Icons.search,color: AppColors.colorPrimary,size: 40,),
    //               //   title: "Nothing Found",
    //               //   message:'Sorry, but we could not find anything in our database for your search query  "${textEditingController.text}."  Please try again by typing other keywords.',
    //               //   onTapButton: () {
    //               //     BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
    //               //   },
    //               // ),
    //
    //                 itemBuilder: (c,item,index) {
    //                   // print("Hello 123456");
    //                   // print(item);
    //                   return getPeopleItem1(item,(s) {
    //                     // textEditingController.text = s.replaceAll("#", "");
    //                     // postCubit.searchedText = s.replaceAll("#", "");
    //                     isTagShow = false;
    //                     textFiledData.add ("@${s.replaceAll("@", "")}" + " ");
    //                     createPostCubit.postTextValidator.textController.text = textFiledData.join(" ");
    //                     setState(() {});
    //                     // tabController.animateTo(2,duration: const Duration(milliseconds: 300));
    //                   },
    //                   );
    //                 }
    //
    //             ), separatorBuilder: (BuildContext context, int index) => commonDivider,
    //           ),
    //         ) : Container();
    //       } else { return Container(); }
    //     }
    // );
    ///
    // bool isTagShow = false;
    // int lastIndexInt = -1;
    // if(inputData.length != 0 ) {
    //   lastIndexInt = inputData.length - 1;
    //
    //
    //   String spaceAfter = inputData.split(" ").last;
    //   String lastLatter = inputData.split("@").last;
    //
    //   AC.searchCubit.peoplePagination.queryText = lastLatter;
    //
    //
    //   //|| inputData[lastIndexInt] != " "
    //   if(inputData.length != 0 || spaceAfter.startsWith("@")) {
    //
    //     if(inputData[lastIndexInt] == "@") {
    //       doSearch("@", lastLatter);
    //       print("2");
    //       isTagShow = true;
    //     }
    //
    //     // RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
    //
    //     RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    //
    //     if(alphanumeric.hasMatch(inputData[lastIndexInt])) {
    //       print("1");
    //       isTagShow = true;
    //     }
    //   }
    // }
    //
    // // inputData[lastIndexInt] == "@"
    // return inputData.length != 0 && isTagShow ? Container (
    //   height: 200,
    //   width: 200,
    //   margin: EdgeInsets.only(top: 85),
    //   color: Colors.grey.shade100,
    //   alignment: Alignment.center,
    //   child:  PagedListView.separated (
    //     key: const PageStorageKey("People"),
    //     pagingController: AC.searchCubit.peoplePagination.pagingController,
    //     builderDelegate: PagedChildBuilderDelegate<PeopleEntity> (
    //
    //       // noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen (
    //       //   buttonText: "GO TO HOMEPAGE",
    //       //   icon: const Icon(Icons.search,color: AppColors.colorPrimary,size: 40,),
    //       //   title: "Nothing Found",
    //       //   message:'Sorry, but we could not find anything in our database for your search query  "${textEditingController.text}."  Please try again by typing other keywords.',
    //       //   onTapButton: () {
    //       //     BlocProvider.of<FeedCubit>(context).changeCurrentPage(const ScreenType.home());
    //       //   },
    //       // ),
    //
    //         itemBuilder: (c,item,index) {
    //           return getPeopleItem1(item, (s) {
    //
    //             // textEditingController.text = s.replaceAll("#", "");
    //             // postCubit.searchedText = s.replaceAll("#", "");
    //
    //             isTagShow = false;
    //
    //             textFiledData.add("@${s.replaceAll("@", "")}" + " ");
    //
    //             createPostCubit.postTextValidator.textController.text = textFiledData.join(" ");
    //
    //             setState(() {});
    //
    //             // tabController.animateTo(2,duration: const Duration(milliseconds: 300));
    //
    //           });
    //         }
    //     ), separatorBuilder: (BuildContext context, int index) => commonDivider,
    //   ),
    //
    //   // child: ListView.builder (
    //   //     itemCount: 10,
    //   //     physics: const ClampingScrollPhysics(),
    //   //     shrinkWrap: true,
    //   //     itemBuilder: (context, index) {
    //   //       return Container (
    //   //         height: 30,
    //   //         width: 60,
    //   //         alignment: Alignment.center,
    //   //         color: Colors.grey.shade50,
    //   //         child: Text("hello", style: TextStyle(color: Colors.black)),
    //   //     );
    //   //   }),
    //
    // ) : Container();
  }
}

enum MediaTypeEnum { IMAGE, VIDEO, GIF, EMOJI }
