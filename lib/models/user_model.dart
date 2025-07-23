class UserModel {
  final String uid;
  final String? name;
  final String? surname;
  final int? age;
  final String? city;
  final String? gender;
  final String? bio;
  final String? email;
  final String? avatar;
  final String? role;

  UserModel({
    required this.uid,
    this.name,
    this.surname,
    this.age,
    this.city,
    this.gender,
    this.bio,
    this.email,
    this.avatar,
    this.role,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'],
      surname: map['surname'],
      age:
          map['age'] is int
              ? map['age']
              : int.tryParse(map['age']?.toString() ?? ''),
      city: map['city'],
      gender: map['gender'],
      bio: map['bio'],
      email: map['email'],
      avatar: map['avatar'],
      role: map['role'] ?? 'hero',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'age': age,
      'city': city,
      'gender': gender,
      'bio': bio,
      'email': email,
      'avatar': avatar,
      'role': role,
    };
  }
}
