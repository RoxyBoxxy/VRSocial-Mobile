import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colibri/core/common/validators.dart';
import 'package:colibri/core/common/widget/searc_bar.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_theme.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/utils/post_helper/hashtag_linker.dart';
import 'package:colibri/core/utils/post_helper/mention_linker.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http_parser/src/media_type.dart';
// import 'package:i18n_extension/default.i18n.dart';
// ignore: avoid_web_libraries_in_flutter
extension StringExtensions on String {

  Future<MultipartFile> toMultiPart()async{
    final mimeTypeData = lookupMimeType(this, headerBytes: [0xFF, 0xD8]).split('/');
    final multipartFile =  await MultipartFile.fromFile(this,contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    return multipartFile;
  }
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.-_]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (this == null && this.isEmpty)
      return false;
    else
      return emailRegExp.hasMatch(this);
  }

  bool get isValidUrl{
    return this!=null&&urlPattern.hasMatch(this);
  }

  Future<MediaInfo> get compressVideo async =>
      await VideoCompress.compressVideo(
        this,
        quality: VideoQuality.DefaultQuality,
        includeAudio: true,
        deleteOrigin: false, // It's false by default
      );
  Future<File> compressImage() async {
    final Directory tempDir = await getTemporaryDirectory();
    final file = File(this);
    print("file is ${file.path}");
    // unsupported compressed file
    if(getFormatType(file.path)==null)return file;
    final result = await FlutterImageCompress.compressAndGetFile(file.path,
        File(tempDir.path+FileUtils.basename(this)).path,
      quality: 60,
      format: getFormatType(file.path)
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  CompressFormat getFormatType(String name) {
    if(name.endsWith(".jpg") || name.endsWith(".jpeg"))return CompressFormat.jpeg;
      else if(name.endsWith(".png"))return CompressFormat.png;
        else if(name.endsWith(".heic"))return CompressFormat.heic;
          else if(name.endsWith(".webp"))return CompressFormat.webp;
          return null;
  }
}

extension StringExtension on String {
  bool get isValidPass {
    if (this == null && this.isEmpty)
      return false;
    else
      return this.length > 7;
  }

  Text get toText => Text(
        parseHtmlString(this),
        style: const TextStyle(),
      );

  Text toHeadLine6(
          {num fontSize = AppFontSize.headLine6,
          FontWeight fontWeight = FontWeight.w400,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style: AppTheme.headline6.copyWith(
            fontSize: fontSize.toSp, color: color, fontWeight: fontWeight),
        textAlign: TextAlign.start,
      );

  Text toHeadLine5(
          {num fontSize = AppFontSize.headLine5,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style:
            AppTheme.headline5.copyWith(fontSize: fontSize.toSp, color: color),
      );

  Text toHeadLine4(
          {num fontSize = AppFontSize.headLine4,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style:
            AppTheme.headline4.copyWith(fontSize: fontSize.toSp, color: color),
      );

  Text toHeadLine3(
          {num fontSize = AppFontSize.headLine3,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style:
            AppTheme.headline3.copyWith(fontSize: fontSize.toSp, color: color),
      );

  Text toHeadLine2(
          {num fontSize = AppFontSize.headLine2,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style:
            AppTheme.headline2.copyWith(fontSize: fontSize.toSp, color: color),
      );

  Text toHeadLine1(
          {num fontSize = AppFontSize.headLine1,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style:
            AppTheme.headline1.copyWith(fontSize: fontSize.toSp, color: color),
      );

  Text toBody1(
          {num fontSize = AppFontSize.bodyText1,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style:
            AppTheme.bodyText1.copyWith(fontSize: fontSize.toSp, color: color),
      );

  Text toBody2(
          {int maxLines,
          num fontSize = AppFontSize.bodyText2,
          FontWeight fontWeight = FontWeight.w400,
          Color color = AppColors.textColor,
          String fontFamily1 = "",
          }) =>
      Text(
        parseHtmlString(this),
        maxLines: maxLines,
        style: AppTheme.bodyText2.copyWith(
            fontSize: fontSize.toSp, color: color, fontWeight: fontWeight, fontFamily: fontFamily1),
      );


  Widget toSubTitle1 (
          {num fontSize = AppFontSize.subTitle1,
          FontWeight fontWeight = FontWeight.w400,
            TextAlign align=TextAlign.left,
            ValueChanged<String> onTapHashtag,
            ValueChanged<String> onTapMention,
            Color color = AppColors.textColor,
            String fontFamily1 = "",
          }) =>

      Linkify(

        strutStyle: const StrutStyle(height: 1.0,forceStrutHeight: false,),
        onOpen: (link) async {
          // closing keyboard
          FocusManager.instance.primaryFocus.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
           if (await canLaunch(link.url)) {
             ExtendedNavigator.root.push(Routes.webViewScreen,arguments: WebViewScreenArguments(url: link.url));
            // await launch(link.url);
          }
           else if(link.url.contains("#")){
             onTapHashtag.call(link.text.replaceAll("#", ""));
           }
           else if(link.url.contains('@'))
             onTapMention.call(link.text.split("@")[1]);
           else {
            throw 'Could not launch $link';
          }
        },

        linkifiers: [

          const HashTagLinker(),

           const UrlLinkifier(),

          const EmailLinkifier(),

          const MentionLinker()
        ],
        text: parseHtmlString(this),
        style: AppTheme.subTitle1.copyWith(
          fontSize: fontSize.toSp,
          // fontSize: fontSize.toSp,
          color: color,
          fontWeight: fontWeight,
          fontFamily: fontFamily1
        ),
        linkStyle: const TextStyle(
          color: AppColors.colorPrimary,decoration: TextDecoration.none),
      );

  // Text(
  //   parseHtmlString(this),
  //   style: AppTheme.subTitle1.copyWith(
  //       fontSize: fontSize.toSp, color: color, fontWeight: fontWeight,),
  // );

  Text toSubTitle2(
          {num fontSize = AppFontSize.subTitle2,
          FontWeight fontWeight = FontWeight.w500,
          TextAlign align,
            int maxLines,
          Color color = AppColors.textColor,
            String fontFamily1 = "",
          }) =>
       Text(
        parseHtmlString(this),
        textAlign: align,
        maxLines: maxLines,
        // overflow: TextOverflow.ellipsis,
        style: AppTheme.subTitle2.copyWith(
            fontSize: fontSize.toSp, color: color, fontWeight: fontWeight, fontFamily: fontFamily1),
      );


  Text toButton(
          {num fontSize = AppFontSize.button,
          FontWeight fontWeight = FontWeight.w600,
          Color color = AppColors.textColor}) =>
      Text(
        parseHtmlString(this),
        style: AppTheme.button.copyWith(
            fontSize: fontSize.toSp, color: color, fontWeight: fontWeight),
      );

  Widget toCaption(
          {num fontSize = AppFontSize.caption,
          int maxLines,
          TextAlign textAlign,
          FontWeight fontWeight = FontWeight.w400,
          TextOverflow textOverflow = TextOverflow.visible,
          Color color = AppColors.textColor}) =>
      Linkify(
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          } else {
            throw 'Could not launch $link';
          }
        },
        textAlign: textAlign,
        text: parseHtmlString(this),
        maxLines: maxLines,
        style: AppTheme.caption.copyWith(

            fontSize: fontSize.toSp, color: color, fontWeight: fontWeight, fontFamily: "CeraPro"),
        linkStyle: const TextStyle(color: AppColors.colorPrimary, fontFamily: "CeraPro"),
      );

  // Text(
  //   _parseHtmlString(this),
  //   overflow: textOverflow,
  //   textAlign: textAlign,
  //   maxLines: maxLines,
  //   softWrap: maxLines>1,
  //   style: AppTheme.caption.copyWith(
  //       fontSize: fontSize.toSp, color: color, fontWeight: fontWeight),
  // );

  TextField toTextField(
          {StringToVoidFunc onSubmit,
          StringToVoidFunc onChange,
          int maxLength}) =>
      TextField(
        maxLength: maxLength,
        style: AppTheme.button.copyWith(fontWeight: FontWeight.w500),
        onChanged: onChange ?? null,
        onSubmitted: (value) {
          onSubmit(value);
        },
        decoration: InputDecoration(
//                disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: .1)),
            contentPadding: EdgeInsets.symmetric(
                vertical: 12.toVertical, horizontal: 6.toHorizontal),
            focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: Colors.red.withOpacity(.8))),
            errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: .8, color: Colors.red.withOpacity(.8))),
            enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: AppColors.placeHolderColor)),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: AppColors.colorPrimary)),
            border: const OutlineInputBorder(),
            labelText: this,
            labelStyle: AppTheme.caption.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.placeHolderColor),
            errorStyle: AppTheme.caption
                .copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
      );

  Widget toSearchBarField (
          {StringToVoidFunc onTextChange,
          FocusNode focusNode,
          TextEditingController textEditingController}) =>
      SearchBar(onTextChange, this, focusNode, textEditingController);

  TextField toNoBorderTextField({Color colors}) => TextField (

        style: AppTheme.button.copyWith(fontWeight: FontWeight.w500),
        maxLines: 3,
        minLines: 3,
        maxLength: 600,
        decoration: InputDecoration (
            contentPadding: const EdgeInsets.all(8),
            counter: const Offstage(),
            border: InputBorder.none,
            hintText: this,
            hintStyle: AppTheme.caption.copyWith(fontWeight: FontWeight.w600, color: colors, fontSize: 16, fontFamily: "CeraPro" )),
      );

  SvgPicture toSvg({num height = 15, num width = 15, Color color}) =>
      SvgPicture.asset(this,
          color: color,
          width: width.toWidth,
          height: width.toHeight,
          semanticsLabel: 'A red up arrow');

  Image toAssetImage({double height = 50, double width = 50}) =>
      Image.asset(this, height: height.toHeight, width: width.toWidth);

  Widget toRoundNetworkImage({num radius = 10, num borderRadius = 60.0}) =>this.isValidUrl?

      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.toDouble()),
        child: CircleAvatar(
          radius: radius.toHeight + radius.toWidth,
          // backgroundImage:Image(),
          child: CachedNetworkImage(
            imageUrl: this,
          ),
          backgroundColor: Colors.transparent,
        ),
      ):ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius.toDouble()),
    child: CircleAvatar(
      radius: radius.toHeight + radius.toWidth,
      // backgroundImage:Image(),
      child: Image.file(File(this,),fit: BoxFit.cover,width: 100,),
      backgroundColor: Colors.transparent,
    ),
  );

  Widget toNetWorkOrLocalImage(
          {num height = 50, num width = 50, num borderRadius = 20}) => this.isValidUrl?
      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.toDouble()),
        child: CachedNetworkImage(
          imageUrl: this,
          height: height.toHeight,
          width: width.toWidth,
          fit: BoxFit.cover,
        ),
      ):Image.file(File(this),fit: BoxFit.cover,width: width.toWidth,height: height.toHeight,);

  Widget toTab() => Tab(
        text: this,
      ).toContainer(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey, width: 0.2))));

  bool get toBool {
    final value = int.tryParse(this);
    if (value == null || value == 0) return false;
    return true;
  }

  String get parseHtml => parseHtmlString(this);

  bool get isVerifiedUser=>this=="1"?true:false;
}

