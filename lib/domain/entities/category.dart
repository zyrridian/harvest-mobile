class Category {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String? iconName;
  final List<String> gradientColors;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.iconName,
    required this.gradientColors,
    required this.productCount,
  });
}
