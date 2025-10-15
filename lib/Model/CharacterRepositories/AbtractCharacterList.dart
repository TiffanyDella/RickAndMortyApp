import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';

abstract class AbtractChacterList {
  Future<List<CharacterModel>> getCharacters({required int page});
}