class UserModel {
  final int? id;
  final String email;
  final String password;
  final String? name;
  final int? defaultBudget;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    this.name,
    this.defaultBudget,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String?,
      defaultBudget: map['default_budget'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'default_budget': defaultBudget,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
    int? defaultBudget,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      defaultBudget: defaultBudget ?? this.defaultBudget,
    );
  }
}
