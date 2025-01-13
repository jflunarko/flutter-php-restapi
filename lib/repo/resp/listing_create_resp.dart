class ListingModel {
  final int id;
  final int agentId;
  final String name;
  final String street;
  final String price;
  final String category;
  final String createdAt;
  final String updatedAt;
  ListingModel({
    required this.id,
    required this.agentId,
    required this.name,
    required this.street,
    required this.price,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });
  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      agentId: json['agent_id'],
      name: json['name'],
      street: json['street'],
      price: json['price'],
      category: json['category'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
