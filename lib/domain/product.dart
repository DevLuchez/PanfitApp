class Product {
  final String id;
  final String name;
  final double wheight;
  final String category;
  final String receipe;

  Product({
    required this.id,
    required this.name,
    required this.wheight,
    required this.category,
    required this.receipe,
  });

  // Método para converter de JSON para o modelo
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Desconhecido',
      wheight: (json['wheight'] != null) ? json['wheight'].toDouble() : 0.0,
      category: json['category'] ?? 'Não categorizado',
      receipe: json['receipe'] ?? '',
    );
  }

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'wheight': wheight,
      'category': category,
      'receipe': receipe,
    };
  }
}

class ProductDTO {
  final String name;
  final double wheight;
  final String category;
  final String receipe;

  ProductDTO({
    required this.name,
    required this.wheight,
    required this.category,
    required this.receipe,
  });

  // Método para converter do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'wheight': wheight,
      'category': category,
      'receipe': receipe,
    };
  }
}