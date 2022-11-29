import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/messages/domain/repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteMessageUseCase extends UseCase<dynamic, String> {
  final MessageRepo messageRepo;

  DeleteMessageUseCase(this.messageRepo);
  @override
  Future<Either<Failure, dynamic>> call(String params) {
    return messageRepo.deleteMessage(params);
  }
}
