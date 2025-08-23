class CatBreed {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String temperament;
  final String origin;
  final int energyLevel;
  final int affectionLevel;
  final int intelligence;

  CatBreed({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.temperament,
    required this.origin,
    required this.energyLevel,
    required this.affectionLevel,
    required this.intelligence,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image']?['url'],
      temperament: json['temperament'] ?? '',
      origin: json['origin'] ?? '',
      energyLevel: json['energy_level'] ?? 0,
      affectionLevel: json['affection_level'] ?? 0,
      intelligence: json['intelligence'] ?? 0,
    );
  }
  @override
  String toString() {
    return 'CatBreed(id: $id, name: $name, origin: $origin, energyLevel: $energyLevel, affectionLevel: $affectionLevel, intelligence: $intelligence)';
  }
}
