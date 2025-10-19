

import 'dart:async';

import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';


abstract class RickApiEvent {
  const RickApiEvent();
}

class RickapiLoad extends RickApiEvent {
  final Completer? completer;
  final bool forceRefresh;
  
  const RickapiLoad({this.completer, this.forceRefresh = false});
}

class RickapiLoadMore extends RickApiEvent {
  const RickapiLoadMore();
}

// События
class RickapiLoadFromCache extends RickApiEvent {
  final List<CharacterModel> cachedCharacters;
  const RickapiLoadFromCache(this.cachedCharacters);
}
