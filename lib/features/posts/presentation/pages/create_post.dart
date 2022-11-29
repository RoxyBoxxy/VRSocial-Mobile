import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/posts/domain/entiity/reply_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_compress/video_compress.dart';

class CreatePost extends StatefulWidget {
  final String title;
  final String? replyTo;
  final String? threadId;
  final ReplyEntity? replyEntity;
  const CreatePost(
      {Key? key,
      this.title = "Create Post",
      this.replyTo = "",
      this.threadId,
      this.replyEntity})
      : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  ScrollController? scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    if (VideoCompress.compressProgress$.notSubscribed) {
      listenVideoStream();
    } else {
      // disposing already subscribed stream
      VideoCompress.dispose();
      listenVideoStream();
    }
    // if(widget.replyEntity!=null)
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return WillPopScope(
      onWillPop: () {
        FocusManager.instance.primaryFocus!.unfocus();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: widget.title.toSubTitle1(
                color: AppColors.textColor, fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: BlocProvider(
              create: (c) => getIt<FeedCubit>(),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // 10.toSizedBox,
                    // [
                    //   65.toSizedBoxHorizontal,
                    //   "Replying to".toCaption(),
                    // 3.toSizedBox,
                    //   widget.replyTo.toCaption(color: AppColors.colorPrimary,fontWeight: FontWeight.w600)
                    // ]
                    //     .toRow()
                    //     .toVisibility(widget.replyTo.isNotEmpty),

                    CreatePostCard(
                      threadId: widget.threadId,
                      replyEntity: widget.replyEntity,
                    ),
                  ],
                ).makeScrollable(),
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // FocusScope.of(context).requestFocus(FocusNode());
    VideoCompress.dispose();
    super.dispose();
  }

  void listenVideoStream() {
    VideoCompress.compressProgress$.subscribe((progress) {
      if (progress < 99.99)
        EasyLoading.showProgress(
          (progress / 100),
          status: 'Compressing ${progress.toInt()}%',
        );
      else
        EasyLoading.dismiss();
    });
  }
}
