import 'package:bloc/bloc.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/features/posts/domain/usecases/log_out_use_case.dart';
import 'package:colibri/features/profile/domain/entity/profile_entity.dart';
import 'package:colibri/features/profile/domain/usecase/follow_unfollow_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/get_profile_data_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/update_profile_cover_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/uppdate_profile_avatar_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<CommonUIState> {
  final _profileEntityController = BehaviorSubject<ProfileEntity>();

  Function(ProfileEntity) get changeProfileEntity =>
      _profileEntityController.sink.add;

  Stream<ProfileEntity> get profileEntity => _profileEntityController.stream;

  // use cases
  final GetProfileUseCase _getProfileUseCase;

  final FollowUnFollowUseCase followUnFollowUseCase;

  final LogOutUseCase logOutUseCase;

  final UpdateProfileCoverUseCase _updateProfileCoverUseCase;

  final UpdateAvatarProfileUseCase _updateAvatarProfileUseCase;

  bool isPrivateUser = false;

  ProfileCubit(
      this._getProfileUseCase,
      // this.mediaPagination,
      // this.profileLikesPagination,
      this.followUnFollowUseCase,
      this.logOutUseCase,
      this._updateProfileCoverUseCase,
      this._updateAvatarProfileUseCase)
      : super(const CommonUIState.initial());

  getUserProfile(String userId, String coverUrl, String profileUrl) async {
    emit(const CommonUIState.loading());
    final either = await _getProfileUseCase(userId);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      final profileEntity =
          r.copyWith(profileUrl: profileUrl, coverUrl: coverUrl);
      changeProfileEntity(profileEntity);
      emit(CommonUIState.success(profileEntity));
    });
  }

  followUnFollow() async {
    var item = _profileEntityController.value;
    // var currentItem=peoplePagination.pagingController.itemList[index];
    // peoplePagination.pagingController
    //     .itemList[index]=currentItem.copyWith(isFollowed: !currentItem.isFollowed,buttonText: currentItem.isFollowed?"Unfollow":"follow");
    // peoplePagination.pagingController.notifyListeners();

    var either = await followUnFollowUseCase(item.id);
    changeProfileEntity(item.copyWith(isFollowing: !item.isFollowing));
    // either.fold((l) {
    //   emit(CommonUIState.error(l.errorMessage));
    //   peoplePagination.pagingController
    //     ..itemList[index]=currentItem.copyWith(isFollowed: !currentItem.isFollowed,buttonText: currentItem.isFollowed?"Unfollow":"follow")
    //     ..notifyListeners();
    // }, (r) {});
  }

  updateProfileCover(String imagePath) async {
    emit(const CommonUIState.loading());
    var either = await _updateProfileCoverUseCase(imagePath);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)),
        (r) => emit(CommonUIState.success(r)));
  }

  updateProfileAvatar(String imagePath) async {
    emit(const CommonUIState.loading());
    var either = await _updateAvatarProfileUseCase(imagePath);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)),
        (r) => emit(CommonUIState.success(r)));
  }

  logoutUser() async {
    var either = await logOutUseCase(unit);
    either.fold((l) => null, (r) => null);
  }
}
