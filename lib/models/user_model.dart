import 'rank_model.dart';

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
  final int xp; // общий опыт пользователя
  final List<String> friends; // список uid друзей
  final bool isOnline; // онлайн-статус

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
    this.xp = 0,
    this.friends = const [],
    this.isOnline = false,
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
      xp: map['xp'] is int ? map['xp'] : 0,
      friends: map['friends'] != null ? List<String>.from(map['friends']) : [],
      isOnline: map['isOnline'] ?? false,
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
      'xp': xp,
      'friends': friends,
      'isOnline': isOnline,
    };
  }

  // Получить текущий уровень ранга
  RankLevel get currentRankLevel {
    for (int i = rankLevels.length - 1; i >= 0; i--) {
      if (xp >= rankLevels[i].totalXp) {
        return rankLevels[i];
      }
    }
    return rankLevels.first;
  }

  // Следующий уровень (или null, если максимальный)
  RankLevel? get nextRankLevel {
    for (final rank in rankLevels) {
      if (rank.totalXp > xp) {
        return rank;
      }
    }
    return null;
  }

  // Прогресс до следующего уровня (0..1)
  double get rankProgress {
    final next = nextRankLevel;
    final curr = currentRankLevel;
    if (next == null) return 1.0;
    final total = next.totalXp - curr.totalXp;
    final earned = xp - curr.totalXp;
    return total > 0 ? earned / total : 1.0;
  }
}
