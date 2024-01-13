import 'dart:convert';

import 'package:http/http.dart';

const String baseUrl = 'api.dictionaryapi.dev';
const String url = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<List> getDefinition({required String term}) async {
  try {
    Uri ui;
    ui = Uri.https(baseUrl, '/api/v2/entries/en/$term');
    // final u = Uri.https(url + term);
    final data = await get(ui);
    final response = jsonDecode(data.body);
    if (response.runtimeType == List) {
      return response;
    } else {
      return [
        {'error': "No such word "}
      ];
    }
  } catch (e) {
    return [
      {'error': e}
    ];
  }
}
