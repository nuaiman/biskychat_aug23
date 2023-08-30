import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String imageUrl;
  final String? fcmToken;
  UserModel({
    required this.uid,
    required this.name,
    required this.imageUrl,
    this.fcmToken,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // result.addAll({'uid': uid});
    result.addAll({'name': name});
    result.addAll({'imageUrl': imageUrl});
    if (fcmToken != null) {
      result.addAll({'fcmToken': fcmToken});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      fcmToken: map['fcmToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, imageUrl: $imageUrl, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ imageUrl.hashCode ^ fcmToken.hashCode;
  }
}
