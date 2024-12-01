class Product {
  final String id;
  final String name;
  final double wheight;
  final String category;
  final String recipe;

  Product({
    required this.id,
    required this.name,
    required this.wheight,
    required this.category,
    required this.recipe,
  });

  // Método para converter de JSON para o modelo
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Desconhecido',
      wheight: (json['wheight'] != null) ? json['wheight'].toDouble() : 0.0,
      category: json['category'] ?? 'Não categorizado',
      recipe: json['recipe'] ?? '',
    );
  }

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'wheight': wheight,
      'category': category,
      'recipe': recipe,
    };
  }
}

class ProductDTO {
  final String name;
  final double wheight;
  final String category;
  final String recipe;

  ProductDTO({
    required this.name,
    required this.wheight,
    required this.category,
    required this.recipe,
  });

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'wheight': wheight,
      'category': category,
      'recipe': recipe,
    };
  }
}