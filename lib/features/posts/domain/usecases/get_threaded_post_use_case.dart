import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/posts/data/model/response/post_detail_response.dart';
import 'package:colibri/features/posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetThreadedPostUseCase extends UseCase<PostDetailResponse, String> {
  final PostRepo postRepo;

  GetThreadedPostUseCase(this.postRepo);
  @override
  Future<Either<Failure, PostDetailResponse>> call(String params) =>
      postRepo.getThreadedPost(params);
}
