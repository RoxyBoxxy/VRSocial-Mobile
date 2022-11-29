import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/messages/data/models/request/messages_request_model.dart';
import 'package:colibri/features/messages/data/models/response/send_message_response.dart';
import 'package:colibri/features/messages/domain/repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendChatMessageUseCase
    extends UseCase<SendMessageResponse, MessagesRequestModel> {
  final MessageRepo? messageRepo;

  SendChatMessageUseCase(this.messageRepo);
  @override
  Future<Either<Failure, SendMessageResponse>> call(params) {
    return messageRepo!.sendMessage(params);
  }
}
