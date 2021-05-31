import 'dart:convert';

import 'package:http/http.dart' as http;

typedef Json = Map<String, dynamic>;

class ContactsApiService {
  static const String mainTag = '## ContactsApiService';
  Future<Json> loadContactsData(Uri url) async {
    final response = await http.get(url);
    if (response.body.contains('error')) {
      throw ('The Error occurred while was loading users data');
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.containsKey("error")) {
      throw extractedData["error"];
    }
    return extractedData;
  }
}
