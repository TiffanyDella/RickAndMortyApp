import 'package:dio/dio.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/AbtractCharacterList.dart';

class CharacterRepository implements AbtractChacterList {
  final Dio _dio = Dio();

  @override
  Future<List<CharacterModel>> getCharacters({int page = 1}) async {
    try {
      final response = await _dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': page},
      );
      final data = response.data as Map<String, dynamic>;
      final dataResults = data['results'] as List<dynamic>;
      
      final characters = dataResults.map((characterData) {
        return CharacterModel(
          id: characterData['id'],
          name: characterData['name'],
          imageUrl: characterData['image'],
          status: characterData['status'],
        );
      }).toList();
      
      return characters;
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  Future<bool> hasNextPage(int currentPage) async {
    try {
      final response = await _dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': currentPage},
      );
      final data = response.data as Map<String, dynamic>;
      final info = data['info'] as Map<String, dynamic>;
      return info['next'] != null;
    } catch (e) {
      return false;
    }
  }
}
