import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/buttons/custom_button.dart';
import 'package:colibri/core/common/static_data/all_countries.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/core/widgets/media_picker.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:colibri/features/profile/domain/entity/setting_entity.dart';
import 'package:colibri/features/profile/presentation/bloc/settings/user_setting_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:colibri/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_select/smart_select.dart';

class UpdateUserProfile extends StatefulWidget {
  final UpdateSettingEnum updateSettingEnum;
  final VoidCallback onTapSave;

  const UpdateUserProfile(
      {Key key, @required this.updateSettingEnum, this.onTapSave})
      : super(key: key);

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  UserSettingCubit userSettingCubit;

  @override
  void initState() {
    super.initState();
    userSettingCubit = BlocProvider.of<UserSettingCubit>(context);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   context.showSnackBar(message: userSettingCubit.userNameValidator.text);
    // });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //  context.showSnackBar(message:widget.settingEntity.userName);
    // });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          userSettingCubit.resetAllData();
          ExtendedNavigator.root.pop();
          return Future.value(true);
        },
        child: BlocBuilder<UserSettingCubit, CommonUIState>(
            bloc: userSettingCubit,
            builder: (context, state) => state.maybeWhen(
                orElse: () => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: [
                          ListTile(
                            leading: const BackButton(),
                            title: _getTitle(widget.updateSettingEnum)
                                .toSubTitle1(fontWeight: FontWeight.w600)
                                .toHorizontalPadding(8),
                            tileColor: AppColors.sfBgColor,
                          ),
                          getHomeWidget(widget.updateSettingEnum).toPadding(16),
                          10.toSizedBox,
                          CustomButton(
                            text: _getButtonText(
                              widget.updateSettingEnum,
                            ),
                            onTap: () {
                              widget.onTapSave.call();
                            },
                            color: widget.updateSettingEnum ==
                                    UpdateSettingEnum.DELETE_ACCOUNT
                                ? Colors.red
                                : AppColors.colorPrimary,
                          ).toPadding(16)
                        ].toColumn(
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                    ),
                loading: () => const LoadingBar())),
      ),
    );
  }

  Widget getHomeWidget(UpdateSettingEnum updateSettingEnum) {
    switch (updateSettingEnum) {
      case UpdateSettingEnum.USERNAME:
        return _updateUsername();
        break;
      case UpdateSettingEnum.EMAIL:
        return _updateEmail();
        break;
      case UpdateSettingEnum.WEBSITE:
        return _updateWebsite();
        break;
      case UpdateSettingEnum.ABOUT_YOU:
        return _updateAbout();
        break;
      case UpdateSettingEnum.GENDER:
        return _updateGender();
        break;
      case UpdateSettingEnum.COUNTRY:
        return _updateCountry();
        break;
      case UpdateSettingEnum.PASSWORD:
        return _updatePassword();
        break;
      case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
        return _verifyMyAccount();
        break;
      case UpdateSettingEnum.DELETE_ACCOUNT:
        return _deleteAccount();
      case UpdateSettingEnum.CHANGE_LANGUAGE:
        return _changeLanguage();
        break;
      default:
        return const SizedBox();
    }
  }

  String _getTitle(UpdateSettingEnum updateSettingEnum) {
    String title = "";
    switch (updateSettingEnum) {
      case UpdateSettingEnum.USERNAME:
        title = "Username";
        break;
      case UpdateSettingEnum.EMAIL:
        title = "User e-mail";
        break;
      case UpdateSettingEnum.WEBSITE:
        title = "User Site URL";
        break;
      case UpdateSettingEnum.ABOUT_YOU:
        title = "About you";
        break;
      case UpdateSettingEnum.GENDER:
        title = "User gender";
        break;
      case UpdateSettingEnum.COUNTRY:
        title = "Change country";
        break;
      case UpdateSettingEnum.PASSWORD:
        title = "Profile password";
        break;
      case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
        title = "Verify my account";
        break;
      case UpdateSettingEnum.DELETE_ACCOUNT:
        title = "Delete account";
        break;
      case UpdateSettingEnum.CHANGE_LANGUAGE:
        title = "Display Language";
        break;
    }
    return title;
  }

  Widget _updateUsername() {
    return Column(
      children: [
        11.toSizedBox,
        Strings.firstName
            .toTextField()
            .toStreamBuilder(validators: userSettingCubit.firstNameValidator),
        11.toSizedBox,
        Strings.lastName
            .toTextField()
            .toStreamBuilder(validators: userSettingCubit.lastNameValidator),
        10.toSizedBox,
        Strings.userName
            .toTextField()
            .toStreamBuilder(validators: userSettingCubit.userNameValidator),
      ],
    );
  }

  Widget _updateEmail() {
    return [
      11.toSizedBox,
      Strings.emailAddress
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.emailValidator),
      11.toSizedBox,
      "Please note that after changing the email address, the email address that you use during authorization will be replaced by a new one"
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _updateWebsite() {
    return [
      11.toSizedBox,
      Strings.userSiteUrl
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.websiteValidators),
      11.toSizedBox,
      "Please note that this URL will appear on your profile page. If you want to hide it, leave this field blank."
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _updateAbout() {
    return [
      11.toSizedBox,
      Strings.aboutYou
          .toTextField(maxLength: 140)
          .toStreamBuilder(validators: userSettingCubit.aboutYouValidators),
      11.toSizedBox,
      "Please enter a brief description of yourself with a maximum of 140 characters"
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _updateGender() {
    return StreamBuilder<SettingEntity>(
        stream: userSettingCubit.settingEntity,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? const SizedBox()
              : [
                  11.toSizedBox,
                  SmartSelect<String>.single(
                    choiceStyle: S2ChoiceStyle(
                        titleStyle: context.subTitle2
                            .copyWith(fontWeight: FontWeight.w600)),
                    modalConfig: S2ModalConfig(
                        title: "Gender",
                        headerStyle: S2ModalHeaderStyle(
                            textStyle: context.subTitle1
                                .copyWith(fontWeight: FontWeight.w600))),
                    modalType: S2ModalType.bottomSheet,
                    value: snapshot.data.gender.split('')[0],
                    onChange: (s) {
                      userSettingCubit
                        ..changeSettingEntity(snapshot.data.copyWith(
                            updatedGender: s.value == "M" ? "Male" : "Female"))
                        ..gender = s.value;
                    },
                    tileBuilder: (c, s) => ListTile(
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                      ),
                      onTap: () {
                        s.showModal();
                      },
                      title: "Gender".toSubTitle2(fontWeight: FontWeight.w600),
                      subtitle: snapshot.data.gender
                          .toCaption(fontWeight: FontWeight.w600),
                    ),
                    choiceItems: ["Male", "Female"]
                        .toList()
                        .map((e) => S2Choice(
                              value: e.split('')[0],
                              title: e,
                            ))
                        .toList(),
                  ),
                  11.toSizedBox,
                  "Please choose your gender, this is necessary for a more complete identification of your profile. (Default user gender is Male)"
                      .toCaption(
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorPrimary,
                          maxLines: 5)
                      .toFlexible()
                ].toColumn();
        });
  }

  Widget _updatePassword() {
    return [
      11.toSizedBox,
      Strings.currentPassword
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.oldPasswordValidator),
      11.toSizedBox,
      Strings.newPassword
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.newPasswordValidator),
      11.toSizedBox,
      Strings.confirmNewPassword.toTextField().toStreamBuilder(
          validators: userSettingCubit.confirmPasswordValidator),
      11.toSizedBox,
      "Before changing your current password, please follow these tips: Indicate the minimum length (8 characters). Use uppercase and lowercase letters. Use numbers and special characters (&%\$)"
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _verifyMyAccount() {
    return [
      11.toSizedBox,
      Strings.fullName.toTextField().toStreamBuilder(
          validators: userSettingCubit.verifyFullNameValidator),
      11.toSizedBox,
      Strings.messageToReceiver
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.verifyMessageValidator),
      15.toSizedBox,
      "Video Message".toSubTitle2(fontWeight: FontWeight.w600),
      5.toSizedBox,
      "Select a video appeal to the reviewer"
          .toSubTitle2(align: TextAlign.center)
          .toTextStreamBuilder(
              userSettingCubit.videoPath.map((event) => event.split('/').last))
          .toPadding(18)
          .toContainer(color: AppColors.sfBgColor, alignment: Alignment.center)
          .onTapWidget(() async {
        await openMediaPicker(context, (media) {
          if (media != null && media.isNotEmpty)
            userSettingCubit.changeVideoPath(media);
        }, mediaType: MediaTypeEnum.VIDEO);
      }),
      15.toSizedBox,
      "Please note that this material will not be published or shared with third parties."
              " We request this information solely to verify the authenticity of your identity in order to further verify your account! To do this, we need you to record a video of no more than 1 minute in length, "
              "holding your Passport / ID in your right hand in a clear vision of your face and the data of your document,"
              " besides giving your full name and also the user nickname that you use on our website"
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 10)
          .toFlexible()
    ].toColumn();
  }

  Widget _deleteAccount() {
    return [
      11.toSizedBox,
      Strings.password
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.deleteAccountValidator),
      11.toSizedBox,
      "Please note that after deleting your account, all your publications, subscriptions,"
              " all your data and all your actions will also be deleted, and this action will not be canceled"
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _updateCountry() {
    return StreamBuilder<SettingEntity>(
        stream: userSettingCubit.settingEntity,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? const SizedBox()
              : StreamBuilder<List<String>>(
                  stream: userSettingCubit.countries,
                  initialData: [],
                  builder: (context, countrySnapshot) {
                    return [
                      11.toSizedBox,
                      SmartSelect<String>.single(
                        modalFilter: true,
                        modalFilterBuilder: (ctx, cont) => TextField(
                          decoration: InputDecoration(
                              hintStyle: context.subTitle1
                                  .copyWith(fontWeight: FontWeight.w600),
                              hintText: "Search Country",
                              border: InputBorder.none),
                          onChanged: (s) {
                            cont.apply(s);
                          },
                        ),
                        choiceStyle: S2ChoiceStyle(
                            titleStyle: context.subTitle2
                                .copyWith(fontWeight: FontWeight.w600)),
                        modalConfig: S2ModalConfig(
                            title: "Country",
                            headerStyle: S2ModalHeaderStyle(
                                textStyle: context.subTitle1
                                    .copyWith(fontWeight: FontWeight.w600))),
                        modalType: S2ModalType.fullPage,
                        value: snapshot.data.country,
                        onChange: (s) {
                          userSettingCubit
                            ..changeSettingEntity(
                                snapshot.data.copyWith(country: s.value));
                          //   ..gender = s.value;
                        },
                        tileBuilder: (c, s) => ListTile(
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 14,
                          ),
                          onTap: () {
                            s.showModal();
                          },
                          title: "Country"
                              .toSubTitle2(fontWeight: FontWeight.w600),
                          subtitle: snapshot.data.country
                              .toCaption(fontWeight: FontWeight.w600),
                        ),
                        choiceItems: countrySnapshot.data
                            .toList()
                            .map((e) => S2Choice(
                                  value: e,
                                  title: e,
                                ))
                            .toList(),
                      ),
                      11.toSizedBox,
                      ListTile(
                        title:
                            "Choose the country in which you live. This information will be publicly displayed on your profile."
                                .toCaption(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.colorPrimary,
                                    maxLines: 5),
                      ).toFlexible()
                    ].toColumn();
                  });
        });
  }

  String _getButtonText(UpdateSettingEnum updateSettingEnum) {
    String title = "";
    switch (updateSettingEnum) {
      case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
        title = "Submit Request";
        break;
      case UpdateSettingEnum.DELETE_ACCOUNT:
        title = "Delete Account";
        break;
      default:
        title = "Save Changes";
        break;
    }
    return title;
  }

  Widget _changeLanguage() {
    return StreamBuilder<SettingEntity>(
        stream: userSettingCubit.settingEntity,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? const SizedBox()
              : StreamBuilder<List<String>>(
                  stream: userSettingCubit.languages,
                  initialData: [],
                  builder: (context, countrySnapshot) => [
                        11.toSizedBox,
                        SmartSelect<String>.single(
                          modalFilter: true,
                          modalFilterBuilder: (ctx, cont) => TextField(
                            decoration: InputDecoration(
                                hintStyle: context.subTitle1
                                    .copyWith(fontWeight: FontWeight.w600),
                                hintText: "Search Language",
                                border: InputBorder.none),
                            onChanged: (s) {
                              cont.apply(s);
                            },
                          ),
                          choiceStyle: S2ChoiceStyle(
                              titleStyle: context.subTitle2
                                  .copyWith(fontWeight: FontWeight.w600)),
                          modalConfig: S2ModalConfig(
                              title: "Language",
                              headerStyle: S2ModalHeaderStyle(
                                  textStyle: context.subTitle1
                                      .copyWith(fontWeight: FontWeight.w600))),
                          modalType: S2ModalType.fullPage,
                          value: snapshot.data.displayLanguage,
                          onChange: (s) => userSettingCubit
                            ..changeSettingEntity(
                                snapshot.data.copyWith(displayLang: s.value))
                            ..changeSelectedLang(s.value),
                          tileBuilder: (c, s) => ListTile(
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 14,
                            ),
                            onTap: () => s.showModal(),
                            title: "Select display language"
                                .toSubTitle2(fontWeight: FontWeight.w600),
                            subtitle:
                                allLanguagesMap[snapshot.data.displayLanguage]
                                    .toCaption(fontWeight: FontWeight.w600),
                          ),
                          choiceItems: countrySnapshot.data
                              .toList()
                              .map((e) => S2Choice(
                                    value: e,
                                    title: allLanguagesMap[e],
                                  ))
                              .toList(),
                        ),
                        11.toSizedBox,
                        ListTile(
                          title:
                              "Choose your preferred language for your account interface. This does not affect the language of the content that you see in your stream."
                                  .toCaption(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.colorPrimary,
                                      maxLines: 5),
                        ).toFlexible()
                      ].toColumn());
        });
  }

  @override
  void dispose() {
    userSettingCubit.resetAllData();
    userSettingCubit.newPasswordValidator..textController.clear();
    userSettingCubit.oldPasswordValidator..textController.clear();
    userSettingCubit.confirmPasswordValidator..textController.clear();
    super.dispose();
  }
}

enum UpdateSettingEnum {
  USERNAME,
  EMAIL,
  WEBSITE,
  ABOUT_YOU,
  GENDER,
  COUNTRY,
  PASSWORD,
  VERIFY_MY_ACCOUNT,
  CHANGE_LANGUAGE,
  DELETE_ACCOUNT,
}
