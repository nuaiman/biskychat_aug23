import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskychat_aug23/models/message_model.dart';
import 'package:biskychat_aug23/models/user_model.dart';

class ChatModel {
  final String key;
  final UserModel currentUser;
  final UserModel otherUser;
  final List<MessageModel> messages;
  ChatModel({
    required this.key,
    required this.currentUser,
    required this.otherUser,
    required this.messages,
  });

  ChatModel copyWith({
    String? key,
    UserModel? currentUser,
    UserModel? otherUser,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      key: key ?? this.key,
      currentUser: currentUser ?? this.currentUser,
      otherUser: otherUser ?? this.otherUser,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'currentUser': currentUser.toMap()});
    result.addAll({'otherUser': otherUser.toMap()});
    result.addAll({'messages': messages.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      key: map['key'] ?? '',
      currentUser: UserModel.fromMap(map['currentUser']),
      otherUser: UserModel.fromMap(map['otherUser']),
      messages: List<MessageModel>.from(
          map['messages']?.map((x) => MessageModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(key: $key, currentUser: $currentUser, otherUser: $otherUser, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.key == key &&
        other.currentUser == currentUser &&
        other.otherUser == otherUser &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode {
    return key.hashCode ^
        currentUser.hashCode ^
        otherUser.hashCode ^
        messages.hashCode;
  }
}
