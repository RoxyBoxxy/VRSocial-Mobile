import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colibri/features/messages/domain/entity/chat_entity.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
@immutable
class SenderChatItem extends StatelessWidget {
  final ChatEntity chatEntity;

  const SenderChatItem({Key key, this.chatEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  FractionallySizedBox(
      widthFactor: .8,
      alignment: Alignment.centerRight,
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(chatEntity.chatMediaType==ChatMediaType.TEXT)
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF737880),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: chatEntity.message
                        .toSubTitle2(color: Colors.white)
                        .toPadding(16),
                  )
                else if(chatEntity.profileUrl.isValidUrl)CachedNetworkImage(
                  placeholder: (c,i)=>const CircularProgressIndicator(),
                  imageUrl: chatEntity.profileUrl,
                ).onTapWidget(() {
                  showAnimatedDialog(
                      alignment: Alignment.center,
                      context: context, builder: (c)=>SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                placeholder: (c,i)=>const CircularProgressIndicator(),
                                imageUrl: chatEntity.profileUrl,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: CloseButton(color: Colors.white,onPressed: (){
                                    ExtendedNavigator.root.pop();
                                  },),
                                ),
                              ),)
                          ],
                        ),
                      ],
                    ).toContainer(height: context.getScreenHeight,alignment: Alignment.center),
                  ),barrierDismissible: true);
                })else Image.file(File(chatEntity.profileUrl)).onTapWidget(() {
                  showAnimatedDialog(
                      alignment: Alignment.center,
                      context: context, builder: (c)=>SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Stack(
                          children: [
                           Center(child: Image.file(File(chatEntity.profileUrl))),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: CloseButton(color: Colors.white,onPressed: (){
                                    ExtendedNavigator.root.pop();
                                  },),
                                ),
                              ),)
                          ],
                        ),
                      ],
                    ).toContainer(height: context.getScreenHeight,alignment: Alignment.center),
                  ),
                      barrierDismissible: true);
                }),
                5.toSizedBox,
                chatEntity.time.toCaption()
              ],
            ),
          ],),
      ).toHorizontalPadding(16).toVerticalPadding(6),
    );
  }
}
