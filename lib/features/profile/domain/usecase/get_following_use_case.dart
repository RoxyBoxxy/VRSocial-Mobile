import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/profile/data/models/request/profile_posts_model.dart';
import 'package:colibri/features/profile/domain/entity/follower_entity.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFollowingUseCase
    extends UseCase<List<FollowerEntity>, PostCategoryModel> {
  final ProfileRepo? profileRepo;

  GetFollowingUseCase(this.profileRepo);
  @override
  Future<Either<Failure, List<FollowerEntity>>> call(
          PostCategoryModel params) async =>
      profileRepo!.getFollowing(params);
}
