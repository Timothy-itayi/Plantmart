class Plant {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final bool isPopular;
  final bool isNew;

  Plant({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.isPopular = false,
    this.isNew = false,
  });
} 