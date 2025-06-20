class CharacterModel {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;
  final List<String> episode;

  CharacterModel({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
    required this.episode,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      species: json['species'],
      status: json['status'],
      episode: List<String>.from(json['episode']),
    );
  }
}