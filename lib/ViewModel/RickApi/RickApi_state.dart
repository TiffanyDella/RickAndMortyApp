import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';




abstract class RickApiState {
  const RickApiState();
}

class RickapiInitial extends RickApiState {}

class RickapiLoading extends RickApiState {}

class RickapiLoadingMore extends RickApiState {
  final List<CharacterModel> currentCharacters;
  
  const RickapiLoadingMore(this.currentCharacters);
  
  @override
  List<Object> get props => [currentCharacters];
}

class RickapiLoaded extends RickApiState {
  final List<CharacterModel> characterList;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;
  
  const RickapiLoaded({
    required this.characterList,
    required this.hasMore,
    required this.currentPage,
    required this.isLoadingMore,
  });

  RickapiLoaded copyWith({
    List<CharacterModel>? characterList,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return RickapiLoaded(
      characterList: characterList ?? this.characterList,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
  
  @override
  List<Object> get props => [characterList, hasMore, currentPage, isLoadingMore];
}

class RickapiCacheLoaded extends RickApiState {
  final List<CharacterModel> cachedCharacters;
  
  const RickapiCacheLoaded(this.cachedCharacters);
  
  @override
  List<Object> get props => [cachedCharacters];
}

class RickapiError extends RickApiState {
  final Exception exception;
  
  const RickapiError(this.exception);
  
  @override
  List<Object> get props => [exception];
}