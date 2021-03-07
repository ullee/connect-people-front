import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../constants.dart';

class SendSms {
  bool success;
  String message;
  int code;

  Future<void> call(String phone) async {
    try {
      final response = await http.post(
          HOST_CORE + '/send/sms',
          body: jsonEncode(
              {
                'phone': phone
              }
          ),
          headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        success = true;
      }

    } catch (e) {
      success = false;
      throw ('Error save board');
    }
  }

  Future<void> auth(String number) async {
    try {
      final response = await http.post(
          HOST_CORE + '/auth/sms',
          body: jsonEncode(
              {
                'number': number
              }
          ),
          headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body)['result'];
        success = true;
        code = jsonResult['code'];
        message = jsonResult['message'];
      }

    } catch (e) {
      success = false;
      throw ('Error save board');
    }
  }
}
