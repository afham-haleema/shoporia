class UserModel {
  String name, email, address, phone;
  UserModel(
      {required this.address,
      required this.email,
      required this.name,
      required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        address: json['address'] ?? '',
        email: json['email'] ?? '',
        name: json['name'] ?? 'User',
        phone: json['phone'] ?? '');
  }
}
