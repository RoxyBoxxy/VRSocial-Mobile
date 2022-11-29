import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/text_model_with_offset.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/search/domain/entity/people_entity.dart';
import 'package:colibri/features/search/domain/repo/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchPeopleUseCase extends UseCase<List<PeopleEntity>,TextModelWithOffset>{
  final SearchRepo searchRepo;
  SearchPeopleUseCase(this.searchRepo);
  @override
  Future<Either<Failure, List<PeopleEntity>>> call(TextModelWithOffset params) {
    return searchRepo.searchPeople(params);
  }

}