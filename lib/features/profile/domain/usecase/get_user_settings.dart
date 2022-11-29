import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/profile/domain/entity/setting_entity.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserSettingsUseCase extends UseCase<SettingEntity, Unit> {
  final ProfileRepo? profileRepo;

  GetUserSettingsUseCase(this.profileRepo);
  @override
  Future<Either<Failure, SettingEntity>> call(Unit params) {
    return profileRepo!.getUserSettings();
  }
}
