class DriverBonus {
  const DriverBonus({
    required this.id,
    required this.title,
    required this.description,
  });

  factory DriverBonus.fromJson(Map<String, dynamic> json) {
    return DriverBonus(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Benefício',
      description: json['description'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String description;
}
