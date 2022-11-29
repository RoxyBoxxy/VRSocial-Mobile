import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/profile/data/models/request/update_password_request.dart';
import 'package:colibri/features/profile/data/models/request/update_setting_request_model.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePasswordUseCase extends UseCase<dynamic, UpdatePasswordRequest> {
  final ProfileRepo profileRepo;
  UpdatePasswordUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(params) {
    return profileRepo.updatePassword(params);
  }
}
