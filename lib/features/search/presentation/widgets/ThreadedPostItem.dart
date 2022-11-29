import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/widgets/slider.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:timelines/timelines.dart';

class ThreadedPostItem extends StatefulWidget {
  final bool startingThread;
  final bool lastThread;
  final PostEntity postEntity;
  const ThreadedPostItem(
      {Key key,
      this.startingThread = false,
      this.lastThread = false,
      this.postEntity})
      : super(key: key);

  @override
  _ThreadedPostItemState createState() => _ThreadedPostItemState();
}

class _ThreadedPostItemState extends State<ThreadedPostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 140.toHeight,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          25.toSizedBox,
          // Expanded(child: SolidLineConnector()),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // SolidLineConnector().toContainer(color: Colors.red,height: 10),
              widget.postEntity.profileUrl
                  .toRoundNetworkImage(radius: 13)
                  .toFlexible(),
              "test".toText.toContainer(color: Colors.red)
            ],
          ),
          // Stack(
          //   alignment: Alignment.center,
          //
          //   children: [
          //     Visibility(
          //         visible: !widget.lastThread,
          //         child: SizedBox(
          //           height: 150,
          //           child: SolidLineConnector(),
          //         )),
          //     widget.postEntity.profileUrl
          //         .toRoundNetworkImage(radius: 13)
          //       //   .toContainer(
          //       // height: 200,
          //       //     alignment: Alignment.topCenter,
          //       //   ),
          //   ],
          // ),
          [
            5.toSizedBox,
            [
              widget.postEntity.name.toSubTitle1(
                  color: Colors.black, fontWeight: FontWeight.bold),
              20.toSizedBoxHorizontal,
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey),
              ),
              5.toSizedBoxHorizontal,
              widget.postEntity.time.toCaption(),
              [
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ).toContainer().toHorizontalPadding(4).toContainer(
                      alignment: Alignment.centerRight,
                    )
              ].toRow(mainAxisAlignment: MainAxisAlignment.end).toExpanded()
            ]
                .toRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                )
                .toContainer(alignment: Alignment.topCenter),
            widget.postEntity.userName.toSubTitle1(),
            5.toSizedBox,
            [
              "In response to".toCaption(fontSize: 13),
              5.toSizedBoxHorizontal,
              // widget.postEntity.responseTo.toButton(fontSize: 13,color: AppColors.colorPrimary),
              5.toSizedBoxHorizontal,
              "Post".toCaption(fontSize: 13)
            ].toRow().toVisibility(widget.postEntity.responseTo != null),
            if (widget.postEntity.media?.isNotEmpty)
              CustomSlider(
                  mediaItems: widget?.postEntity?.media,
                  isOnlySocialLink: false),
            // CustomSlider(mediaItems: widget?.postEntity?.media,),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: widget.postEntity.description
                  .toSubTitle1(fontWeight: FontWeight.bold),
            ),
            8.toSizedBox,
            [
              [
                buildPostButton(
                        AppIcons.commentIcon, widget.postEntity.commentCount)
                    .onTapWidget(() {}),
                buildPostButton(
                    AppIcons.repostIcon(), widget.postEntity.repostCount),
                // buildPostButton(AppIcons.likeIcon, widget.postEntity.likeCount)
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .toExpanded(flex: 4),
              getShareOptionMenu()
                  .toContainer(alignment: const Alignment(0.4, 0))
                  .toExpanded(flex: 1),
            ].toRow(),
            // if(!widget.lastThread)
            // Expanded(child: Container(child: Divider(thickness: .4,),))
          ]
              .toColumn(mainAxisAlignment: MainAxisAlignment.start)
              .toHorizontalPadding(12)
              .toExpanded(flex: 4)
        ],
      ),
    );
  }
}
