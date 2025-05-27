class ItemCategory {
  final String name;

  ItemCategory({required this.name});
}

final List<ItemCategory> itemCategories = [
  ItemCategory(name: 'Obat Demam'),
  ItemCategory(name: 'Obat Nyeri Otot'),
  ItemCategory(name: 'Alkohol'),
  ItemCategory(name: 'Vitamin'),
  ItemCategory(name: 'Suplemen'),
  ItemCategory(name: 'Obat Flu'),
  ItemCategory(name: 'Tablet'),
  ItemCategory(name: 'Pill'),
  ItemCategory(name: 'Sirup'),
  ItemCategory(name: 'Anti Depresan'),
];

class ObatDemam {
  final String name;
  final double rating;
  final int pricing;

  ObatDemam({required this.name, required this.rating, required this.pricing});
}

final List<ObatDemam> obatDemamItems = [
  ObatDemam(name: 'Obat Demam A', rating: 4.5, pricing: 15000),
  ObatDemam(name: 'Obat Demam B', rating: 4.0, pricing: 12000),
  ObatDemam(name: 'Obat Demam C', rating: 3.8, pricing: 10000),
  ObatDemam(name: 'Obat Demam D', rating: 4.2, pricing: 14000),
];
