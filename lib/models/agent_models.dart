class AgentModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String status;
  final String createdAt;
  final String updatedAt;

  AgentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Email: $email, Password: $password, Status: $status, Created At: $createdAt, Updated At: $updatedAt';
  }
}
