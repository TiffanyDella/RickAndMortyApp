import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/AbtractCharacterList.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/Character.dart';
import 'package:rick_and_morty_app/ViewModel/RickApi/RickApi_event.dart';
import 'package:rick_and_morty_app/ViewModel/RickApi/RickApi_state.dart';



class RickApiBloc extends Bloc<RickApiEvent, RickApiState> {
  final AbtractChacterList repository;
  int _currentPage = 1;
  bool _hasMore = true;

  RickApiBloc(this.repository) : super(RickapiInitial()) {
    on<RickapiLoad>(_onRickapiLoad);
    on<RickapiLoadMore>(_onRickapiLoadMore);
    on<RickapiLoadFromCache>(_onRickapiLoadFromCache);
  }

  Future<void> _onRickapiLoad(
    RickapiLoad event,
    Emitter<RickApiState> emit,
  ) async {
    try {
      emit(RickapiLoading());
      if (event.forceRefresh) {
        _currentPage = 1;
      }
      
      final characters = await repository.getCharacters(page: _currentPage);
      _hasMore = await (repository as CharacterRepository).hasNextPage(_currentPage);
      
      emit(RickapiLoaded(
        characterList: characters,
        hasMore: _hasMore,
        currentPage: _currentPage,
        isLoadingMore: false,
      ));
      
      event.completer?.complete();
    } catch (e) {
      emit(RickapiError(e as Exception));
      event.completer?.completeError(e);
    }
  }

  Future<void> _onRickapiLoadMore(
    RickapiLoadMore event,
    Emitter<RickApiState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RickapiLoaded || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    try {
      final nextPage = currentState.currentPage + 1;
      emit(currentState.copyWith(isLoadingMore: true));
      
      final newCharacters = await repository.getCharacters(page: nextPage);
      _hasMore = await (repository as CharacterRepository).hasNextPage(nextPage);
      
      final allCharacters = [...currentState.characterList, ...newCharacters];
      
      emit(RickapiLoaded(
        characterList: allCharacters,
        hasMore: _hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  void _onRickapiLoadFromCache(
    RickapiLoadFromCache event,
    Emitter<RickApiState> emit,
  ) {
    emit(RickapiCacheLoaded(event.cachedCharacters));
  }
}