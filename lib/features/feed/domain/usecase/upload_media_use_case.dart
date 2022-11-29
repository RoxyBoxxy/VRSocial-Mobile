import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/media/media_data.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/feed/domain/repo/feed_repo.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/posts/domain/entiity/media_entity.dart';
import 'package:colibri/features/posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadMediaUseCase extends UseCase<MediaEntity, MediaData> {
  final PostRepo postRepo;

  UploadMediaUseCase(this.postRepo);
  @override
  Future<Either<Failure, MediaEntity>> call(MediaData params) {
    return postRepo.uploadMedia(params);
  }
}
