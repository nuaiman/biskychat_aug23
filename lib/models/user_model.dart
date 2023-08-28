import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String imageUrl;
  UserModel({
    required this.uid,
    required this.name,
    required this.imageUrl,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // result.addAll({'uid': uid});
    result.addAll({'name': name});
    result.addAll({'imageUrl': imageUrl});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, imageUrl: $imageUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
