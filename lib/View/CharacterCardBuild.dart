import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/Model/CharacterRepositories/CharacterModel.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({
    super.key,
    required this.character,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  final CharacterModel character;
  final bool isFavorite;
  final VoidCallback toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.blue, width: 2.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                character.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey,
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Flexible(
              child: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              character.status,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
                size: 30,
              ),
              onPressed: toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}