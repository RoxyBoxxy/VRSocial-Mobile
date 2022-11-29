import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/profile/domain/entity/setting_entity.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
@injectable
class UpdatePrivacyUseCase extends UseCase<dynamic,AccountPrivacyEntity>{
  final ProfileRepo profileRepo;

  UpdatePrivacyUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(AccountPrivacyEntity params) {
    return profileRepo.updatePrivacy(params);
  }

}