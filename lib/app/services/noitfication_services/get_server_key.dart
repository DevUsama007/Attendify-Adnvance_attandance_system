import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class Getserverkeyfromjson {
  Future<Map<String, dynamic>> loadJson(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  Future<String> getServerKey() async {
    // Load the JSON file
    final jsonData = await loadJson('assets/json/service-account.json');

    // Use the correct scope for FCM

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Create client from JSON data
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(jsonData),
      scopes,
    );

    return client.credentials.accessToken.data;
  }
}
