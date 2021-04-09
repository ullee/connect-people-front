import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:connect_people/constants.dart';

class Signup {
  int code;
  String message;

  Future<void> call(String loginId, String password, String name, String phone) async {
    try {
      var uri = HOST_LAMBDA + '/v1/member/signup';
      final response = await http.post(
          Uri.parse(uri),
          body: jsonEncode(
              {
                'login_id': loginId,
                'password': password,
                'name': name,
                'phone': phone,
              }
          ),
          headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body)['result'];
        code = jsonResult['code'];
        message = jsonResult['message'];
      } else {
        var error = json.decode(response.body)['error'];
        code = response.statusCode;
        message = error.toString();
        print(error);
      }

    } catch (e) {
      code = 0;
      message = e;
      throw ('Error login');
    }
  }
}
