import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import 'character_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String searchQuery = '';
  String? selectedStatus;
  String? selectedSpecies;

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(characterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Explorer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar personaje',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: ['Alive', 'Dead', 'unknown']
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedStatus = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSpecies,
                    decoration: const InputDecoration(labelText: 'Especie'),
                    items: ['Human', 'Alien', 'Humanoid', 'Robot', 'unknown']
                        .map((species) => DropdownMenuItem(
                      value: species,
                      child: Text(species),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedSpecies = value);
                    },
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedStatus = null;
                selectedSpecies = null;
              });
            },
            child: const Text('Limpiar filtros'),
          ),
          Expanded(
            child: charactersAsync.when(
              data: (characters) {
                final filteredCharacters = characters.where((c) {
                  final matchesSearch =
                  c.name.toLowerCase().contains(searchQuery);
                  final matchesStatus =
                      selectedStatus == null || c.status == selectedStatus;
                  final matchesSpecies =
                      selectedSpecies == null || c.species == selectedSpecies;
                  return matchesSearch && matchesStatus && matchesSpecies;
                }).toList();

                if (filteredCharacters.isEmpty) {
                  return const Center(child: Text('No se encontraron personajes.'));
                }

                return ListView.builder(
                  itemCount: filteredCharacters.length,
                  itemBuilder: (context, index) {
                    final character = filteredCharacters[index];
                    return CharacterCard(
                      character: character,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CharacterDetailPage(character: character),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}