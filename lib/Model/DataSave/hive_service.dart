import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';

class HiveService {
  late Box<CharacterModel> _favoritesBox;
  late Box<CharacterModel> _charactersCacheBox;

  Future<void> init() async {
    _favoritesBox = await Hive.openBox<CharacterModel>('favorites_box');
    _charactersCacheBox = await Hive.openBox<CharacterModel>('characters_cache_box');
  }

  Future<void> addToFavorites(CharacterModel character) async {
    await _favoritesBox.put(character.id, character);
  }

  Future<void> removeFromFavorites(int characterId) async {
    await _favoritesBox.delete(characterId);
  }

  List<CharacterModel> getFavorites() {
    return _favoritesBox.values.toList();
  }

  bool isFavorite(int characterId) {
    return _favoritesBox.containsKey(characterId);
  }

  Future<void> saveCharacters(List<CharacterModel> characters) async {
    for (final character in characters) {
      await _charactersCacheBox.put(character.id, character);
    }
  }

  List<CharacterModel> getCachedCharacters() {
    return _charactersCacheBox.values.toList();
  }

  bool hasCachedCharacters() {
    return _charactersCacheBox.isNotEmpty;
  }

  Future<void> clearCache() async {
    await _charactersCacheBox.clear();
  }
}