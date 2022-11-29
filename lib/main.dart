import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/push_notification/push_notification_helper.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:rxdart/rxdart.dart';
import 'core/di/injection.dart';
import 'core/routes/routes.gr.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/colors.dart';
import 'extensions.dart';

final appThemeConstroller = BehaviorSubject<TextTheme>.seeded(appTextTheme);

Function(TextTheme) get changeAppTheme => appThemeConstroller.sink.add;

Stream<TextTheme> get appTheme => appThemeConstroller.stream;
LocalDataSource? localDataSource;
var isUserLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AC.getInstance();
  // Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 (iPhone6 750*1334)
  await NativeDeviceOrientationCommunicator().orientation(useSensor: false);
  await configureDependencies();
  // ScreenUtil.init(BoxConstraints(minHeight: ScreenUtil.defaultSize.height,minWidth: ScreenUtil.defaultSize.width));
  // await Firebase.initializeApp();
  localDataSource = getIt<LocalDataSource>();
  isUserLoggedIn = await localDataSource!.isUserLoggedIn();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) async {
    await Future.delayed(const Duration(milliseconds: 500));
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    PushNotificationHelper.configurePush(context);

    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 2000)
        ..indicatorType = EasyLoadingIndicatorType.ring
        ..loadingStyle = EasyLoadingStyle.custom
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..maskType = EasyLoadingMaskType.custom
        ..maskColor = AppColors.colorPrimary.withOpacity(.2)
        ..indicatorColor = AppColors.colorPrimary
        ..progressColor = AppColors.colorPrimary
        ..textColor = AppColors.colorPrimary
        ..backgroundColor = Colors.transparent
        ..userInteractions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth != 0) {
          print(constraints);
          var size = Size(constraints.maxWidth, constraints.maxHeight);
          ScreenUtil.init(context, designSize: size, minTextAdapt: true);
          // ScreenUtil.init(
          //   constraints,
          //   designSize: const Size(360, 690),
          //   allowFontScaling: false,
          // );
        }

        return MaterialApp(
          title: 'Colibri',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              textTheme: appTextTheme,
              primaryColor: AppColors.colorPrimary,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              tabBarTheme: TabBarTheme(
                  unselectedLabelStyle:
                      context.subTitle2.copyWith(fontWeight: FontWeight.bold),
                  labelStyle:
                      context.subTitle2.copyWith(fontWeight: FontWeight.bold),
                  labelColor: AppColors.colorPrimary,
                  unselectedLabelColor: Colors.grey)),
          onGenerateRoute: MyRouter(),
          builder: ExtendedNavigator.builder(
              // builder: ExtendedNavigator.builder<MyRouter>(
              // router: Router(),
              router: MyRouter(),
              initialRoute:
                  isUserLoggedIn ? Routes.feedScreen : Routes.welcomeScreen,
              builder: (context, child) {
                return FlutterEasyLoading(child: child);
              }) as Widget Function(BuildContext, Widget?)?,
        );
      },
    );
  }
}
