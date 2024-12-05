import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

Future<List<dynamic>> fetchLogs() async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  final logsUrl = jsonMap['LOGS_URL'];
  final url = '${logsUrl}api/Logs/GetLogs';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data != null) {
      return data;
    } else {
      throw Exception('No "Search" key found in response');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

Future createLog(Map<String, dynamic> log) async {
  try {
    final jsonString = await rootBundle.loadString('assets/config.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final logsUrl = jsonMap['LOGS_URL'];
    final url = '${logsUrl}api/Logs/AddLog';

    final jsonBody = jsonEncode(log);

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody
    );

    if (response.statusCode == 200) {
      print('Log successfully created.');
    } else {
      print('Failed to create log. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while creating log: $e');
  }
}
