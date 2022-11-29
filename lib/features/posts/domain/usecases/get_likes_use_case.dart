import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/posts/data/model/request/like_request_model.dart';
import 'package:colibri/features/posts/domain/post_repo.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLikesUseCase extends UseCase<List<PeopleEntity>, LikesRequestModel> {
  final PostRepo postRepo;

  GetLikesUseCase(this.postRepo);

  @override
  Future<Either<Failure, List<PeopleEntity>>> call(params) =>
      postRepo.getPostLikes(params);
}
