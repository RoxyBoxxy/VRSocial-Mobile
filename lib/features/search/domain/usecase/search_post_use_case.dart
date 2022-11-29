import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/text_model_with_offset.dart';
import 'package:colibri/core/common/usecase.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/search/domain/repo/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchPostUseCase extends UseCase<List<PostEntity>,TextModelWithOffset>{
  final SearchRepo searchRepo;

  SearchPostUseCase(this.searchRepo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(TextModelWithOffset params) async{
    return searchRepo.searchPosts(params);
  }

}