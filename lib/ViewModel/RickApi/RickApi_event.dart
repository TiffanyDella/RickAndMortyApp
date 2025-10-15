

import 'dart:async';


abstract class RickApiEvent {
  const RickApiEvent();
}

class RickapiLoad extends RickApiEvent {
  final Completer? completer;
  
  const RickapiLoad({this.completer});
}

class RickapiLoadMore extends RickApiEvent {
  const RickapiLoadMore();
}