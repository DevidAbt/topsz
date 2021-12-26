import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/SearchResult.dart';

const API_BASE_URL = "http://topszotar.hu/alkalmazasok/API/android";

Future<List<String>> getAutocomplete(
    String lang, String dict, String text) async {
  String url = "$API_BASE_URL/$lang/autocomplete.php?d=$dict&q=$text";
  final response = await http.get(Uri.parse(url));

  List<String> suggestions = [];
  for (var object in jsonDecode(response.body)) {
    suggestions.add(object['value']);
  }

  return suggestions;
}

Future<SearchResult?> getResults(String lang, String dict, String text) async {
  String url = "$API_BASE_URL/$lang/dict.php?d=$dict&q=$text";
  final response = await http.get(Uri.parse(url));

  SearchResult? result;
  if (response.body != "") {
    var json = jsonDecode(response.body);
    print(json);
    result = SearchResult.fromJson(json);
  }

  return result;
}
