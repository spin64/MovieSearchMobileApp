import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> fetchData(movieName, pageNum) async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  final baseUrl = jsonMap['BASE_URL'];
  final apiKey = jsonMap['API_KEY'];
  final url = '$baseUrl?apikey=$apiKey&s=$movieName&page=$pageNum&type=movie';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['Search'] != null) {
      return {
        'items': data['Search'],
        'count': data['totalResults']
      };
    } else {
      throw Exception('No "Search" key found in response');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

Future<dynamic> fetchDataById(id) async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  print('searching');

  final baseUrl = jsonMap['BASE_URL'];
  final apiKey = jsonMap['API_KEY'];
  final url = '$baseUrl?apikey=$apiKey&i=$id';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      return data;
    } else {
      throw Exception('No "Search" key found in response');
    }
  } else {
    throw Exception('Failed to load data');
  }
}
