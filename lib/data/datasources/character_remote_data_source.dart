import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/character_model.dart';

class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.charactersEndpoint}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar personajes');
    }
  }
}