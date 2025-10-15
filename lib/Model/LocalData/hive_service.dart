import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';

class HiveService {
  static const String _favoritesBox = 'favorites_box';
  late Box<CharacterModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<CharacterModel>(_favoritesBox);
  }

  Future<void> addToFavorites(CharacterModel character) async {
    await _box.put(character.id, character);
  }

  Future<void> removeFromFavorites(int characterId) async {
    await _box.delete(characterId);
  }

  List<CharacterModel> getFavorites() {
    return _box.values.toList();
  }

  bool isFavorite(int characterId) {
    return _box.containsKey(characterId);
  }
}