import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/custom_pagination.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/profile/domain/usecase/get_profile_media_posts.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileMediaPagination extends CustomPagination<PostEntity> {
  final GetProfileMediaUseCase getProfileMediaUseCase;
  // String userId;
  ProfileMediaPagination(this.getProfileMediaUseCase);

  @override
  Future<Either<Failure, List<PostEntity>>> getItems(int pageKey) async {
    // return await getProfileMediaUseCase(PostCategoryModel(pageKey.toString(), PostCategory.MEDIA,userId));
  }

  @override
  PostEntity getLastItemWithoutAd(List<PostEntity> item) {
    if (item.last.isAdvertisement) return item[item.length - 2];
    return item.last;
  }

  @override
  int getNextKey(PostEntity item) {
    return item.offSetId ?? 0;
  }

  @override
  bool isLastPage(List<PostEntity> item) {
    if (item.last.isAdvertisement && item.length == ApiConstants.pageSize + 1)
      return false;
    else if (!item.last.isAdvertisement && item.length == ApiConstants.pageSize)
      return false;
    return true;
  }

  @override
  onClose() {
    super.onClose();
    pagingController.dispose();
  }
}