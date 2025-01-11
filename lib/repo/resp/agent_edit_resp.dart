class AgentResponse {
  final int id;
  final String name;
  final String email;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  AgentResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory AgentResponse.fromJson(Map<String, dynamic> json) {
    return AgentResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'], // Optional field
    );
  }

  // Method to convert AgentResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  // Helper to check if agent is active
  bool get isActive => status.toLowerCase() == 'active';

  // Override toString for easier debugging
  @override
  String toString() {
    return 'ID: $id, Name: $name, Email: $email, Status: $status, Created At: $createdAt, Updated At: $updatedAt, Deleted At: $deletedAt';
  }
}
