import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/static_data/all_countries.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/profile/domain/entity/setting_entity.dart';
import 'package:colibri/features/profile/presentation/bloc/settings/user_setting_cubit.dart';
import 'package:colibri/features/profile/presentation/pages/settings/update_user_settings.dart';
import 'package:colibri/features/profile/presentation/pagination/privacy_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';

class SettingsScreen extends StatefulWidget {
  final bool fromProfile;

  const SettingsScreen({Key key, this.fromProfile = false}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettingCubit userSettingCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userSettingCubit = getIt<UserSettingCubit>()..getUserSettings();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (VideoCompress.compressProgress$.notSubscribed) {
        listenCompressions();
      } else {
        // dispose already subscribed stream
        VideoCompress.dispose();
        listenCompressions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: "Profile Settings".toSubTitle1(
            color: AppColors.textColor, fontWeight: FontWeight.bold),
        centerTitle: true,
        leading: widget.fromProfile
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  ExtendedNavigator.root.pop();
                  // BlocProvider.of<FeedCubit>(context).changeCurrentPage(
                  //     ScreenType.profile(
                  //         ProfileScreenArguments(otherUserId: null)));
                },
              )
            : null,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await userSettingCubit.getUserSettings();
          return Future.value();
        },
        child: BlocListener<UserSettingCubit, CommonUIState>(
          cubit: userSettingCubit,
          listener: (c, state) {
            state.maybeWhen(
                orElse: () {},
                success: (s) {
                  if (s == "Deleted") {
                    ExtendedNavigator.root.pushAndRemoveUntil(
                        Routes.loginScreen, (route) => false);
                  }
                  context.showSnackBar(message: s);
                },
                error: (e) => context.showSnackBar(message: e, isError: true));
          },
          listenWhen: (c, s) => s.maybeWhen(
              orElse: () => false,
              success: (s) => s is String,
              error: (e) => true),
          child: BlocBuilder<UserSettingCubit, CommonUIState>(
            cubit: userSettingCubit,
            builder: (_, state) {
              return state.when(
                  initial: () => LoadingBar(),
                  success: (settingEntity) => StreamBuilder<SettingEntity>(
                      stream: userSettingCubit.settingEntity,
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? const SizedBox()
                            : buildHomeUI(snapshot.data);
                      }),
                  loading: () => LoadingBar(),
                  error: (e) => StreamBuilder<SettingEntity>(
                      stream: userSettingCubit.settingEntity,
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? const SizedBox()
                            : buildHomeUI(snapshot.data);
                      }));
            },
          ),
        ),
      ),
    );
  }

  Widget buildHomeUI(SettingEntity settingEntity) {
    return [
      header("General"),
      profileItem(
          "Username", "${settingEntity.name} - ${settingEntity.userName}",
          onTap: () {
        // context.showSnackBar(message: settingEntity.userName);
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.USERNAME);
      }),
      profileItem("Email", settingEntity.email, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.EMAIL);
      }),
      profileItem("Website", settingEntity.website, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.WEBSITE);
      }),
      profileItem("About", settingEntity.about, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.ABOUT_YOU);
      }),
      profileItem("Your Gender", settingEntity.gender, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.GENDER);
      }),
      header("User Password").toVisibility(!settingEntity.socialLogin),

      profileItem("My password", "* * * * * *", onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.PASSWORD);
      }).toVisibility(!settingEntity.socialLogin),
      header("Language and Country"),
      // profileItem("Display Language", settingEntity.displayLanguage),
      profileItem(
          "Display Language", allLanguagesMap[settingEntity.displayLanguage],
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.CHANGE_LANGUAGE);
      }),
      profileItem("Country", settingEntity.country, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.COUNTRY);
      }),
      header("Account Verification").toVisibility(!settingEntity.isVerified),
      profileItem("Verify my account", "Click to submit a verification request",
          onTap: () {
        openUpdateBottomSheet(
            settingEntity, UpdateSettingEnum.VERIFY_MY_ACCOUNT);
      }).toVisibility(!settingEntity.isVerified),
      header("Account Privacy Settings"),
      profileItem("Account Privacy", "Click to set your account privacy ",
          onTap: () {
        showModalBottomSheet(
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: const Radius.circular(10))),
            context: context,
            builder: (c) {
              return BlocProvider.value(
                  value: userSettingCubit,
                  child: PrivacyScreen(
                    privacyModels: PrivacyWidgetModel.getPrivacyModels(
                        accountPrivacyEntity:
                            settingEntity.accountPrivacyEntity),
                  ));
            });
      }),
      header("Company"),
      profileItem("Terms", "Click for our terms of usage", onTap: () {
        // await launch(link.url);
        ExtendedNavigator.root.push(Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.termsUrl, name: Strings.termsOfUse));
      }),
      profileItem("Privacy", "Click for our privacy details", onTap: () {
        ExtendedNavigator.root.push(Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.privacyUrl, name: Strings.privacy));
      }),
      profileItem("Cookies", "Click for our cookies", onTap: () {
        ExtendedNavigator.root.push(Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.cookiesPolicy, name: Strings.cookie));
      }),
      profileItem("About us", "Read about us", onTap: () {
        ExtendedNavigator.root.push(Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.aboutUs, name: Strings.about));
      }),
      header("Delete Profile"),
      profileItem("Delete", "Click to confirm deletion of profile", onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.DELETE_ACCOUNT);
      }),

      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: "Log Out"
            .toCaption(fontWeight: FontWeight.w600, fontSize: 15)
            .toCenter()
            .onTapWidget(() {
          context.showAlertDialog(widgets: [
            "Yes".toButton().toFlatButton(() async {
              var localDataSource = getIt<LocalDataSource>();
              await localDataSource.clearData();
              // Fix the issue
              ExtendedNavigator.root.pop();

              // await BlocProvider.of<FeedCubit>(context).logout();

              // ExtendedNavigator.root.popUntil((c)=>Routes.loginScreen);
              ExtendedNavigator.root
                  .pushAndRemoveUntil(Routes.loginScreen, (c) => false);
            }),
            "No".toButton().toFlatButton(() {
              ExtendedNavigator.root.pop();
            }),
          ], title: "Are you sure want to Logout?");
        }),
      ),

      [
        "Version 1.0".toCaption(fontWeight: FontWeight.w600),
        // "New York, NY".toCaption(fontWeight: FontWeight.w600)
      ]
          .toColumn(
            mainAxisAlignment: MainAxisAlignment.center,
          )
          .toContainer(alignment: Alignment.bottomCenter, height: 100),
      10.toSizedBox,
    ].toColumn().makeScrollable().toSafeArea;
  }

  void openUpdateBottomSheet(
      SettingEntity settingEntity, UpdateSettingEnum updateSettingEnum) {
    showModalBottomSheet(
        // enableDrag: true,
        isScrollControlled: true,
        shape: 10.0.toRoundRectTop,
        // clipBehavior: Clip.hardEdge,
        context: context,
        builder: (c) => BlocProvider.value(
              value: userSettingCubit,
              child: UpdateUserProfile(
                updateSettingEnum: updateSettingEnum,
                onTapSave: () {
                  switch (updateSettingEnum) {
                    case UpdateSettingEnum.USERNAME:
                      if (userSettingCubit.firstNameValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.firstNameValidator
                            .changeData(settingEntity.firstName);
                        userSettingCubit.firstNameValidator.textController
                            .text = settingEntity.firstName;
                        context.showSnackBar(
                            message: "First name must not be empty",
                            isError: true);
                      } else if (userSettingCubit
                          .lastNameValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.lastNameValidator.textController.text =
                            settingEntity.lastName;
                        userSettingCubit.lastNameValidator
                            .changeData(settingEntity.lastName);
                        context.showSnackBar(
                            message: "Last name m"
                                "ust not be empty",
                            isError: true);
                      } else if (userSettingCubit
                          .userNameValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.userNameValidator
                            .changeData(settingEntity.userName);
                        userSettingCubit.userNameValidator.textController.text =
                            settingEntity.userName;
                        context.showSnackBar(
                            message: "Username must not be empty",
                            isError: true);
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.EMAIL:
                      if (userSettingCubit.emailValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.emailValidator
                            .changeData(settingEntity.email);
                        userSettingCubit.emailValidator.textController.text =
                            settingEntity.email;
                        context.showSnackBar(
                            message: "Email must not be empty", isError: true);
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.WEBSITE:
                      if (userSettingCubit.websiteValidators.text.isValidUrl) {
                        userSettingCubit.websiteValidators
                            .changeData(settingEntity.website);
                        userSettingCubit.websiteValidators.textController.text =
                            settingEntity.website;
                        ExtendedNavigator.root.pop();
                        context.showSnackBar(
                            message: "Website address is not valid",
                            isError: true);
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.ABOUT_YOU:
                      userSettingCubit.updateUserSettings(updateSettingEnum);
                      ExtendedNavigator.root.pop();

                      // if(userSettingCubit.aboutYouValidators.text.isEmpty){
                      //   ExtendedNavigator.root.pop();
                      //   userSettingCubit.aboutYouValidators.textController.text=settingEntity.about;
                      //   userSettingCubit.aboutYouValidators.changeData(settingEntity.about);
                      //   context.showSnackBar(message: "About you must not be empty",isError: true);
                      // }
                      // else {
                      //
                      // }

                      break;
                    case UpdateSettingEnum.GENDER:
                      userSettingCubit.updateUserSettings(updateSettingEnum);
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.COUNTRY:
                      userSettingCubit.updateUserSettings(updateSettingEnum);
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.PASSWORD:
                      if (userSettingCubit.oldPasswordValidator.text.isEmpty) {
                        context.showSnackBar(
                            message: "Old Password you must not be empty",
                            isError: true);
                      } else if (userSettingCubit
                          .newPasswordValidator.text.isEmpty) {
                        context.showSnackBar(
                            message: "New Password you must not be empty",
                            isError: true);
                      } else if (userSettingCubit
                              .newPasswordValidator.text.isEmpty ||
                          userSettingCubit
                              .confirmPasswordValidator.text.isEmpty ||
                          userSettingCubit.newPasswordValidator.text !=
                              userSettingCubit.confirmPasswordValidator.text) {
                        context.showSnackBar(
                            message: "Please make sure password match",
                            isError: true);
                      } else {
                        // userSettingCubit.oldPasswordValidator.addError("dummy");
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        // ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
                      userSettingCubit.verifyUserAccount();
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.DELETE_ACCOUNT:
                      if (userSettingCubit
                          .deleteAccountValidator.text.isValidPass)
                        userSettingCubit.deleteAccount();
                      else
                        context.showSnackBar(
                            message:
                                userSettingCubit.deleteAccountValidator.text);
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.CHANGE_LANGUAGE:
                      userSettingCubit.changeUserLanguage();
                      ExtendedNavigator.root.pop();
                      break;
                  }
                },
              ),
            ));
  }

  void listenCompressions() {
    VideoCompress.compressProgress$.subscribe((progress) {
      if (progress < 99.99)
        EasyLoading.showProgress(
          (progress / 100),
          status: 'Compressing ${progress.toInt()}%',
        );
      else
        EasyLoading.dismiss();
    });
  }
}

Widget header(String name) {
  return name
      .toCaption(fontWeight: FontWeight.bold)
      .toHorizontalPadding(12)
      .toPadding(12)
      .onTapWidget(() {})
      .toContainer(color: AppColors.lightSky.withOpacity(.5))
      .makeBottomBorder;
}

Widget profileItem(String title, String value, {VoidCallback onTap}) {
  return [
    title.toSubTitle2(fontWeight: FontWeight.bold),
    5.toSizedBox,
    value.toSubTitle2()
  ].toColumn().toPadding(12).toContainer().makeBottomBorder.toFlatButton(() {
    onTap?.call();
  });
}

class PrivacyWidgetModel {
  final String value;
  final PrivacyOptionEnum privacyOptionEnum;
  final bool isSelected;
  PrivacyWidgetModel._(this.value, this.privacyOptionEnum,
      {this.isSelected = false});

  static List<PrivacyWidgetModel> getPrivacyModels(
      {AccountPrivacyEntity accountPrivacyEntity}) {
    return [
      PrivacyWidgetModel._("Yes", PrivacyOptionEnum.SEARCH_VISIBILITY,
          isSelected: accountPrivacyEntity.showProfileInSearchEngine ==
              Strings.privacyYes),
      PrivacyWidgetModel._("No", PrivacyOptionEnum.SEARCH_VISIBILITY,
          isSelected: accountPrivacyEntity.showProfileInSearchEngine ==
              Strings.privacyNo),
      PrivacyWidgetModel._("EveryOne", PrivacyOptionEnum.CONTACT_PRIVACY,
          isSelected: accountPrivacyEntity.canDMMe == Strings.privacyEveryOne),
      PrivacyWidgetModel._(
          "The People I Follow", PrivacyOptionEnum.CONTACT_PRIVACY,
          isSelected:
              accountPrivacyEntity.canDMMe == Strings.privacyPeopleIFollow),
      PrivacyWidgetModel._("EveryOne", PrivacyOptionEnum.PROFILE_VISIBILITY,
          isSelected:
              accountPrivacyEntity.canSeeMyPosts == Strings.privacyEveryOne),
      PrivacyWidgetModel._("My Followers", PrivacyOptionEnum.PROFILE_VISIBILITY,
          isSelected:
              accountPrivacyEntity.canSeeMyPosts == Strings.privacyMyFollowers),
    ];
  }

  static String getEnumValue(PrivacyOptionEnum privacyOptionEnum) {
    String text = '';
    switch (privacyOptionEnum) {
      case PrivacyOptionEnum.PROFILE_VISIBILITY:
        text = "Who can see my profile & posts?";
        break;
      case PrivacyOptionEnum.CONTACT_PRIVACY:
        text = "Who can direct message me?";
        break;
      case PrivacyOptionEnum.SEARCH_VISIBILITY:
        text = "Show your profile in search engines?";
        break;
    }
    return text;
  }

  PrivacyWidgetModel copyWith(
      {String value, PrivacyOptionEnum privacyOptionEnum, bool isSelected}) {
    return PrivacyWidgetModel._(
        value ?? this.value, privacyOptionEnum ?? this.privacyOptionEnum,
        isSelected: isSelected ?? this.isSelected);
  }
}

enum PrivacyOptionEnum {
  PROFILE_VISIBILITY,
  CONTACT_PRIVACY,
  SEARCH_VISIBILITY
}
