import 'package:colibri/core/common/widget/common_divider.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/presentation/widgets/people_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:colibri/extensions.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ShowLikeScreen extends HookWidget {
  final String postId;

  const ShowLikeScreen(this.postId);

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 1000))
          ..forward();
    context.initScreenUtil();
    final postCubit = useMemoized<PostCubit>(
        () => getIt<PostCubit>()..showLikesPagination.setPostID(postId));
    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder<int>(
              initialData: 0,
              stream: postCubit.showLikesPagination.itemLength,
              builder: (context, snapshot) =>
                  "People who liked (${snapshot.data})".toSubTitle1(
                      color: Colors.white, fontWeight: FontWeight.w600))),
      body: PagedListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        pagingController: postCubit.showLikesPagination.pagingControllerMixin,
        builderDelegate: PagedChildBuilderDelegate<PeopleEntity>(
            noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                  title: 'No likes yet!',
                  buttonVisibility: false,
                  message:
                      'This post appears to have no likes yet. To like this post, click on like button.',
                  icon: AppIcons.likeOption(
                      color: AppColors.colorPrimary, size: 40),
                  onTapButton: () {
                    // ExtendedNavigator.root.push(Routes.createPost);
                  },
                ),
            itemBuilder: (BuildContext context, item, int index) => PeopleItem(
                  peopleEntity: item,
                  onFollowTap: () {
                    postCubit.showLikesPagination.followUnFollow(index);
                  },
                ).toSlideAnimation(controller)),
        separatorBuilder: (BuildContext context, int index) => commonDivider,
      ),
    );
  }
}
