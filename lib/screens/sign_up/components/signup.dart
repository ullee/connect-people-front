import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:connect_people/constants.dart';

class Signup {
  int code;
  String message;

  Future<void> call(String loginId, String password, String name) async {
    try {
      final response = await http.post(
          HOST_CORE + '/signup',
          body: jsonEncode(
              {
                'loginId': loginId,
                'password': password,
                'name': name,
              }
          ),
          headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body)['result'];
        code = jsonResult['code'];
        message = jsonResult['message'];
      }

    } catch (e) {
      code = 0;
      message = e;
      throw ('Error login');
    }
  }
}
