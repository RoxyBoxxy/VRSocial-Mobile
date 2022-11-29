import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/features/feed/domain/entity/drawer_entity.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDrawerDataUseCase extends UseCase<ProfileEntity, Unit> {
  final ProfileRepo profileRepo;
  GetDrawerDataUseCase(this.profileRepo);
  @override
  Future<Either<Failure, ProfileEntity>> call(Unit params) async {
    return await profileRepo.getProfileData(null);
  }
}
