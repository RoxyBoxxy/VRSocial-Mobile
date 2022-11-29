import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileCoverUseCase extends UseCase<String?, String> {
  final ProfileRepo? profileRepo;

  UpdateProfileCoverUseCase(this.profileRepo);
  @override
  Future<Either<Failure, String?>> call(String params) {
    return profileRepo!.updateCover(params);
  }
}
