import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:colibri/core/common/api/response_models/chat_notification_response.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/usecase/save_notification_token_use_case.dart';
import 'package:colibri/features/feed/presentation/bloc/feed_cubit.dart';
import 'package:colibri/features/feed/presentation/pages/feed_screen.dart';
import 'package:colibri/features/messages/domain/entity/chat_entity.dart';
import 'package:colibri/features/messages/presentation/bloc/chat_cubit.dart';
import 'package:colibri/features/notifications/domain/entity/notification_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:colibri/extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PushNotificationHelper {

   // bool isNotificationShow = false;
   // bool isMessageShow = false;

  // static final _connector = createPushConnector();
  static LocalDataSource localDataSource= getIt<LocalDataSource>();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //// it will gives callback to [ChatCubit] so that we can add notification messages
  static ValueChanged<ChatEntity> listenNotificationOnChatScreen;

  // user id of the with whom current user is chatting
  static String currentUserId;
  Random random = new Random();
  static configurePush(BuildContext context) {

    FirebaseMessaging()..configure (
        onBackgroundMessage:Platform.isIOS ? null : _onMyBackground,
        onMessage: _onMessage,
        onLaunch: _onLaunch,
        onResume: _onResume)..requestNotificationPermissions()..getToken().then((value) {
        print("firebase token $value");
        ClipboardManager.copyToClipBoard(value).then((value) {
          // context.showSnackBar(message: "Firebase token copied to clipboard");
        });
        localDataSource.savePushToken(value);
        _savePushNotificationTokenToServer();
    })..onTokenRefresh.listen((event) {
      localDataSource.savePushToken(event);
      _savePushNotificationTokenToServer();
    });



    //
    // _connector.configure(
    //     onLaunch: _onLaunch,
    //     onResume: _onResume,
    //     onMessage: _onMessage,
    //     onBackgroundMessage: _onMyBackground);
    // _connector.requestNotificationPermissions();
    // _connector.token.addListener(() {
    //   print("token is${_connector.token.value}");
    //   localDataSource ??= getIt<LocalDataSource>();
    //   localDataSource.savePushToken(_connector.token.value);
    // });
    _initLocalNotification();
  }
  static _savePushNotificationTokenToServer()async{
    final savePush=getIt<SaveNotificationPushUseCase>();
    savePush.call(unit);
  }
  static unregister() async {
    // await _connector.unregister();
  }

  static Future<void> _onLaunch(Map<String, dynamic> message) async {

    print("on Launch");

    // controller.add(1);

    // if(message['data']['type'] == "chat_message") {
    //   // isMessageShow = true;
    //   // isNotificationShow = true;
    //   AC.prefs.setBool("message", true);
    //   // AC.prefs.setBool("notification", true);
    // } else {
    //   // isNotificationShow = true;
    //   AC.prefs.setBool("notification", true);
    // }


    _navigateToScreen(jsonEncode(message));


    if(message['data']['type'] == "chat_message") {
      // isMessageShow = true;
      // isNotificationShow = true;
      AC.prefs.setBool("message", false);
      AC.prefs.reload();
      // AC.prefs.setBool("notification", true);
    } else {
      // isNotificationShow = true;
      AC.prefs.setBool("notification", false);
      AC.prefs.reload();
    }

    // controller.add(1);

    // buildContext.showSnackBar(message: "onLaunch");
    // _showLocationNotification(message);
  }

  static Future<void> _onResume(Map<String, dynamic> message) async {



    print("on Resume ${message}");
    if(Platform.isIOS) {
      var chatObject=message["gcm.notification.chat_message"];
      if (listenNotificationOnChatScreen != null && chatObject!=null) {
        if (listenNotificationOnChatScreen != null)
          listenNotificationOnChatScreen.call(ChatEntity.fromNotification (
              ChatMessage.fromJson(json.decode(chatObject)))
          );
        return;
      };
      _navigateToScreen(jsonEncode(message));
    }
    else _showLocationNotification(message);

    if(message['data']['type'] == "chat_message") {
      // isMessageShow = true;
      // isNotificationShow = true;
      AC.prefs.setBool("message", false);
      AC.prefs.reload();
      // AC.prefs.setBool("notification", true);
    } else {
      // isNotificationShow = true;
      AC.prefs.setBool("notification", false);
      AC.prefs.reload();
    }

    // controller.add(1);
  }


  static Future<void> _onMessage(Map<String, dynamic> message) async {

    print("on Message ${message}");

    if(message['data']['type'] == "chat_message") {
      // isMessageShow = true;
      // isNotificationShow = true;
      AC.prefs.setBool("message", true);
      // AC.prefs.setBool("notification", true);
    } else {
      // isNotificationShow = true;
      AC.prefs.setBool("notification", true);
    }

    _showLocationNotification(message);

    controller.add(1);

  }

  static Future<void> _onMyBackground(Map<String, dynamic> message) async {

    // print("on Bg ${message}");
    // if(message['data']['type'] == "chat_message") {
    //   // isMessageShow = true;
    //   // isNotificationShow = true;
    //   AC.prefs.setBool("message", true);
    //   // AC.prefs.setBool("notification", true);
    // } else {
    //   // isNotificationShow = true;
    //   AC.prefs.setBool("notification", true);
    // }



    print("on background notification");


    // controller.add(1);
    _showLocationNotification(message);

    storeMsg();

    // if(message['data']['type'] == "chat_message") {
    //   // isMessageShow = true;
    //   // isNotificationShow = true;
    //   AC.prefs.setBool("message", true);
    //
    //   // AC.prefs.reload();
    //
    //   // AC.prefs.setBool("notification", true);
    // } else {
    //   // isNotificationShow = true;
    //   AC.prefs.setBool("notification", true);
    //
    //   // AC.prefs.reload();
    //
    // }

  }

  static void _initLocalNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon_n');
    final IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _navigateToScreen);
  }

  // Future onDidReceiveLocalNotification(
  //     int id, String title, String body, String payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SecondScreen(payload),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  static Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    _showLocationNotification(jsonDecode(payload));
  }

  static Future _navigateToScreen(String payload) async {
    var jsonMap = jsonDecode(payload);
    final postId=Platform.isAndroid?jsonMap['data']['post_id']:jsonMap['gcm.notification.post_id'];
    final userId=Platform.isAndroid?jsonMap['data']['user_id']:jsonMap['gcm.notification.user_id'];
    final chatMessage=Platform.isAndroid?jsonMap['data']['chat_message']:jsonMap["gcm.notification.chat_message"];
   // var cm= ChatEntity.fromNotification(
   //      ChatMessage.fromJson(json.decode(jsonMap['data']['chat_message'])));
   //  currentUserId=cm.senderUserId;
    // print("on select $jsonMap");
    if (chatMessage != null) {
      var chatEntity = ChatEntity.fromNotification(
          ChatMessage.fromJson(json.decode(chatMessage)));
      // if sender id in notification payload is same as current user who is currently chatting
      // then we will add push data to chat screen directly and notification is not going to triggered
      // if (chatEntity.senderUserId == currentUserId) {
        ExtendedNavigator.root.popUntil((route) {
          if (route.settings.name != Routes.chatScreen) {
            ExtendedNavigator.root.push(Routes.chatScreen,
                arguments: ChatScreenArguments(
                    otherPersonProfileUrl:chatEntity.profileUrl,
                    otherPersonUserId: chatEntity.senderUserId));
          }
          return true;
        });

    }
    // if notification type of post

    else if (postId != null) {
      ExtendedNavigator.root.popUntil((route) {
        if (route.settings.name != Routes.viewPostScreen) {
          ExtendedNavigator.root.push(Routes.viewPostScreen,
              arguments: ViewPostScreenArguments(
                  threadID: int.tryParse(postId),
                  postEntity: null));
        }
        return true;
      });
    }
    // if notification has user data
    else if (userId != null) {
      ExtendedNavigator.root.push(Routes.profileScreen,
          arguments:
              ProfileScreenArguments(otherUserId: userId));
    }
  }

  static void _showLocationNotification(Map<String, dynamic> map) async {
    // will send notification if user is not on chat screen
    // other wise we will show notification as usual
    var chatObject=Platform.isAndroid?map['data']['chat_message']:map["gcm.notification.chat_message"];
    if (listenNotificationOnChatScreen != null && chatObject!=null) {
      if (listenNotificationOnChatScreen != null)
        listenNotificationOnChatScreen.call(ChatEntity.fromNotification(
            ChatMessage.fromJson(json.decode(chatObject)))
        );
      // controller.add(1);

      return;
    };

    var title = Platform.isAndroid
        ? map['data']['title']
        : map["aps"]["alert"]["title"];
    // var title="Titile";
    final body =
        Platform.isAndroid ? map['data']['type'] : map["gcm.notification.type"];
    // var body="subscribe";
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('0', 'colibri', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true
        );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const IOSNotificationDetails());
    await _flutterLocalNotificationsPlugin.show(
        Random().nextInt(100),
        title,
        NotificationEntity.getTitleFromNotificationType(body),
        platformChannelSpecifics,
        payload: jsonEncode(map));

    // controller.add(1);

  }


  static storeMsg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("message", true);
  }


}
