class Product {
  final String id;
  final String name;
  final double wheight;
  final String category;
  final String recipe;
  final double sale_price;
  final double stock_wheight;

  Product({
    required this.id,
    required this.name,
    required this.wheight,
    required this.category,
    required this.recipe,
    required this.sale_price,
    required this.stock_wheight,

  });

  // Método para converter de JSON para o modelo
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Desconhecido',
      wheight: (json['wheight'] != null) ? json['wheight'].toDouble() : 0.0,
      category: json['category'] ?? 'Não categorizado',
      recipe: json['recipe'] ?? '',
      sale_price: (json['sale_price'] != null) ? json['sale_price'].toDouble() : 0.0,
      stock_wheight: (json['stock_wheight'] != null) ? json['stock_wheight'].toDouble() : 0.0,

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
      'sale_price': sale_price,
    };
  }
}



class ProductDTO {
  final String name;
  final double wheight;
  final String category;
  final String recipe;
  final double sale_price;

  ProductDTO({
    required this.name,
    required this.wheight,
    required this.category,
    required this.recipe,
    required this.sale_price,
  });

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'wheight': wheight,
      'category': category,
      'recipe': recipe,
      'sale_price': sale_price,
    };
  }
}