import 'dart:collection';

import 'package:colibri/features/feed/data/models/feeds_response.dart';

class PostRequestModel{
  final String postText;
  final String gifUrl;
  final String threadId;
  // final OgDataClass1 ogData;
  final String ogData;

  PostRequestModel({this.postText, this.gifUrl, this.threadId, this.ogData});

  HashMap<String,String >toMap(){
    return HashMap.from({
      "post_text":postText,
      "thread_id":threadId,
      "gif_src":gifUrl,
      "og_data":ogData,
    });
  }
}