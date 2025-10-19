import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';
import 'package:rick_and_morty_app/View/CharacterCardBuild.dart';
import 'package:rick_and_morty_app/Model/LocalData/hive_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final HiveService _hiveService = HiveService();
  List<CharacterModel> _allFavorites = [];
  List<CharacterModel> _displayedFavorites = [];
  bool _isLoading = true;
  String _activeFilter = 'A-Z';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await _hiveService.init();
    if (mounted) {
      setState(() {
        _allFavorites = _hiveService.getFavorites();
        _applyFilter(_activeFilter);
        _isLoading = false;
      });
    }
  }

  void _removeFromFavorites(CharacterModel character) {
    _hiveService.removeFromFavorites(character.id);
    setState(() {
      _allFavorites = _hiveService.getFavorites();
      _applyFilter(_activeFilter);
    });
  }

  void _applyFilter(String filterType) {
    List<CharacterModel> result = List.from(_allFavorites);

    switch (filterType) {
      case 'A-Z': result.sort((a, b) => a.name.compareTo(b.name)); break;
      case 'Z-A': result.sort((a, b) => b.name.compareTo(a.name)); break;
      case 'Alive': result = _filterByStatus('Alive'); break;
      case 'Dead': result = _filterByStatus('Dead'); break;
      case 'unknown': result = _filterByStatus('unknown'); break;
    }

    setState(() {
      _activeFilter = filterType;
      _displayedFavorites = result;
    });
  }

  List<CharacterModel> _filterByStatus(String status) {
    return _allFavorites
        .where((character) => character.status == status)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  void _showFilterMenu(BuildContext context) {
    final filters = {
      'A-Z': Icons.arrow_upward,
      'Z-A': Icons.arrow_downward,
      'Alive': Icons.favorite,
      'Dead': Icons.cancel,
      'unknown': Icons.help,
    };
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1, 1, 0, 0),
      items: filters.entries.map((entry) => PopupMenuItem<String>(
        value: entry.key,
        child: Row(
          children: [
            Icon(entry.value, size: 20),
            const SizedBox(width: 12),
            Text(entry.key),
            if (_activeFilter == entry.key) ...[
              const Spacer(),
              const Icon(Icons.check, color: Colors.blue, size: 20),
            ],
          ],
        ),
      )).toList(),
    ).then((selectedFilter) {
      if (selectedFilter != null) _applyFilter(selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterMenu(context),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _displayedFavorites.isEmpty 
              ? const _EmptyState() 
              : _FavoritesList(
                  favorites: _displayedFavorites,
                  onRemove: _removeFromFavorites,
                ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final List<CharacterModel> favorites;
  final Function(CharacterModel) onRemove;

  const _FavoritesList({
    required this.favorites,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final character = favorites[index];
        return CharacterTile(
          character: character,
          isFavorite: true,
          toggleFavorite: () => onRemove(character),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Нет избранных персонажей',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}