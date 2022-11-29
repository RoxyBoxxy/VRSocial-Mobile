import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/messages/domain/entity/chat_entity.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class ReceiverChatItem extends StatelessWidget {
  final ChatEntity? chatEntity;
  final String? otherUserProfileUrl;
  const ReceiverChatItem({Key? key, this.chatEntity, this.otherUserProfileUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .8,
      alignment: Alignment.centerLeft,
      child: [
        [
          otherUserProfileUrl!.toNetWorkOrLocalImage(
            height: 50,
            width: 50,
            borderRadius: 10,
          ),
          10.toSizedBox,
          if (chatEntity!.chatMediaType == ChatMediaType.TEXT)
            [
              chatEntity!.message!
                  .toSubTitle2(color: Colors.black)
                  .toPadding(16)
                  .toContainer(
                      decoration: const BoxDecoration(
                          color: AppColors.lightSky,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))))
                  .toFlexible(),
              5.toSizedBox,
              [chatEntity!.time!.toCaption()]
                  .toRow(mainAxisAlignment: MainAxisAlignment.end)
            ]
                .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                .toFlexible()
          else
            CachedNetworkImage(
              key: ObjectKey(chatEntity),
              placeholder: (c, i) => const CircularProgressIndicator(),
              imageUrl: (chatEntity?.profileUrl ==
                      "https://www.colibri-sm.ru/upload/default/avatar.png"
                  ? chatEntity?.message!
                  : chatEntity?.profileUrl!)!,
            ).onTapWidget(() {
              showAnimatedDialog(
                  alignment: Alignment.center,
                  context: context,
                  builder: (c) => SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: CachedNetworkImage(
                                      placeholder: (c, i) =>
                                          const CircularProgressIndicator(),
                                      imageUrl: (chatEntity?.profileUrl ==
                                              "https://www.colibri-sm.ru/upload/default/avatar.png"
                                          ? chatEntity?.message!
                                          : chatEntity?.profileUrl!)!
                                      //chatEntity.message,
                                      ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: CloseButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          ExtendedNavigator.root.pop();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ).toContainer(
                            height: context.getScreenHeight as double,
                            alignment: Alignment.center),
                      ),
                  barrierDismissible: true);
            }).toFlexible()
        ].toRow(),
      ].toColumn().toContainer().toHorizontalPadding(16).toVerticalPadding(6),
    );
  }
}
