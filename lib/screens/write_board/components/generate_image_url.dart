import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../constants.dart';

class GenerateImageUrl {
  bool success;
  String message;

  bool isGenerated;

  String uploadUrl;
  String downloadUrl;

  Future<void> call(String fileType) async {
    try {
      Map body = {"fileType": fileType};
      print(fileType);

      var response = await http.post(
        HOST_CORE + '/boards/images',
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      var result = jsonDecode(response.body);

      print(result);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result["uploadUrl"];
          downloadUrl = result["downloadUrl"];
        }
      }
    } catch (e) {
      throw ('Error getting url');
    }
  }
}
