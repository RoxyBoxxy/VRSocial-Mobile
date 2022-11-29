


// @injectable
// class PostPagination extends CustomPagination<PostEntity> with PostInteractionMixin,SearchingMixin<PostEntity>{
//
//   final AddOrRemoveBookmarkUseCase addOrRemoveBookmarkUseCase;
//   final LikeUnlikeUseCase likeUnlikeUseCase;
//   final RepostUseCase repostUseCase;
//   final DeletePostUseCase deletePostUseCase;
//
//   PostPagination(this.addOrRemoveBookmarkUseCase, this.likeUnlikeUseCase, this.repostUseCase, this.deletePostUseCase){
//     enableSearch();
//   }
//   @override
//   Future<Either<Failure, List<PostEntity>>> getItems(int pageKey) {
//
//   }
//
//   @override
//   PostEntity getLastItemWithoutAd(List<PostEntity> item) {
//     // TODO: implement getLastItemWithoutAd
//     throw UnimplementedError();
//   }
//
//   @override
//   int getNextKey(PostEntity item) {
//     // TODO: implement getNextKey
//     throw UnimplementedError();
//   }
//
//   @override
//   bool isLastPage(List<PostEntity> item) {
//     // TODO: implement isLastPage
//     throw UnimplementedError();
//   }
//
//
//
//   @override
//   onClose() {
//     // TODO: implement onClose
//     throw UnimplementedError();
//   }
//
//
//   Future<Either<Failure, String>> addOrRemoveBookmark(int index) {
//     return mAddRemoveBookmark(index,addOrRemoveBookmarkUseCase);
//   }
//
//
//   Future<Either<Failure, String>> deletePost(int index) async{
//     return await mDeletePost(index, deletePostUseCase);
//   }
//
//
//   Future<Either<Failure, String>> likeUnlikePost(int index) async{
//     return await mLikeUnlike(index, likeUnlikeUseCase);
//   }
//
//
//   Future<Either<Failure, String>> repost(int index) async{
//     return await mRepost(index, repostUseCase);
//   }
//
//
// }