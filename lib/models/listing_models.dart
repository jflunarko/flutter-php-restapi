class ListingModel {
  final int id;
  final int agentId; // Tambahan agent_id
  final String name;
  final String street;
  final String price;
  final String category;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ListingModel({
    required this.id,
    required this.agentId, // Penyesuaian field
    required this.name,
    required this.street,
    required this.price,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      agentId: json['agent_id'], // Mapping agent_id
      name: json['name'],
      street: json['street'],
      price: json['price'],
      category: json['category'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  @override
  String toString() {
    return 'ID: $id, Agent ID: $agentId, Name: $name, Street: $street, Price: $price, Category: $category, Created At: $createdAt, Updated At: $updatedAt, Deleted At: $deletedAt';
  }
}
