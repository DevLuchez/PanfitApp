class Product {
  final String id;
  final String name;
  final double weight;
  final String category;
  final String recipe;

  Product({
    required this.id,
    required this.name,
    required this.weight,
    required this.category,
    required this.recipe,
  });

  // Método para converter de JSON para o modelo
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Desconhecido',
      weight: (json['weight'] != null) ? json['weight'].toDouble() : 0.0,
      category: json['category'] ?? 'Não categorizado',
      recipe: json['recipe'] ?? '',
    );
  }

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'category': category,
      'recipe': recipe,
    };
  }
}

class ProductDTO {
  final String name;
  final double weight;
  final String category;
  final String recipe;

  ProductDTO({
    required this.name,
    required this.weight,
    required this.category,
    required this.recipe,
  });

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'category': category,
      'recipe': recipe,
    };
  }
}