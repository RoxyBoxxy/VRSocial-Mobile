import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeletePostUseCase extends UseCase<dynamic, String> {
  final PostRepo postRepo;

  DeletePostUseCase(this.postRepo);
  @override
  Future<Either<Failure, dynamic>> call(String params) =>
      postRepo.deletePost(params);
}
