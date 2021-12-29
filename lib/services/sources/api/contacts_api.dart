import 'dart:convert';

import 'package:contacts_manager/repositories/abstr_sources/contacts_api_abstr.dart';
import 'package:http/http.dart' as http;

typedef Json = Map<String, dynamic>;

class ContactsApiServiceImpl implements ContactsApiService {
  static const String mainTag = '## ContactsApiService';
  Future<Json> loadContactsData(Uri url) async {
    final response = await http.get(url);
    if (response.body.contains('error')) {
      throw ('The Error occurred while was loading users data');
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.containsKey("error")) {
      throw extractedData["error"] as String;
    }
    return extractedData;
  }
}
