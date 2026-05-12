class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final StoreModel? store;
  final ClassModel? studentClass;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.store,
    this.studentClass,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      store: json['store'] != null ? StoreModel.fromJson(json['store']) : null,
      studentClass:
          json['class'] != null ? ClassModel.fromJson(json['class']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}

class StoreModel {
  final int id;
  final String name;
  final String username;

  StoreModel({
    required this.id,
    required this.name,
    required this.username,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }
}

class ClassModel {
  final int id;
  final String name;

  ClassModel({required this.id, required this.name});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String username;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      name: json['user']['name'],
      username: json['user']['username'],
      token: json['token'],
    );
  }
}
