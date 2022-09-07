import 'dart:convert';

import 'package:did/models/channel_model.dart';
import 'package:did/models/task_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CustomFunctions {
  String formatTimestamp(int timestamp) {
    var format = DateFormat.MMMEd(); // <- use skeleton here
    return format.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  void markDone(ChannelModel channel, TaskModel task) async {
    await FirebaseApi.taskToggle(channel, task);
  }

  void deletetask(ChannelModel channel, TaskModel task) async {
    await FirebaseApi.deleteTask(channel, task);
  }

  Future<bool> sendFCM(
      {required String title,
      required String body,
      required String fcmToken}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": fcmToken,
      "notification": {
        "title": title,
        "body": body,
        "sound": "sound",
        "priority": "high"
      },
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAMcQokPg:APA91bFSKwmlO5L16qjpbkYK2YqECa5L6BRBtNOvV3WWvMy_KxW8Zcp8UArbGBk_oH2DEK2Sw7VpFqyvqd_9Xo9JJZXWZ4Jtc5xrD8lF_cnlhs63JS50n1ups5h3rHFi0XNsHBCyip70' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
