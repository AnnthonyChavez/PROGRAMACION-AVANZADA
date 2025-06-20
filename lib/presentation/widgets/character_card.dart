import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback? onTap;

  const CharacterCard({super.key, required this.character, this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.greenAccent,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  character.image,
                  height: 120,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(character.status).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      character.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    character.species,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}