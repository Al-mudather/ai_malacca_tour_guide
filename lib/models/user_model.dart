class UserModel {
  final int? id;
  final String email;
  final String? password;
  final String? name;
  final int? defaultBudget;
  final bool isAdmin;

  UserModel({
    this.id,
    required this.email,
    this.password,
    this.name,
    this.defaultBudget,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        id: map['id'] as int?,
        email: map['email'] as String,
        password: map['password'] as String?,
        name: map['full_name'] as String?,
        defaultBudget: map['default_budget'] as int?,
        isAdmin: map['is_admin'],
      );
    } catch (e) {
      print('Received map data: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      if (password != null) 'password': password,
      'name': name,
      'default_budget': defaultBudget,
      'is_admin': isAdmin,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
    int? defaultBudget,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      defaultBudget: defaultBudget ?? this.defaultBudget,
      isAdmin: isAdmin,
    );
  }
}
