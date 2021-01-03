import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:connect_people/constants.dart';

class Login {
  int code;
  String message;
  String token;

  Future<void> call(String loginId, String password) async {
    try {
      final response = await http.post(
          HOST_CORE + '/signin',
          body: jsonEncode(
              {
                'loginId': loginId,
                'password': password
              }
          ),
          headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body)['result'];
        code = jsonResult['code'];
        message = jsonResult['message'];
        var jsonData = json.decode(response.body)['data'];
        if (jsonData != null) {
          token = jsonData['token'];
        }
      }

    } catch (e) {
      code = 0;
      message = e;
      throw ('Error login');
    }
  }
}
