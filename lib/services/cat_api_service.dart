import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pragma_prueba/models/cat_breed.dart';

class CatApiService {
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  final String apiKey;
  CatApiService({required this.apiKey});

  Future<List<CatBreed>> getBreeds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/breeds'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);

        return data.map((json) => CatBreed.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar razas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
