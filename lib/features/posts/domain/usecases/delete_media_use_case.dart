import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/posts/domain/entiity/media_entity.dart';
import 'package:colibri/features/posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteMediaUseCase extends UseCase<dynamic, MediaEntity> {
  final PostRepo postRepo;

  DeleteMediaUseCase(this.postRepo);
  @override
  Future<Either<Failure, dynamic>> call(MediaEntity params) =>
      postRepo.deleteMedia(params);
}
