class HeroModel {
  final String name;
  final int days;
  final String imageUrl;

  const HeroModel({
    required this.name,
    required this.days,
    required this.imageUrl,
  });

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    return HeroModel(
      name: map['name'] ?? '',
      days: map['days'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'days': days, 'imageUrl': imageUrl};
  }
}
