import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAccountUseCase extends UseCase<dynamic,String>{
  final ProfileRepo profileRepo;

  DeleteAccountUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(String params) => profileRepo.deleteAccount(params);

}