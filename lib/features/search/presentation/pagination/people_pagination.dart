import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/custom_pagination.dart';
import 'package:colibri/core/common/pagination/text_model_with_offset.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/domain/usecase/search_people_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class PeoplePagination extends CustomPagination<PeopleEntity>
    with SearchingMixin<PeopleEntity> {
  final SearchPeopleUseCase searchPeopleUseCase;

  PeoplePagination(this.searchPeopleUseCase) {
    enableSearch();
  }

  @override
  Future<Either<Failure, List<PeopleEntity>>> getItems(int pageKey) async {
    return await searchPeopleUseCase(
        TextModelWithOffset(queryText: queryText, offset: pageKey.toString()));
  }

  @override
  PeopleEntity getLastItemWithoutAd(List<PeopleEntity> item) {
    return item.last;
  }

  @override
  int getNextKey(PeopleEntity item) {
    return int.tryParse(item.id);
  }

  @override
  bool isLastPage(List<PeopleEntity> item) {
    return item.length < ApiConstants.pageSize;
  }

  @override
  onClose() {
    super.onClose();
    disposeMixin();
    pagingController.dispose();
  }
}
