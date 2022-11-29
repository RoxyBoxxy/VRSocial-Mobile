import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/profile/data/models/request/profile_posts_model.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileLikedPostsUseCase
    extends UseCase<List<PostEntity>, PostCategoryModel> {
  final ProfileRepo profileRepo;
  GetProfileLikedPostsUseCase(this.profileRepo);

  @override
  Future<Either<Failure, List<PostEntity>>> call(PostCategoryModel params) {
    return profileRepo.getUserPostByCategory(params);
  }
}
