import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/app_icons.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/widgets/loading_bar.dart';
import 'package:colibri/extensions.dart';
import 'package:colibri/features/authentication/presentation/bloc/reset_password_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetPasswordCubit resetPasswordCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resetPasswordCubit = getIt<ResetPasswordCubit>();
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return BlocProvider<ResetPasswordCubit>(
      create: (c) => resetPasswordCubit,
      child: BlocListener<ResetPasswordCubit, CommonUIState>(
          listener: (_, state) {
            state.maybeWhen(
                orElse: () {},
                success: (message) {
                  ExtendedNavigator.root.pop();
                  context.showSnackBar(message: message);
                },
                error: (e) {
                  context.showOkAlertDialog(desc: e, title: "Alert");
                });
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocBuilder<ResetPasswordCubit, CommonUIState>(
              builder: (c, state) => state.when(
                  initial: buildHome,
                  success: (s) => buildHome(),
                  loading: () => LoadingBar(),
                  error: (e) => buildHome()),
            ),
          )),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
            actions: [
              KeyboardActionsItem(
                displayDoneButton: true,
                focusNode: resetPasswordCubit.emailValidator.focusNode,
              ),
            ],
          ),
          child: SizedBox(
            height: context.getScreenHeight,
            child: [
              [
                AppIcons.appLogo
                    .toContainer(alignment: Alignment.center)
                    .toExpanded(),
                "Please check your email after submission"
                    .toCaption(fontWeight: FontWeight.w600)
                    .toContainer(alignment: Alignment.center),
              ].toColumn().toExpanded(),
              [
                20.toSizedBox,
                "Enter email address".toTextField().toStreamBuilder(
                    validators: resetPasswordCubit.emailValidator),
                20.toSizedBox,
                "Reset".toButton().toStreamBuilderButton(
                    resetPasswordCubit.enableButton,
                    () => resetPasswordCubit.resetPassword()),
              ].toColumn().toExpanded(),
              [
                "Have an account already?".toCaption(
                    fontWeight: FontWeight.w600, color: Colors.black54),
                "SIGN IN"
                    .toButton(color: AppColors.colorPrimary)
                    .toUnderLine()
                    .toTextButton(() =>
                        ExtendedNavigator.root.replace(Routes.loginScreen)),
              ]
                  .toColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center)
                  .toExpanded()
            ]
                .toColumn(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center)
                .toHorizontalPadding(24),
          ),
        ),
      ),
    );
  }
}
