class Item { // Get, Update e Delete
  final String id; // id do banco
  final String name;
  final String GTIN; // id global do insumo
  final double wheight;
  final String category;

  const Item({
    required this.id,
    required this.name,
    required this.GTIN,
    required this.wheight,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      GTIN: json['GTIN'],
      wheight: json['wheight'],
      category: json['category'],
    );
  }

  // Método para converter uma instância de Product em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'GTIN': GTIN,
      'wheight': wheight,
      'category': category,
    };
  }
}

class ItemDTO { // Create
  final String name;
  final String GTIN; // id global do insumo
  final double wheight;
  final String category;

  const ItemDTO({
    required this.name,
    required this.GTIN,
    required this.wheight,
    required this.category,
  });

  factory ItemDTO.fromJson(Map<String, dynamic> json) {
    return ItemDTO(
      name: json['name'],
      GTIN: json['GTIN'],
      wheight: json['wheight'],
      category: json['category'],
    );
  }

  // Método para converter uma instância de Product em JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'GTIN': GTIN,
      'wheight': wheight,
      'category': category,
    };
  }
}