import 'dart:convert';

import 'package:attendify/app/services/noitfication_services/get_server_key.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationService(String deviceToken, String title,
      String body, Map<String, dynamic>? data) async {
    String serverKey = await Getserverkeyfromjson().getServerKey();
    print('ServerKey ${serverKey}');
    // print("serverkey: ${serverKey}");
    String url =
        "https://fcm.googleapis.com/v1/projects/attendify-b4ada/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };
    Map<String, dynamic> message = {
      "message": {
        'token': deviceToken.toString(),
        "notification": {"body": body, "title": title.toString()},
        "data": data
      }
    };
    // hit api
    final http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(message));
    if (response.statusCode == 200) {
      print("notification send");
    } else {
      print('Notificaiton not send');
    }
  }
}
