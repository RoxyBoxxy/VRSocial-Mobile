import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/static_data/all_countries.dart';
import 'package:colibri/core/common/stream_validators.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/common/validators.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/features/profile/data/models/request/update_password_request.dart';
import 'package:colibri/features/profile/data/models/request/update_setting_request_model.dart';
import 'package:colibri/features/profile/data/models/request/verify_request_model.dart';
import 'package:colibri/features/profile/domain/entity/setting_entity.dart';
import 'package:colibri/features/profile/domain/usecase/change_language_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/delete_account_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/get_login_mode.dart';
import 'package:colibri/features/profile/domain/usecase/get_user_settings.dart';
import 'package:colibri/features/profile/domain/usecase/udpate_password_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/update_privacy_setting_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/update_profile_setting_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/verify_user_account_use_case.dart';
import 'package:colibri/features/profile/presentation/pages/settings/update_user_settings.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'user_setting_state.dart';

@injectable
class UserSettingCubit extends Cubit<CommonUIState> {
  //settings
  final _settingEntityController = BehaviorSubject<SettingEntity>();

  Function(SettingEntity) get changeSettingEntity =>
      _settingEntityController.sink.add;

  Stream<SettingEntity> get settingEntity => _settingEntityController.stream;

  // all countries
  final _countriesListController =
      BehaviorSubject<List<String>>.seeded(ApiConstants.allCountries);
  Function(List<String>) get changeCountries =>
      _countriesListController.sink.add;
  Stream<List<String>> get countries => _countriesListController.stream;

  final _allLanguagesController =
      BehaviorSubject<List<String>>.seeded(ApiConstants.allLanguages);
  Function(List<String>) get changeLanguage => _allLanguagesController.sink.add;
  Stream<List<String>> get languages => _allLanguagesController.stream;

  // update user name and name
  FieldValidators firstNameValidator;
  FieldValidators userNameValidator;
  FieldValidators lastNameValidator;

  // update email
  FieldValidators emailValidator;

  // update website
  FieldValidators websiteValidators;

  // update about you
  FieldValidators aboutYouValidators;

  String gender = "M";

  FieldValidators fullNameValidators;

  FieldValidators messageToReceiverValidators;

  FieldValidators oldPasswordValidator;

  FieldValidators newPasswordValidator;

  FieldValidators confirmPasswordValidator;

  FieldValidators deleteAccountValidator;

  final _selectedLangController = BehaviorSubject<String>();
  Function(String) get changeSelectedLang => _selectedLangController.sink.add;
  Stream<String> get selectedLang => _selectedLangController.stream;

  // verify Account
  FieldValidators verifyFullNameValidator;
  FieldValidators verifyMessageValidator;

  final _videoPathController = BehaviorSubject<String>();

  Function(String) get changeVideoPath => _videoPathController.sink.add;

  Stream<String> get videoPath => _videoPathController.stream;

  // use cases
  final UpdateUserSettingsUseCase updateUserSettingsUseCase;

  final UpdatePasswordUseCase updatePasswordUseCase;

  final UpdatePrivacyUseCase updatePrivacyUseCase;

  final GetUserSettingsUseCase getUserSettingsUseCase;

  final DeleteAccountUseCase deleteAccountUseCase;

  final VerifyUserAccountUseCase verifyUserAccountUseCase;

  final ChangeLanguageUseCase changeLanguageUseCase;

  final GetLoginMode loginMode;

  UserSettingCubit(
      this.getUserSettingsUseCase,
      this.updateUserSettingsUseCase,
      this.updatePasswordUseCase,
      this.updatePrivacyUseCase,
      this.deleteAccountUseCase,
      this.verifyUserAccountUseCase,
      this.changeLanguageUseCase,
      this.loginMode)
      : super(const CommonUIState.initial()) {
    initValidators();
  }

