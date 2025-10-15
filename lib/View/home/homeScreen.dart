import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/Character.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';
import 'package:rick_and_morty_app/View/CharacterCardBuild.dart';
import 'package:rick_and_morty_app/Model/LocalData/hive_service.dart';
import 'package:rick_and_morty_app/ViewModel/RickApi/RickApi_bloc.dart';
import 'package:rick_and_morty_app/ViewModel/RickApi/RickApi_event.dart';
import 'package:rick_and_morty_app/ViewModel/RickApi/RickApi_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HiveService _hiveService = HiveService();
  final CharacterRepository _charactersRepository = CharacterRepository();
  late final RickApiBloc _characterListBloc;
  List<CharacterModel> favoriteCharacters = [];
  bool _isHiveInitialized = false;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _characterListBloc = RickApiBloc(_charactersRepository);
    _initHiveAndLoadData();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() {
    final state = _characterListBloc.state;
    if (state is RickapiLoaded && state.hasMore && !state.isLoadingMore) {
      _characterListBloc.add(RickapiLoadMore());
    }
  }

  Future<void> _initHiveAndLoadData() async {
    await _hiveService.init();
    if (mounted) {
      setState(() {
        _isHiveInitialized = true;
        favoriteCharacters = _hiveService.getFavorites();
      });
    }
    _characterListBloc.add(RickapiLoad());
  }

  void _toggleFavorite(CharacterModel character) {
    if (!_isHiveInitialized) return;
    
    setState(() {
      if (_hiveService.isFavorite(character.id)) {
        _hiveService.removeFromFavorites(character.id);
        favoriteCharacters.removeWhere((c) => c.id == character.id);
      } else {
        _hiveService.addToFavorites(character);
        favoriteCharacters.add(character);
      }
    });
  }

  bool _isFavorite(int characterId) {
    return _isHiveInitialized && _hiveService.isFavorite(characterId);
  }

  Future<void> _refreshData() async {
    final completer = Completer();
    _characterListBloc.add(RickapiLoad(completer: completer));
    return completer.future;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _characterListBloc.close();
    super.dispose();
  }

 Widget _buildLoadingIndicator() {
  return const SizedBox(
    height: 60,
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Загрузка...'),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty List'),
      ),
      body: BlocProvider(
        create: (context) => _characterListBloc,
        child: BlocBuilder<RickApiBloc, RickApiState>(
          builder: (context, state) {
            if (!_isHiveInitialized) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is RickapiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RickapiError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.exception.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is RickapiLoaded) {
              return RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.characterList.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.characterList.length) {
                      return _buildLoadingIndicator();
                    }
                    final character = state.characterList[index];
                    return CharacterTile(
                      character: character,
                      isFavorite: _isFavorite(character.id),
                      toggleFavorite: () => _toggleFavorite(character),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}