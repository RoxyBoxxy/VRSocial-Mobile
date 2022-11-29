import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:colibri/extensions.dart';
class VerifyRequestModel{
  final String message;
  final String video;
  final String fullName;

  VerifyRequestModel({
   @required this.message,
   @required this.video,
   @required this.fullName
  });

  Future<HashMap<String, dynamic>> get toMap async => HashMap.from({
      "text_message": message,
      "video_message": await video.toMultiPart(),
      "full_name": fullName,
    });
}