

import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';

@immutable
abstract class RickApiState {
  const RickApiState();
}

class RickapiInitial extends RickApiState {}

class RickapiLoading extends RickApiState {}

class RickapiLoadingMore extends RickApiState {
  final List<CharacterModel> currentCharacters;
  
  const RickapiLoadingMore(this.currentCharacters);
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
    this.isLoadingMore = false,
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
}

class RickapiError extends RickApiState {
  final Exception exception;
  
  const RickapiError(this.exception);
}