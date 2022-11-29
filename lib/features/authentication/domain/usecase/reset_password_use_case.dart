import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/authentication/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordUseCase extends UseCase<String,String>{
  final AuthRepo authRepo;
  ResetPasswordUseCase(this.authRepo);
  @override
  Future<Either<Failure, String>> call(String params) {
    return authRepo.resetPassword(params);
  }

}