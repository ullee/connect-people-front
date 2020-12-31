import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../constants.dart';

class Save {
  bool success;
  String message;

  Future<void> call(String brandName, int memberID, String title, String subTitle, String content, List<String> uploadedUrls) async {
    try {
      final response = await http.post(
          HOST_CORE + '/boards',
          body: jsonEncode(
              {
                'brandName': brandName,
                'memberID': memberID,
                'title': title,
                'subTitle': subTitle,
                'content': content,
                'imageUrls': uploadedUrls
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
}
