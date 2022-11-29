import 'package:colibri/core/common/failure.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/usecase/like_unlike_use_case.dart';
import 'package:colibri/features/feed/domain/usecase/repost_use_case.dart';
import 'package:colibri/features/posts/domain/usecases/add_remove_bookmark_use_case.dart';
import 'package:colibri/features/posts/domain/usecases/delete_post_use_case.dart';
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart';
import 'package:colibri/features/posts/presentation/pagination/show_likes_pagination.dart';
import 'package:colibri/features/profile/data/models/request/profile_posts_model.dart';
import 'package:colibri/features/profile/domain/usecase/get_profile_like_posts.dart';
import 'package:colibri/features/search/domain/usecase/search_post_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'user_likes_state.dart';

@injectable
class UserLikesCubit extends PostCubit {
  final GetProfileLikedPostsUseCase? getProfileLikedPostsUseCase;
  String? userId;

  UserLikesCubit(
      AddOrRemoveBookmarkUseCase? addOrRemoveBookmarkUseCase,
      LikeUnlikeUseCase? likeUnlikeUseCase,
      RepostUseCase? repostUseCase,
      DeletePostUseCase? deletePostUseCase,
      SearchPostUseCase? searchPostUseCase,
      this.getProfileLikedPostsUseCase,
      ShowLikesPagination? showLikesPagination)
      : super(addOrRemoveBookmarkUseCase, likeUnlikeUseCase, repostUseCase,
            deletePostUseCase, searchPostUseCase, showLikesPagination);

  @override
  Future<Either<Failure, List<PostEntity>>?> getItems(int pageKey) async {
    return await getProfileLikedPostsUseCase!(
        PostCategoryModel(pageKey.toString(), PostCategory.LIKED, userId));
  }
}
