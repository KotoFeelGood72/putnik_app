class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? avatar;

  UserModel({required this.uid, this.name, this.email, this.avatar});

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'],
      email: map['email'],
      avatar: map['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'avatar': avatar};
  }
}
