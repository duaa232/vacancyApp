import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/models/vacancy.dart';

Future<List<Vacancy>> fetchVacancies() async {
  final response =
      await http.get(Uri.parse('https://www.unhcrjo.org/jobs/api'));

  if (response.statusCode == 200) {
    final List<dynamic> vacancyJson = json.decode(response.body);
    return vacancyJson.map((json) => Vacancy.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load vacancies');
  }
}
