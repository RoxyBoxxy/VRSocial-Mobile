import 'package:bloc/bloc.dart';
import 'package:colibri/core/common/stream_validators.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/features/messages/data/models/request/messages_request_model.dart';
import 'package:colibri/features/messages/data/models/request/delete_chat_request_model.dart';
import 'package:colibri/features/messages/domain/entity/chat_entity.dart';
import 'package:colibri/features/messages/domain/usecase/delete_all_messages_use_case.dart';
import 'package:colibri/features/messages/domain/usecase/delete_messag_use_case.dart';
import 'package:colibri/features/messages/domain/usecase/get_chats_use_case.dart';
import 'package:colibri/features/messages/domain/usecase/send_chat_message_use_case.dart';
import 'package:colibri/features/messages/presentation/chat_pagination.dart';
import 'package:colibri/features/search/presentation/pagination/hashtag_pagination.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<CommonUIState> {
  final messageController = BehaviorSubject<List<ChatEntity>?>.seeded([]);
  Function(List<ChatEntity>?) get changeMessageList =>
      messageController.sink.add;
  Stream<List<ChatEntity>?> get messageList => messageController.stream;

  final _scrollHelperController = BehaviorSubject<bool>.seeded(true);
  Function(bool) get changeScrollValue => _scrollHelperController.sink.add;
  Stream<bool> get isScrolling => _scrollHelperController.stream;

  final searchQuery = FieldValidators(null, null);

  final message = FieldValidators(null, null);

  // use case

  final GetChatUseCase? getChatUseCase;

  final SendChatMessageUseCase? sendChatMessageUseCase;

  final DeleteAllMessagesUseCase? deleteAllMessagesUseCase;

  final DeleteMessageUseCase? deleteMessageUseCase;

  final ChatPagination? chatPagination;

  final HashTagPagination? hashTagPagination;

  GlobalKey<AnimatedListState> animatedKey = GlobalKey<AnimatedListState>();
  ChatCubit(
      this.getChatUseCase,
      this.hashTagPagination,
      this.sendChatMessageUseCase,
      this.deleteMessageUseCase,
      this.deleteAllMessagesUseCase,
      this.chatPagination)
      : super(const CommonUIState.success(unit)) {}

  // getChatMessages(String userId) async{
  //   emit(const CommonUIState.loading());
  //   var either = await getChatUseCase(userId);
  //   either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
  //     changeMessageList(r.reversed.toList());
  //     emit(CommonUIState.success(r));
  //   } );
  // }

  sendMessage(String? otherUserId) async {
    emit(const CommonUIState.loading());
    // emit(const CommonUIState.loading());

    var messageText = ChatEntity(
        isSender: true,
        message: message.text,
        time: "a moment ago",
        //  passing null for now will update this on success response
        // message id needed if we will delete the message
        messageId: null);
    // var items=messageController.value;
    // items.insert(0,messageText);
    // changeMessageList(items);
    // animatedKey?.currentState?.insertItem(0);

    var chatRequestModel = MessagesRequestModel(
        type: "text", message: message.text, userId: otherUserId);
    var either = await sendChatMessageUseCase!(chatRequestModel);

    // animatedKey.currentState.didUpdateWidget(animatedKey.currentState.widget);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      //// updating the index value
      // items[0]=messageText.copyWith(time: DateTime.now().getCurrentFormattedTime(),id: r.data.id.toString(),);
      // changeMessageList(items);
      // animatedKey.currentState.removeItem(index, (context, animation) => Duration(mi))
      chatPagination!.pagingController.itemList ??= [];
      chatPagination!.pagingController
        ..itemList!.insert(0, messageText)
        ..notifyListeners();
      // chatPagination.pagingController..itemList.insert(0, messageText)..notifyListeners();
      emit(const CommonUIState.success(unit));
      // chatPagination.onRefresh();
    });
  }

  sendImage(String? path, String? otherUserId) async {
    emit(const CommonUIState.loading());
    final messageText = ChatEntity(
        messageId: null,
        isSender: true,
        profileUrl: path,
        chatMediaType: ChatMediaType.IMAGE,
        message: 'Image',
        time: "a moment ago");
    // var items=messageController.value;
    // items.insert(0,messageText);
    // changeMessageList(items);
    // animatedKey.currentState.insertItem(0);
    // chatPagination.pagingController..itemList.insert(0, messageText)..notifyListeners();
    var chatRequestModel = MessagesRequestModel(
        type: "media",
        message: message.text,
        userId: otherUserId,
        mediaUrl: path);
    var either = await sendChatMessageUseCase!(chatRequestModel);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      //// updating the index value
      // items[0]=messageText.copyWith(time: DateTime.now().getCurrentFormattedTime(),id: r.data.id.toString(),);
      // changeMessageList(items);
      // animatedKey.currentState.removeItem(index, (context, animation) => Duration(mi))
      // emit(CommonUIState.success(items));
      chatPagination!.pagingController.itemList ??= [];
      chatPagination!.pagingController
        ..itemList!.insert(0, messageText)
        ..notifyListeners();
      // chatPagination.pagingController..itemList.insert(0, messageText)..notifyListeners();
      emit(const CommonUIState.success(unit));
    });
  }

  deleteAllMessages(DeleteChatRequestModel deleteChatRequestModel) async {
    emit(const CommonUIState.loading());
    final either = await deleteAllMessagesUseCase!(deleteChatRequestModel);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      // clearing chat only
      if (!deleteChatRequestModel.deleteChat) {
        chatPagination!.onRefresh();
      }
      emit(CommonUIState.success(deleteChatRequestModel.deleteChat
          ? "Chat Deleted Successfully"
          : "Chat Cleared Successfully"));
    });
  }

  // sending last message to the previous screen
  getLastMessage() {
    if (chatPagination!.pagingController.itemList == null ||
        chatPagination?.pagingController.itemList?.isEmpty == true) return '';
    return chatPagination?.pagingController.itemList![0];
  }

  deleteMessage(int index) async {
    emit(const CommonUIState.loading());
    var either = await deleteMessageUseCase!(
        chatPagination!.pagingController.itemList![index].messageId!);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      changeMessageList(
          chatPagination!.pagingController.itemList!..removeAt(index));
      emit(CommonUIState.success(r));
    });
  }
}