  getUserSettings() async {
    emit(const CommonUIState.loading());
    var either = await getUserSettingsUseCase(unit);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) async {
      var mode = await getLoginMode();
      emit(CommonUIState.success(r.copyWith(didSocialLogin: mode)));
      setAllUserData(r.copyWith(didSocialLogin: mode));
    });
  }

  Future<bool> getLoginMode() async {
    var mode = await loginMode(unit);
    var m = false;
    mode.fold((l) {
      m = false;
    }, (r) {
      m = r;
    });
    return m;
  }

  updateUserSettings(UpdateSettingEnum updateSettingEnum) async {
    // print(updateSettingEnum.toString());
    emit(const CommonUIState.loading());
    if (updateSettingEnum == UpdateSettingEnum.PASSWORD) {
      final either = await updatePasswordUseCase(UpdatePasswordRequest(
          newPassword: newPasswordValidator.text,
          oldPassword: oldPasswordValidator.text));
      either.fold((l) {
        switch (updateSettingEnum) {
          case UpdateSettingEnum.USERNAME:
            userNameValidator.changeData("new value");
            userNameValidator.textController.text = "new value";
            break;
          case UpdateSettingEnum.EMAIL:
            break;
          case UpdateSettingEnum.WEBSITE:
            break;
          case UpdateSettingEnum.ABOUT_YOU:
            break;
          case UpdateSettingEnum.GENDER:
            break;
          case UpdateSettingEnum.COUNTRY:
            break;
          case UpdateSettingEnum.PASSWORD:
            oldPasswordValidator.addError(l.errorMessage);
            break;
          case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
            break;
          case UpdateSettingEnum.CHANGE_LANGUAGE:
            break;
          case UpdateSettingEnum.DELETE_ACCOUNT:
            break;
        }
        return emit(CommonUIState.error(l.errorMessage));
      },
          (r) => emit(
              const CommonUIState.success("Password changed successfully")));
    } else {
      print(
          "c ${ApiConstants.allCountries.indexOf(_settingEntityController.value.country).toString()}");
      var either = await updateUserSettingsUseCase(UpdateSettingsRequestModel(
          firstName: firstNameValidator.text,
          lastName: lastNameValidator.text,
          username: userNameValidator.text,
          email: emailValidator.text,
          gender: gender,
          countryId:
              HashMap.from(countryMap)[_settingEntityController.value.country],
          aboutYou: aboutYouValidators.text,
          website: websiteValidators.text));
      either.fold((l) {
        emit(CommonUIState.error(l.errorMessage));
      }, (r) async {
        emit(const CommonUIState.success("Profile updated successfully"));
        await getUserSettings();
      });
    }
    // emit(CommonUIState.initial());
  }

  updateUserPrivacy() async {
    emit(const CommonUIState.loading());
    var either = await updatePrivacyUseCase(
        _settingEntityController.value.accountPrivacyEntity);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) async {
      emit(const CommonUIState.success("Privacy updated successfully"));
      await getUserSettings();
    });
  }

  void initValidators() {
    userNameValidator =
        FieldValidators(notEmptyValidator(FieldType.USERNAME), null);
    lastNameValidator = FieldValidators(
        notEmptyValidator(FieldType.LAST_NAME), userNameValidator.focusNode);
    firstNameValidator = FieldValidators(
        notEmptyValidator(FieldType.FIRST_NAME), lastNameValidator.focusNode);
    emailValidator = FieldValidators(validateEmail, null);
    websiteValidators = FieldValidators(null, null);
    aboutYouValidators = FieldValidators(null, null);
    fullNameValidators = FieldValidators(null, null);
    messageToReceiverValidators = FieldValidators(null, null);

    oldPasswordValidator = FieldValidators(null, null, obsecureTextBool: true);
    confirmPasswordValidator = FieldValidators(
        StreamTransformer.fromHandlers(handleData: (string, sink) {
      if (string == newPasswordValidator.text) {
        sink.add(string);
      } else {
        sink.addError("Please make sure password match");
      }
    }), null, obsecureTextBool: true, passwordField: true);
    newPasswordValidator = FieldValidators(
        validatePassword(), confirmPasswordValidator.focusNode,
        obsecureTextBool: true, passwordField: true);
    deleteAccountValidator = FieldValidators(
        validatePassword(errorText: "Please enter your current password!"),
        null,
        obsecureTextBool: true);

    verifyFullNameValidator = FieldValidators(null, null);
    verifyMessageValidator = FieldValidators(null, null);
    // selectedLangValidator =
    //     FieldValidators(notEmptyValidator(FieldType.NOT_EMPTY), null);
    // verifyVideoPathValidator=FieldValidators(null,null);
  }

  deleteAccount() async {
    emit(const CommonUIState.loading());
    var either = await deleteAccountUseCase(deleteAccountValidator.text);
    either.fold(
        (l) => emit(CommonUIState.error(l.errorMessage)),
        (r) =>
            emit(const CommonUIState.success("Account Deleted Successfully")));
  }

  verifyUserAccount() async {
    if (verifyFullNameValidator.text.isEmpty) {
      emit(const CommonUIState.error('First name is empty'));
    } else if (verifyMessageValidator.text.isEmpty) {
      emit(const CommonUIState.error('message is empty'));
    } else if (_videoPathController.value.isEmpty) {
      emit(const CommonUIState.error('Please choose video file'));
    } else {
      emit(const CommonUIState.loading());
      await verifyUserAccountUseCase(VerifyRequestModel(
          fullName: verifyFullNameValidator.text,
          message: verifyMessageValidator.text,
          video: _videoPathController.value))
        ..fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
          // clearing all the stored values
          verifyFullNameValidator.clear;
          verifyMessageValidator.clear;
          changeVideoPath('');
          emit(const CommonUIState.success(
              'Verification request sent successfully'));
        });
    }
  }

  changeUserLanguage() async {
    emit(const CommonUIState.loading());
    var either = await changeLanguageUseCase(_selectedLangController.value);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)),
        (r) => emit(CommonUIState.success(r)));
  }

  resetAllData() {
    final value = _settingEntityController.value;
    // _videoPathController.addError(null);
    verifyMessageValidator.textController.clear();
    verifyFullNameValidator.textController.clear();
    changeVideoPath("Select a video appeal to the reviewer");
    // deleteAccountValidator.addError(null);
    // confirmPasswordValidator.addError(null);
    // newPasswordValidator.addError(null);
    // oldPasswordValidator.addError(null);
    // messageToReceiverValidators.addError(null);
    // fullNameValidators.addError(null);
    // aboutYouValidators.addError(null);
    // websiteValidators.addError(null);
    // emailValidator.addError(null);
    // lastNameValidator.addError(null);
    // userNameValidator.addError(null);
    // firstNameValidator..addError(null)..textController.clear();
    newPasswordValidator.onChange("");
    oldPasswordValidator.onChange("");
    confirmPasswordValidator.onChange("");
    firstNameValidator.onChange(value.firstName);
    lastNameValidator.onChange(value.lastName);
    userNameValidator.onChange(value.userName);
    emailValidator.onChange(value.email);
    aboutYouValidators.onChange(value.about);
    setAllUserData(_settingEntityController.value);
  }

  void setAllUserData(SettingEntity r) {
    userNameValidator.textController.text = r.userName.replaceAll("@", "");
    firstNameValidator.textController.text = r.firstName;
    lastNameValidator.textController.text = r.lastName;
    websiteValidators.textController.text =
        r.website == Strings.emptyWebsite ? "" : r.website;
    aboutYouValidators.textController.text =
        r.about == Strings.emptyAbout ? "" : r.about;
    emailValidator.textController.text = r.email;
    gender = r.gender == "Female" ? "F" : "M";
    changeSettingEntity(r);
  }
}