extension StringExtensionNumber on String {
  bool get isValidPhone {
    return this.length >= 10;
  }

  String get inc => (int.tryParse(this) + 1).toString();

  String get dec => (int.tryParse(this) - 1)>0?(int.tryParse(this) - 1).toString():0.toString();

  MediaTypeEnum get getMediaType {
    if (this == null)
      return null;
    else if (this.contains("gif"))
      return MediaTypeEnum.IMAGE;
    else if (this.contains("png") ||
        this.contains("jpeg") ||
        this.contains("jpg")) return MediaTypeEnum.IMAGE;
    return MediaTypeEnum.VIDEO;
  }

  String get toTime {
    // DateFormat dateFormat = DateFormat().add_jms();
    final timeInMili = (int.tryParse(this) * 1000);
    final DateFormat timeFormatter = DateFormat.jm();
    final DateFormat dateFormatter = DateFormat().add_MMMd().add_y();
    final String time = timeFormatter
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMili, isUtc: false));
    final String date = dateFormatter
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMili, isUtc: false));
    return "$time, $date";
  }

  //
  // if(!otherUser)
  // "Edit",
  // if(otherUser)
  // "Pin to profile",
  // if (showThread) "Show Thread",
  // "Share",
  // "Show Likes",
  // "Show repost",
  // !widget.postEntity.isSaved?"Bookmark":"UnBookmark",
  // if(!otherUser)
  // "Delete"

  PostOptionsEnum get getOptionsEnum {
    // if (this == "Edit")
    //   return PostOptionsEnum.EDIT;
    // else if (this == "Pin to profile")
    //   return PostOptionsEnum.PIN_TO_PROFILE;
    // else if (this == "Show Thread")
    //   return PostOptionsEnum.SHOW_THREAD;
    // else if (this == "Share")
    //   return PostOptionsEnum.SHARE;
     if (this == "Show likes")
      return PostOptionsEnum.SHOW_LIKES;
    // else if (this == "Show repost")
    //   return PostOptionsEnum.SHOW_REPOST;
    else if (this == "Bookmark" || this == "UnBookmark")
      return PostOptionsEnum.BOOKMARK;
    return PostOptionsEnum.DELETE;
  }
}

String parseHtmlString(String htmlString) {
  if(htmlString==null)return '';
  final unescape = HtmlUnescape();
  final text = unescape.convert(htmlString).replaceAll(
      RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true), "");
  return text;
}

