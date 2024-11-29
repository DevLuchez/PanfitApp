class Product {
  final String id;
  final String name;
  final double weight;
  final String category;
  final String recipe;
  final double salePrice;

  Product({
    required this.id,
    required this.name,
    required this.weight,
    required this.category,
    required this.recipe,
    required this.salePrice,
  });

  // Método para converter de JSON para o modelo
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      weight: json['weight'],
      category: json['category'],
      recipe: json['recipe'],
      salePrice: json['salePrice'],
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
      'salePrice': salePrice,
    };
  }
}

class ProductDTO {
  final String name;
  final double weight;
  final String category;
  final String recipe;
  final double salePrice;

  ProductDTO({
    required this.name,
    required this.weight,
    required this.category,
    required this.recipe,
    required this.salePrice,
  });

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'category': category,
      'recipe': recipe,
      'salePrice': salePrice,
    };
  }
}