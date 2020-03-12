import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  final Map<String, String> headers;

  NetworkHelper({@required this.url, this.headers});

  Future getData() async {
    http.Response response = await http.get(url, headers: headers);
    print('responce codeStatus ${response.statusCode}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}
