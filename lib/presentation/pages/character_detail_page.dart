import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/models/character_model.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailPage({super.key, required this.character});

  // 🔍 Función para obtener el nombre del episodio desde su URL
  Future<String> fetchEpisodeName(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'];
      } else {
        return 'Episodio desconocido';
      }
    } catch (e) {
      return 'Error cargando episodio';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              character.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Especie: ${character.species}'),
                  Text('Estado: ${character.status}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Episodios:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...character.episode.map((url) => FutureBuilder<String>(
                    future: fetchEpisodeName(url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Cargando episodio...'),
                        );
                      } else if (snapshot.hasError) {
                        return const ListTile(
                          title: Text('Error al cargar episodio'),
                        );
                      } else {
                        return ListTile(
                          leading: const Icon(Icons.tv, color: Colors.green),
                          title: Text(snapshot.data ?? 'Nombre no disponible'),
                        );
                      }
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}